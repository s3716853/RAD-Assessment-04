class QuizController < ApplicationController
  def index

    allowed_questions = filter_questions retrieve_quiz_questions, quiz_params
    
    questions_index = []
    @questions = []
    for i in 0..quiz_params[:number].to_i do
      continue_search = true
      early_end = 1000
      while continue_search do
        random_integer = rand(allowed_questions.length - 1)
        if !questions_index.include?(random_integer)
          questions_index.append(random_integer)
          @questions.append(allowed_questions[random_integer])
          continue_search = false
        end
        early_end -= 1
        if early_end == 0
          break
        end
      end
    end
    
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
        if question['difficulty'] == quiz_params[:difficulty] && quiz_params[:categories].includes?(question['category'])
          allowed_questions.append(question)
        end
      end
      
      allowed_questions
    end
end