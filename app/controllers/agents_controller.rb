class AgentsController < ApplicationController
  respond_to :html, :js, :json
  before_filter :authenticate_agent!
  load_and_authorize_resource
  #before_filter :after_token_authentication # it is empty hook provided by devise i,e once user is successfully authenticated with the token devise look for this method ,  and execute the code there
  
  def index
    if current_agent.company_user != true
      redirect_to visits_path
    else
      @companyuser = Company.find(current_agent.company_id)
      @agents = @companyuser.agents.paginate(:page=>params[:page],
        :per_page=> params[:per_page] ? params[:per_page] : 10).order('company_user ASC,email ASC')
      @assets = @companyuser.assets
      @visits = @companyuser.visits.not_archived
    end
  end
  
  def new
    @company=Company.find(params[:company_id])
    @agent=@company.agents.build
    respond_with @agent
  end
  
  def create  #redefined action for devise registration
    company=Company.find_by_id(params[:agent][:company_id]) #company including current agent
    if params[:agent][:password].nil? || params[:agent][:password].blank? # if password is blank
     params[:agent][:password] = :aaaaaaaa #set password as default password
    end 
    @agent=@company.agents.build(params[:agent])
    history = build_history({company_name: @agent.company.name, passive_name: @agent.email, action: "create", action_date: Time.now, sort: "agent"})
    if !Agent.find_by_email(params[:agent][:email]) #if there is no agent who has same email
      if @agent.save  #create agent
        history.save() if history
        redirect_to agents_path(:id=>@agent.company.id)
      else
        flash.now[:error]='save fail. Try again!'
        render :new
      end
    else  #if not
      flash.now[:error]='Please use another email address since This email is used by another agent.'
      render :new
    end
  end
  
  def getagentinfo
    @agent = Agent.find_by_id(params['id'])
    respond_with @agent
  end
  
  def update
    agent_id = params[:id]
    @agent = Agent.find(agent_id)
    @otheragents = Agent.where(['id <> ?', agent_id])
    if !@otheragents.find_by_email(params[:agent][:email]) #if there is no agents has same email except for current agent
      #if params[:agent][:password].nil? || params[:agent][:password].blank? #if password is blank
      #  params[:agent][:password] = :aaaaaaaa #set password as default password
      #end
      #consider case in which password is not present and because can't get password from encrypted password in database
      history = build_history({company_name: @agent.company.name, passive_name: @agent.email, action: "update", action_date: Time.now, sort: "agent"})
      if params[:agent][:photo].present?
        if @agent.update_attributes(:email=>params[:agent][:email],:first_name=>params[:agent][:first_name],:last_name=>params[:agent][:last_name],:photo=>params[:agent][:photo])  #update agent
          history.save() if history
        end
      else
        if @agent.update_attributes(:email=>params[:agent][:email],:first_name=>params[:agent][:first_name],:last_name=>params[:agent][:last_name])  #update agent
          history.save() if history
        end
      end
      
      redirect_to agents_path(:id=>@agent.company.id)
    else
      flash.now[:error]='Please use another email address since This email is used by another agent.'
      @companyuser = Company.find(current_agent.company_id)
      @agents = @companyuser.agents
      @assets = @companyuser.assets 
      @visits = @companyuser.visits.select{|visit| visit.archived==0}
      render :index
    end
  end
  
  def destroy
    @agent = Agent.find(params[:id])
    history = build_history({company_name: @agent.company.name, passive_name: @agent.email, action: "destroy", action_date: Time.now, sort: "agent"})
    if (@agent.destroy) #destroy agent
      history.save() if history
      redirect_to agents_path(:id=>@agent.company.id)    
    end
  end
  
  def reconfirm
    @agent = Agent.find(params[:id])
    @agent.send_reconfirmation_instructions
    redirect_to agents_path(:id=>@agent.company.id)
  end
     
end
