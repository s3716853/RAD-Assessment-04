class QuizController < ApplicationController
  def index

    allowed_questions = filter_questions retrieve_quiz_questions, quiz_params
    
    questions_index = []
    @questions = []
    for i in 1..quiz_params[:number].to_i do
      continue_search = true
      early_end = 1000
      while continue_search do
        random_integer = rand(allowed_questions.length - 1)
        if !questions_index.include?(random_integer)
          questions_index.append(random_integer)
          @questions.append(allowed_questions[random_integer])
          continue_search = false
        end
        
        #there is the possiblity when running of the local quiz.json that there 
        #arent enough distinct questions that match the quiz parameters
        #which would cause an infinite loop, thereofr the following is for that possiblity
        if @questions.length == allowed_questions.length
          continue_search = false
        
        end
      end
    end
    
    #getting correct answers for the javascript
    @questions_correct_answers = []
    @questions.each do |question|
      question_correct_answers = []
      question['correct_answers'].each do |key, answer_is_correct|
        if answer_is_correct.downcase == 'true'
          question_correct_answers.append(key)
        end
      end
      @questions_correct_answers.push(question_correct_answers)
    end
    @questions_correct_answers = @questions_correct_answers.to_json
    
  end
  
  private 
  
    # Only allow a list of trusted parameters through.
    def quiz_params
      params.permit(:difficulty, :number, :categories => [])
    end
    
    def retrieve_quiz_questions
      quiz_file = File.read('quiz.json')
      JSON.parse(quiz_file)
    end
    
    def filter_questions(quiz_questions, quiz_params)
      allowed_questions = []
      quiz_questions.each do |question|
        if question['difficulty'] == quiz_params[:difficulty] && quiz_params[:categories].include?(question['category'])
          allowed_questions.append(question)
        end
      end
      
      allowed_questions
    end
end