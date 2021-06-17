Rails.application.routes.draw do
  root 'home#index'
  resources :histories, only: %i[create]
  get 'history', to: 'histories#index'
  
  post 'form_submit', to: 'home#form_submit'
  
  get 'quiz', to: 'quiz#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
