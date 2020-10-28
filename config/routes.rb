Rails.application.routes.draw do
  get 'checking/index'
  get 'checking/result'
  get 'checking/subsection_result'
  get 'checking/pdf_report_to_email'

  root 'checking#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
