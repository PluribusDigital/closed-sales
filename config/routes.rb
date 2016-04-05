Rails.application.routes.draw do

  # Static Files
  root to: redirect('/app/build/')
  get '/app/assets/:folder/:file.:ext', to: redirect('/app/build/assets/%{folder}/%{file}.%{ext}')
  get '/app/templates/:file.html', to: redirect('/app/build/templates/%{file}.html')

  # Core APIs
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
