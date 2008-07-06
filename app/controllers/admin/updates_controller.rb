class Admin::UpdatesController < Admin::AdminController
  def index
    @audits = Audit.paginate(:all, :order => 'created_at DESC', :page => params[:page], :per_page => 7)
    
    respond_to do |format|
      format.html do
        render(:parial => 'audits', :layout => false) if request.xhr?
      end
      format.xml { render :xml => @audits }
    end
  end
end
