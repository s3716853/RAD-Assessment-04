window.addEventListener("load", () => {
  const nextQuestionButtons = document.querySelectorAll("button[data-quiz-next-target]")
  
  nextQuestionButtons.forEach((element) => {
    
    element.addEventListener("click", (event) => {
      
      displayNextQuestion(element.dataset.quizNextTarget)
      
    });
    
  });
});

window.addEventListener("load", () => {
  const quizSubmitButton = document.querySelector("#quiz-submit-btn")
  
  quizSubmitButton.addEventListener("click", (event) => {
    submitQuiz()
  })
});

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

window.displayNextQuestion = (questionToDisplay) => {
  const questions = document.querySelectorAll("div[data-quiz-question-number]")
  
  questions.forEach((element) => {
    if(element.dataset.quizQuestionNumber == questionToDisplay){
      element.classList.remove("hidden")
    }else{
      element.classList.add("hidden")
    }
  })
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
  
  document.querySelector("#quiz-results-score").innerHTML = correctAnswerCount;
  document.querySelector("#quiz-results").classList.remove("hidden")
  
  questions[questions.length-1].classList.add("hidden")
  
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