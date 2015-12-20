Rails.application.routes.draw do
  root 'pages#home'

  sso_devise

  resources :canoes do
    shallow do
      resources :discussions do
        resources :opinions
      end
    end
  end
end
