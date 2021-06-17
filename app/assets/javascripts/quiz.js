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
  
  for(i = 0; i < questionAmount; i++){
    let possibleAnswers = questions[i].querySelectorAll(".quiz-answers")
    questionAnswers = []
    possibleAnswers.forEach((element) => {
      if(element.checked){
        questionAnswers.push(element.value)
      }
    })
    quizAnswers.push(questionAnswers)
  }
  
  console.log(quizAnswers)
  
}