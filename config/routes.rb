ActionController::Routing::Routes.draw do |map|
  map.resources :photos  
  
  map.root :controller => 'photos', :action => 'show'
    
  map.namespace :admin do |admin|
    admin.resources :updates
    admin.resource  :settings
    admin.resource  :theme
    admin.resource  :login
    admin.logout    '/logout', :controller => 'logins', :action => 'destroy'
    admin.root      :controller => 'settings', :action => 'show'
  end
  
  map.connect ':page', :controller => 'pages', :action => 'show'
end