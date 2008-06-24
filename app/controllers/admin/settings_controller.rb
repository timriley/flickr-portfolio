class Admin::SettingsController < Admin::AdminController  
  def edit
    @settings = Settings.instance
  end
  
  def update
    @settings = Settings.instance
  end
end
