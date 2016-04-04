Rails.application.routes.draw do

  namespace :api do 
    namespace :v1 do 
      resources :schemas, only:[:index,:show]
      %w(loans).each do |res|
        get "#{res}",     to: 'railson#index'
        get "#{res}/:id", to: 'railson#show'
      end
    end
  end 

end
