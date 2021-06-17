Rails.application.routes.draw do
  root 'home#index'
  
  post 'form_submit', to: 'home#form_submit'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
