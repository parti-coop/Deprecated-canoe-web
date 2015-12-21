Rails.application.routes.draw do
  root 'pages#home'

  scope :app do
    sso_devise
    resources :canoes do
      shallow do
        resources :discussions do
          resources :opinions
          resources :proposals do
            member do
              post :in_favor, to: 'votes#in_favor'
              post :opposed, to: 'votes#opposed'
              delete :unvote, to: 'votes#unvote'
            end
          end
        end
      end
    end
  end

  get '/:slug', to: "canoes#short", as: 'short_canoe'
end
