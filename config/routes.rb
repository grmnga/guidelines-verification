Rails.application.routes.draw do
  get 'checking/index'
  get 'checking/result'

  root 'checking#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
