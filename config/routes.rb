Rails.application.routes.draw do
  root 'pages#home'

  scope :app do
    sso_devise
    resources :discussions
    get :proposals, to: 'proposals#index'
    get :opinions, to: 'opinions#index'
    resources :messages, only: :index do
      member do
        patch :mark_as_read
        patch :mark_as_unread
      end
      collection do
        patch :mark_all_as_read
      end
    end
    resources :reactions
    resources :attachments
    resources :canoes do
      shallow do
        resources :discussions, except: :index do
          resources :opinions do
            member do
              patch :pin
              patch :unpin
            end
          end
          resources :proposals, except: :index do
            resources :attachments
            member do
              post :in_favor, to: 'votes#in_favor'
              post :opposed, to: 'votes#opposed'
              delete :unvote, to: 'votes#unvote'
            end
          end
        end
        resources :crews

        delete 'crews/me', to: 'crews#destory'
        get 'invite', to: 'canoes#new_invitation'
        post 'invite', to: 'canoes#create_invitation'
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

    get '/search', to: "search#index"
  end

  get '/:slug/discussions/:sequential_id', to: "discussions#short", as: 'short_discussion'
  get '/:slug', to: "canoes#short", as: 'short_canoe'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/devel/emails"
  end
end
