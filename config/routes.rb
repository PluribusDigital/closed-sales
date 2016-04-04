Rails.application.routes.draw do

  root to: redirect('/app/build/')
  get '/app/assets/:folder/:file.:ext', to: redirect('/app/build/assets/%{folder}/%{file}.%{ext}')
  get '/app/templates/:file.html', to: redirect('/app/build/templates/%{file}.html')


  namespace :api do 
    namespace :v1 do 
      resources :schemas, only:[:index,:show] 
      resources :loans, only:[:index,:show] 
    end
  end # scope API

end
