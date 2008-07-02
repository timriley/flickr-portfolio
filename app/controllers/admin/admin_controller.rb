class Admin::AdminController < ApplicationController
  include SingleLogin
  
  before_filter :login_required
  
  layout 'admin'
end