window.addEventListener("load", () => {
  const quizSubmitButton = document.querySelector("#quiz-restart-btn")
  
  quizSubmitButton.addEventListener("click", (event) => {
    location.reload();
  })
});

window.addEventListener("load", () => {
  const quizSubmitButton = document.querySelector("#quiz-reset-btn")
  
  quizSubmitButton.addEventListener("click", (event) => {
    document.querySelector("#quiz-results").classList.add("hidden")
    document.querySelectorAll(".quiz-answers").forEach((element) => {
        element.checked = false
    })
    document.querySelectorAll("div[data-quiz-question-number]")[0].classList.remove("hidden")
  })
});

window.displayPreviousQuestion = (questionToDisplay) => {
  const questions = document.querySelectorAll("div[data-quiz-question-number]")
  
  questions.forEach((element) => {
    if(element.dataset.quizQuestionNumber == questionToDisplay){
      element.classList.remove("hidden")
    }else{
      element.classList.add("hidden")
    }
  })
}

window.displayNextQuestion = (questionToDisplay) => {
  const questions = document.querySelectorAll("div[data-quiz-question-number]")
  
  //minus 2, as the questionToDisplay variable starts at 1, and i want the previous
  //question
  const possibleAnswers = questions[questionToDisplay-2].querySelectorAll(".quiz-answers")
  
  let isAnswered = false
  
  possibleAnswers.forEach(answer => {
    if(answer.checked){
      isAnswered = true
    }
  })
  
  if(isAnswered){
    questions.forEach((element) => {
      if(element.dataset.quizQuestionNumber == questionToDisplay){
        element.classList.remove("hidden")
      }else{
        element.classList.add("hidden")
      }
    })
  }else{
    alert("Select an answer before continuing")
  }
}

window.submitQuiz = () => {
  const questionAmount = document.querySelector("div[data-questions-amount]").dataset.questionsAmount;
  const questions = document.querySelectorAll("div[data-quiz-question-number]")
  
  let quizAnswers = []
  
  for(let i = 0; i < questionAmount; i++){
    let possibleAnswers = questions[i].querySelectorAll(".quiz-answers")
    let questionAnswers = []
    possibleAnswers.forEach((element) => {
      if(element.checked){
        //Adding _correct to put answers in same format as answers array
        questionAnswers.push(`${element.value}_correct`)
      }
    })
    quizAnswers.push(questionAnswers)
  }
  
  const quizCorrectAnswers = JSON.parse(document.querySelector("div[data-quiz-correct-answers]").dataset.quizCorrectAnswers)
  let correctAnswerCount = 0
  
  for(let i = 0; i < questionAmount; i++){
    let userAnswers = quizAnswers[i]
    let correctAnswers = quizCorrectAnswers[i]
    if(compareArrays(userAnswers, correctAnswers)){
      correctAnswerCount++
    }
  }
  
  document.querySelector("#quiz-results-score").innerHTML = correctAnswerCount
  document.querySelector("#quiz-results").classList.remove("hidden")
  questions[questions.length-1].classList.add("hidden")
  
  setHistoryCookie(correctAnswerCount, questionAmount)
}

window.setHistoryCookie = (correctAnswerCount, questionAmount) => {
  let cookieString = `You got ${correctAnswerCount}/${questionAmount} on ${new Date().toLocaleString()}`
  let historyCookie = getCookie("quizplus_quizhistory")
  let historyCookieParsed = historyCookie == "" ? [] : JSON.parse(historyCookie)
  
  if(historyCookieParsed.length == 5){
    for(let i = 0; i < historyCookieParsed.length - 1; i++){
      historyCookieParsed[i] = historyCookieParsed[i + 1]
    }
    historyCookieParsed[historyCookieParsed.length - 1] = cookieString
  }else{
    historyCookieParsed.push(cookieString)
  }
  
  document.cookie = `quizplus_quizhistory=${JSON.stringify(historyCookieParsed)}`
}

window.compareArrays = (array1, array2) => {
  if(array1.length !== array2.length){
    return false;
  }
  
  array1 = array1.sort()
  array2 = array2.sort()
  
  for(let i = 0; i < array1.length; i++){
    if(array1[i] !== array2[i]){
      return false;
    }
  }
  
  return true
}