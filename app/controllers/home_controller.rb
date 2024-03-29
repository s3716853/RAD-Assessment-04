class HomeController < ApplicationController
  def index
    prefill_params = form_prefill_params
    
    @difficulty = prefill_params[:difficulty]
    @categories = prefill_params[:categories]
    @number = prefill_params[:number].to_i
    
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
    
      redirect_to "/quiz?#{get_request_string}"
    end
  end
  
  private 
  
    # Only allow a list of trusted parameters through.
    def quiz_params
      params.permit(:difficulty, :categories_linux, :categories_devops, :categories_networking, :categories_programming, :number)
    end
    
    def form_prefill_params
      params.permit(:difficulty, :number, :categories => [])
    end
end
