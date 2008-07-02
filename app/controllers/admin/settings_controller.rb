class Admin::SettingsController < Admin::AdminController  
  def show
    @settings = Settings.instance
  end
  
  def update
    @settings = Settings.instance
    
    params[:settings].each_pair do |key, val|
      # FIXME this is a security hole. Need to patch it.
      @settings.send("#{key}=".to_sym, val)
    end
    
    respond_to do |format|
      if @settings.save
        flash[:notice] = 'Settings saved'
        format.html { redirect_to admin_settings_path }
      else
        format.html { render :action => 'show' }
      end
    end
  end
end
