Rails.application.routes.draw do
  #USER--------
  get 'user/entry' => 'user#entry'
  post 'user/magia' => 'user#magia'

  #HOSPITAL---------
  get 'hospital/index' => 'hospital#index'
  post 'hospital/procesar' => 'hospital#procesar'

end
