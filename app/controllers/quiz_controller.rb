class QuizController < ApplicationController
  def index

    @questions = retrieve_quiz_questions quiz_params
    
    @history = cookies[:quizplus_quizhistory] ? JSON.parse(cookies[:quizplus_quizhistory]) : []
    
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
    
    def retrieve_quiz_questions(quiz_params)
      
      random_integer_limit = quiz_params[:number].to_i
      category_limits = []
      quiz_params[:categories].each_with_index do |category, index|
        if index + 1 == quiz_params[:categories].length
          category_limits.push(random_integer_limit)
        else
          limit = random_integer_limit != 0 ? rand(random_integer_limit) : 0
          category_limits.push(limit)
          random_integer_limit -= limit
        end
      end
      
      questions_list = [];
      begin
        throw StandardError.new()
        base_url = "https://quizapi.io/api/v1/questions?apiKey=59keJx4a326CrYjoGvrbaMTB8Jrps943N4b33nwU&difficulty=#{quiz_params[:difficulty]}"
        quiz_params[:categories].each_with_index do |category, index|
          request_url = "#{base_url}&limit=#{category_limits[index]}&category=#{category}"
          response = HTTParty.get(request_url)
          if response.code != 200
            throw StandardError.new(response.code)
          end
          questions_list = questions_list + response
        end
      rescue HTTParty::Error, StandardError
        puts "Error with quizapi request, using local instance"
        questions_list = filterLocal quiz_params
      end
      
      questions_list
    end
    
    def filterLocal(quiz_params)
  
      where_string = "("
      where_array = []
      
      quiz_params[:categories].each_with_index do |category, index|
        where_array.append(category)
        if index != 0 
          where_string += " OR "
        end
        where_string += "category = ?"
      end
      
      where_array.append(quiz_params[:difficulty])
      # where_array.append(quiz_params[:number])
      where_string += ") AND difficulty = ?"
      quiz_questions = Question.where(where_string, *where_array).order('RANDOM()')
      
      return_questions = []
      for i in 0..quiz_params[:number].to_i - 1
        if i >= quiz_questions.length
          break
        end
        return_questions[i] = quiz_questions[i]
      end
      
      return_questions
    end
end