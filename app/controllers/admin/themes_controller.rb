class Admin::ThemesController < Admin::AdminController  
  def show
    @theme = Theme.instance
  end
  
  def update
    @theme = Theme.instance
    @theme.template = params[:theme][:template]
    
    respond_to do |format|
      if @theme.save
        flash[:notice] = 'Theme saved'
        format.html { redirect_to admin_theme_path }
      else
        format.html { render :action => 'show'}
      end
    end
  end
end
