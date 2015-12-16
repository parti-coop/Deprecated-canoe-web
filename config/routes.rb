Rails.application.routes.draw do
  root 'pages#home'

  sso_devise

  resources :canoes
end
