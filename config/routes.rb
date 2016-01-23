Rails.application.routes.draw do
  root 'pages#home'

  scope :app do
    sso_devise
    resources :discussions
    get :proposals, to: 'proposals#index'
    get :opinions, to: 'opinions#index'
    resources :messages, only: :index do
      member do
        get :mark_as_read
      end
    end
    resources :reactions
    resources :canoes do
      shallow do
        resources :discussions, except: :index do
          resources :attachments
          resources :opinions do
            member do
              patch :pin
              patch :unpin
            end
          end
          resources :proposals, except: :index do
            member do
              post :in_favor, to: 'votes#in_favor'
              post :opposed, to: 'votes#opposed'
              delete :unvote, to: 'votes#unvote'
            end
          end
        end

        resources :crews do
        end
      end

      resources :request_to_joins do
        collection do
          post :ask, to: 'request_to_joins#ask'
        end
        member do
          post :accept, to: 'request_to_joins#accept'
        end
      end
    end
  end

  get '/:slug', to: "canoes#short", as: 'short_canoe'
end
