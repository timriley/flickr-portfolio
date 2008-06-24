ActionController::Routing::Routes.draw do |map|
  map.resources :photos  
  map.root      :controller => 'photos', :action => 'show'
  
  map.namespace :admin do |admin|
    admin.resource :settings
    admin.resource :login
    admin.logout '/logout', :controller => 'logins', :action => 'destroy'
    admin.root :controller => 'settings', :action => 'edit'
  end
end
