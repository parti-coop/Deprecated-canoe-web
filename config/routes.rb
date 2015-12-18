Rails.application.routes.draw do
  root 'pages#home'

  sso_devise

  resources :canoes do
    shallow do
      resources :discussions
    end
  end
end
