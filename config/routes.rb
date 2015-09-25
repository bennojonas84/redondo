Redondo::Application.routes.draw do
  
  get 'activities/index'
  get 'static/home'
  get 'static/about'
  get 'static/tutorials'
  get 'static/white_paper'
  get 'static/videos'
  get 'static/reports'
  get 'static/mobileapp'
  get 'static/contact'
  resources :activities
  resources :reports, only: [:index] do
    collection do
      post 'today_visits_count'
      post 'visits_per_zipcode'
      post 'most_active_agents'
      post 'visits_per_period'
    end
  end
  get 'visitsreport/:id', to: 'reports#visitsreport', as: :visits_report

  as :agent do
    match '/agent/confirmation' => 'confirmations#update', :via=>:put, :as=>:update_agent_confirmation
  end
  devise_for :agents, :controllers => {sessions: 'agent_login', confirmations: 'confirmations'}, :path_names => {:registration => 'agents'}
  # adding skip: :registrations disable the default sign-up path entirely
  devise_for :admins, :path=>'rm/SkuRun', skip: :registrations

  resources :agent_login
    
  namespace :admin, :path => '/rm/SkuRun' do
    root :to => 'companies#index'
    get '/getcompanyinfo', to: 'companies#getcompanyinfo'
    #noinspection RailsParamDefResolve
    resources :companies do
      collection do
        get 'manage'
      end
      member do
        post 'assign_uber_admin'
      end
    end
    resources :activities
    devise_scope :admin do
      # get '/sign_up', to: 'registrations#new'
      resources :registrations
    end
    # CMS Namespace
    namespace :cms do
      
    end
  end
  
 root to: 'static#index'
    
  resources :agents, :except=>:show

  get '/reconfirm', to: 'agents#reconfirm' 
  get '/getagentinfo', to: 'agents#getagentinfo'
    
  resources :assets, :except=>:show
  # delete '/deleteassets/:id', to: 'assets#destroy', as: :delete_asset
  get '/getassetinfo', to: 'assets#getassetinfo'
  
  resources :visits do
    collection do
      get 'missing'
    end
    member do
      get 'download_zipped_images'
      get 'download_selected_zipped_images'
      post 'image_to_download'
    end
  end
  get '/agentvisits', to: 'visits#agentvisits'
  get '/visitdetail', to: 'visits#visitdetail'
  get '/assetvisits', to: 'visits#assetvisits'

  resources :histories, :only=>:index

  get '/rails_log', to: 'debug#rails_log', as: :rails_log
  get '/:id' => 'shortener/shortened_urls#show'

  
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
