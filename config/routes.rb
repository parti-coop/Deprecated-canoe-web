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
      member do
        get :history, to: 'canoes#history'
      end
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
        resources :invitations do
          collection do
            post :accept, to: 'invitations#accept'
          end
        end

        delete 'crews/me', to: 'crews#destroy'
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
    get '/search/discussions', to: "search#discussions"
    get '/search/canoes', to: "search#canoes"
  end

  scope :api do
    api version: 1, module: "api/v1", allow_prefix: "v" do
      get 'system/ping'
      get 'system/last_versions'
      get 'home', to: 'pages#home'
      get 'search/canoes', to: 'search#canoes'
      get 'search/discussions', to: 'search#discussions'

      resources :messages, only: :index do
        collection do
          get 'unreads_count'
          post 'mark_all_as_read'
        end
        member do
          post 'mark_as_read'
          post 'mark_as_unread'
        end
      end
      resources :canoes, only: [:show] do
        delete 'crews/me', to: 'crews#destroy_me', on: :member
        shallow do
          resources :discussions, except: :destroy do
            resources :opinions
            resources :proposals do
              member do
                post :in_favor, to: 'votes#in_favor'
                post :opposed, to: 'votes#opposed'
                delete :unvote, to: 'votes#unvote'
              end
            end
          end
          resources :request_to_joins, only: [:create, :destroy] do
            patch :accept, on: :member
          end
          resources :invitations, only: [:create, :destroy]
        end
      end
    end
  end

  get '/:slug/discussions/:sequential_id', to: "discussions#short", as: 'short_discussion'
  get '/:slug', to: "canoes#short", as: 'short_canoe'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/devel/emails"
  end
end
