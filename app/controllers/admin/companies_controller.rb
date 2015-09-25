class Admin::CompaniesController < Admin::BaseController
  respond_to :html, :js, :json
  before_filter :authenticate_admin!
  # load_and_authorize_resource
  
  def index
    @companies = Company.all.order("id").paginate(page: params[:page],
     per_page: params[:per_page] ? params[:per_page] : 10)
  end
  
  def new
    @company=Company.new
  end

  def show
    @company = Company.find(params[:id])
    @uber_admins = Admin.uber_admins
    @assigned_uber_admin = Admin.uber_admins.assigned_to_company(@company.id).first
    respond_with @company
  end

  def create
    @company=Company.new(params[:company])  #create new company
    if !Agent.find_by_email(params[:company][:email]) #if agent which has same email as new agent does not exist
      @companyagent = @company.agents.build(:email=>params[:company][:email],:confirmed_at=>Time.now, :password=>params[:company][:password], :password_confirmation=>params[:company][:password], :company_user=>'1',:first_name=>"Super User")
      history_company = History.new(:company_name=>nil, :active_name=>current_admin.email,:passive_name=>"#{@company.name}(#{@companyagent.email})", :action=>"create", :action_date=>Time.now, :sort=>"company")
      #history_superagent = History.new(:company_name=>@company.name, :active_name=>current_admin.email,:passive_name=>@companyagent.email, :action=>"create", :action_date=>Time.now, :sort=>"company")
      if @company.save
        history_company.save()
       # history_superagent.save()
        redirect_to admin_companies_path  #redirect index page
      end
    else  #if not
      flash.now[:error]='Please use another email address since This email is used by another agent.'
      render :new #display page to create new company and super agent
    end
  end
  
  def update
      company_id = params[:id]  #company id selected for updating
      @company = Company.find(company_id) #company selected for updating
      @companyagent = @company.agents.find_by_company_user('true')  #super agent for company
      history_company = History.new(:company_name=>nil, :active_name=>current_admin.email,:passive_name=>"#{@company.name}(#{@companyagent.email})", :action=>"update", :action_date=>Time.now, :sort=>"company")
      @otheragents = Agent.where(['id <> ?', @companyagent.id]) #all agent excluding current super agent
     if !@otheragents.find_by_email(params[:company][:email]) #if there is not agent who has same email as super agent's email to update
        #@company.update_attributes(:name=>params[:company][:name],:logo=>params[:company][:logo],:url=>params[:company][:url]) #update company
        @company.update_attributes(params[:company]) #update company
        @companyagent.email=params[:company][:email]
        @companyagent.password=params[:company][:password]
        @companyagent.password_confirmation=params[:company][:password]
        @companyagent.confirmed_at=Time.now
        @companyagent.skip_reconfirmation!  #skip sending confirmation email for super agent
        #history_superagent = History.new(:company_name=>@company.name, :active_name=>current_admin.email,:passive_name=>@companyagent.email, :action=>"update", :action_date=>Time.now, :sort=>"company")
        if @companyagent.save    #update super agent
          history_company.save()
         # history_superagent.save()
          redirect_to admin_companies_path  #redirect index page
        else
            flash.now[:error]='save fail. Try again!'
            @companies = Company.find(:all, :order=>"id") 
            render :index
        end
     else #if not
        flash.now[:error]='Please use another email address since This email is used by another agent.'
        @companies = Company.find(:all, :order=>"id") 
        render :index
     end
  end
  
  def destroy
    @company = Company.find(params[:id]) #company to destroy
    @companyagent = @company.agents.find_by_company_user('true')  #super agent for company
    history = History.new(:company_name=>nil, :active_name=>current_admin.email,:passive_name=>"#{@company.name}(#{@companyagent.email})", :action=>"destroy", :action_date=>Time.now, :sort=>"company")
    if (@company.destroy) #destroy company
      history.save()
      redirect_to admin_companies_path   
    end
  end
  
  def getcompanyinfo
    @company = Company.find_by_id(params['id'])
    @companyagent = @company.agents.find_by_company_user('true')  #super agent
    @company.email = @companyagent.try(:email)
    
    respond_to do |format|
      format.html
    end
  end
  
  def manage
    agent = Agent.find(params[:superagent_id])
    agent.asadmin = 1 #login agent with authority of admin
    if agent.save()
      sign_in agent
      redirect_to visits_path  
    else
      flash.now[:error]='occur while login agent as admin'
      @companies = Company.find(:all, :order=>"id") 
      render :index
    end
  end

  def assign_uber_admin
    @company = Company.find(params[:id])
    company_id = @company.id
    search_and_update_uber_admins(company_id)
    @uber_admin = Admin.find(params[:admin_id])
    @uber_admin.add_company_id(company_id)

    respond_with @company do |format|
      format.js { }
    end
  end

  protected

  def search_and_update_uber_admins(company_id)
    admins = Admin.uber_admins.assigned_to_company(company_id)
    if admins.any?
      admins.each {|admin| admin.remove_company_id(company_id) }
    end
  end
  
end
