class QuizController < ApplicationController
  helper_method :is_multi_answer_question
  
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
  
  def is_multi_answer_question(question)
    
    # This is staying here while I figure out whether or not
    # all questions should let you go with multi choice
    # in 80+ or just hard ones
    # answer_count = 0
    # question['correct_answers'].each do |key, is_correct_answer|
    #   if is_correct_answer.downcase == 'true'
    #     answer_count += 1
    #   end
    # end
    
    # answer_count > 1
    true
  end
  
  private 
  
    # Only allow a list of trusted parameters through.
    def quiz_params
      params.permit(:difficulty, :number, :categories => [])
    end
    
    def retrieve_quiz_questions(quiz_params)
      
      # Randomly assign a certain number of questions per selected 
      # category selected by the user
      random_integer_limit = quiz_params[:number].to_i
      # category_limits will store how many questions for each category there
      # should be
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
      category_question_lists = [];
      begin
        base_url = "https://quizapi.io/api/v1/questions?apiKey=59keJx4a326CrYjoGvrbaMTB8Jrps943N4b33nwU&difficulty=#{quiz_params[:difficulty]}"
        quiz_params[:categories].each_with_index do |category, index| 
          request_url = "#{base_url}&category=#{category}"
          response = HTTParty.get(request_url)
          if response.code != 200 && response.code != 404
            throw StandardError.new(response.code)
          elsif response.code == 404
            category_question_lists.append([])
          else
            category_question_lists.append(response) 
          end
        end
      rescue HTTParty::Error, StandardError => e
        puts e
        puts "Error with quizapi request, using local instance"
        questions_list = filterLocal quiz_params
        return questions_list
      end
      
      # dealing with some categories not having many (or ANY) of some question difficulties
      # tries to make a quiz of the specified length using any category which has enough questions 
      # to fill the gaps
      # eg. Programming category may have been set to be 2 of the questions, 
      # but the request for questions came back with only 1
      # however Linux category is meant to have 3 questions, but has 5 more 
      # in the returned data, so one more will be added to the Linux category for the quiz
      category_question_lists.each_with_index do |category_results, index|
        if category_results.length < category_limits[index]
          difference = category_limits[index] - category_results.length
          
          category_question_lists.each_with_index do |secondary_category_results, secondary_index|
            if secondary_category_results.length >= category_limits[secondary_index] + difference
              category_limits[secondary_index] = category_limits[secondary_index] + difference
              break
            end
          end
          
          category_limits[index] = category_results.length
        end
      end
      
      # Creating list of questions for the quiz based on the how many 
      # for each category have been defined in category_limits
      category_question_lists.each_with_index do |category_results, index|
        for i in 0..category_limits[index]-1
          questions_list.append(category_results[i])
        end
      end
      
      
      return questions_list
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