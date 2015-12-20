Rails.application.routes.draw do
  root 'pages#home'

  sso_devise

  resources :canoes do
    shallow do
      resources :discussions do
        resources :opinions
        resources :proposals
      end
    end
  end
end
