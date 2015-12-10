Rails.application.routes.draw do

  root to: 'files#index'
  post 'convert' => 'files#convert'

end
