Rails.application.routes.draw do

  get 'hospital/index' => 'hospital#index'
  post 'hospital/procesar' => 'hospital#procesar'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
