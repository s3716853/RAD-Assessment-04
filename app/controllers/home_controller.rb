class HomeController < ApplicationController
  def index
  end
  
  def form_submit
    
    user_params = quiz_params
    categories = [{ key: :categories_linux, name: 'Linux'},
                  { key: :categories_devops, name: 'DevOps'},
                  { key: :categories_networking, name: 'Networking'},
                  { key: :categories_programming, name: 'Programming'}]
    get_request_string = ''
    
    categories.each do |category|
      if user_params[category[:key]] == '1'
        get_request_string += "categories[]=#{category[:name]}&"
      end
    end
    
    #HTML doesnt support checkbox group required, therefore need to deal with it here
    if get_request_string.length == 0
      flash.alert = "Please select at least one category"
      redirect_to "/"
    else
      get_request_string += "difficulty=#{user_params[:difficulty]}&number=#{user_params[:number]}"
    
      redirect_to "/?#{get_request_string}"
    end
  end
  
  private 
  
    # Only allow a list of trusted parameters through.
    def quiz_params
      params.permit(:difficulty, :categories_linux, :categories_devops, :categories_networking, :categories_programming, :number)
    end
  
end
