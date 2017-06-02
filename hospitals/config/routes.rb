Rails.application.routes.draw do
  #general
  get "/" => 'user#entry'

  #USER--------
  get 'user/entry' => 'user#entry'
  post 'user/magia' => 'user#magia'
  get 'user/appmagic' => 'user#appmagic'

  #HOSPITAL---------
  get 'hospital/index' => 'hospital#index'
  post 'hospital/procesar' => 'hospital#procesar'

end
