Rails.application.routes.draw do

  namespace :api do 
    namespace :v1 do 
      resources :loans, only:[:index, :show] 
    end
  end # scope API

end
