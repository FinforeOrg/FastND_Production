ActionController::Routing::Routes.draw do |map|
  map.resources :profiles

  map.resources :profile_categories

  map.resources :tweetfores, :collection => {
                  :followers            => [:get, :post],
                  :friends              => [:get, :post],
                  :status_retweet       => [:get, :post],
                  :status_destroy       => [:get, :post],
                  :status_update        => [:get, :post],
                  :message_post         => [:get, :post],
                  :message_destroy      => [:get, :post],
                  :messages_sentbox     => [:get, :post],
                  :messages_inbox       => [:get, :post],
                  :home_timeline        => [:get, :post],
                  :mentions             => [:get, :post],
                  :search               => [:get, :post],
                  :friend_add           => [:get, :post],
                  :friend_remove        => [:get, :post],
                  :friends_pending      => [:get, :post],
                  :followers_pending    => [:get, :post]
                }

  map.resources :price_tickers

  map.resources :company_competitors

  map.resources :user_company_tabs

  map.resources :populate_feed_infos
  
  map.resources :noticeboards, :member => {:rss => [:get,:post]},
                                          :collection => {:check_updates => [:get,:post]} do |noticeboard|
    noticeboard.resources :noticeboard_users
    noticeboard.resources :noticeboard_comments
    noticeboard.resources :noticeboard_posts do |post|
      post.resources :noticeboard_comments
    end
    noticeboard.resources :noticeboard_role_users     
  end

  map.resources :noticeboard_role_users

  map.resources :noticeboard_roles

  map.resources :noticeboard_users, :collection => {:check_user => :get}

  map.resources :noticeboard_comments

  map.resources :noticeboard_posts

  map.resources :feed_apis

  map.resources :log_errors

  map.resources :portfolios,
                :collection => {
                  :overviews            => [:get         ],
                  :transactions         => [:get         ],
                  :positions            => [:get         ],
                  :list                 => [:get         ],
                  :agenda               => [:get, :post],
                  :save_portfolio       => [:get, :post],
                  :delete_portfolio     => [:get         ],
                  :save_transaction     => [:get, :post],
                  :delete_transaction   => [:get         ],
                }

  map.resources :users, :collection => {:forgot_password => :get,
                                        :profiles=>[:get,:post],
					:contact_admin=>[:post]}  

  map.resources :user_sessions, :collection => {:create_network => [:get,:post],
			                       :failure_network => [:get,:post],
				               :network_sign_in => [:get,:post],
			                       :public_login => [:get,:post],
					       :generate_captcha => [:get,:post],
                                               :new_worker => [:get]
			 	              }

  map.resources :feed_accounts, :collection => { :column_auth => [:get, :post],
                                                 :column_callback => [:get, :post]
                                               } do |column|
    column.resources :user_feeds
    column.resources :keyword_columns
  end
  
  map.resources :feed_infos
  map.resources :keyword_columns
  map.resources :logged_exceptions, :collection => {:destroy_all  => :get}
  map.resources :price_charts, :collection => {:spreadsheets_list => [:get, :post], 
                                               :chart_detail      => [:get, :post], 
                                               :graph             => [:get, :post],
                                               :gadget_finance    => [:get, :post],
                                               :gadget_price      => [:get, :post]}  

  map.resources :user_feeds

  map.resources :mails, :collection => {
    :messages => [:get,:post],
    :send_message => [:get,:post]
  }  

  map.resources :linkedins, :collection => {:authenticate => :get,
                                        :network_status => :get,
                                        :callback => :get
                                       }

  map.resource  :linkedin, :collection => {:authenticate => :get,
                                        :network_status => :get,
                                        :callback => :get
                                       }

  map.resources :feed_tokens,:collection => {:linkedin_callback => [:get, :post],
                                             :twitter_callback  => [:get, :post],
                                             :google_callback   => [:get, :post]
                                            }

  map.resources :facebookers, :collection =>{
    :my => [:get, :post],
    :publish => [:get,:post],
    :search => [:get,:post]
  }
  map.root :controller => "user_sessions", :action => "new"
  map.connect "logged_exceptions/:action/:id", :controller => "logged_exceptions"
  map.login "client/login", :controller => "user_sessions", :action => "new"
  map.logout 'logout', :controller => :user_sessions, :action => :destroy, :conditions => {:method => :get}
  map.social_in "/auth/:provider.:format", :controller => "user_sessions", :action => "network_sign_in"
  map.callback "/auth/:provider/callback", :controller => "user_sessions", :action => "create_network"
  map.failure "/auth/failure.:format", :controller => "user_sessions", :action => "failure_network"
  map.column_auth "/feed_accounts/:provider/auth", :controller => "feed_accounts", :action => "column_auth"
  map.column_callback "/feed_accounts/:provider/callback", :controller => "feed_accounts", :action => "column_callback"
  map.facebook_my "/my/:category.:format", :controller => "facebookers", :action=> "my"
  map.facebook_publish "/:pid/publish/:pubtype.:format", :controller => "facebookers", :action=> "publish"
  map.facebook_search "/search/:type.:format", :controller => "facebookers", :action=> "publish"
  map.user_profile "/category_focus.:format",:controller => "users", :action => "profiles"
  map.generate_captcha "/generate_captcha", :controller=>"user_sessions",:action => "generate_captcha"
  map.feed_reader "/feeds_reader",:controller=>"",:path=>"/feeds_reader"
  map.mobile "/m",:controller=>"",:path=>"/m"
  #map.resources :users
  #map.resource :user_session

  #map.reset "reset", :controller => :users, :action => :detonate
 
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
