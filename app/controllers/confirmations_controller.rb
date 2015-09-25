class ConfirmationsController < Devise::ConfirmationsController
  #Remove the first skip_before_filter (:require_no_authentication) if you
  #don't want to enable logged agents to access the confirmation page.
  skip_before_filter :require_no_authentication
  skip_before_filter :authenticate_agent!
  
  #PUT /resource/confirmation
  def update
    with_unconfirmed_confirmable do
      @confirmable.attempt_set_password(params[:agent])
      if @confirmable.valid?
        do_confirm
      else
        do_show
        @confirmable.errors.clear #so that we want render :new
      end
    end
    if !@confirmable.errors.empty?
      render 'devise/confirmations/new' #Change this if you don't have the views on default path
    end
  end
  
  #GET /resource/confirmation?confirmation_token=abcdef
  def show
    with_unconfirmed_confirmable do
      #if @confirmable.has_no_password?
        do_show
      #else
       # do_confirm
      #end
    end
    if !@confirmable.errors.empty?
      self.resource = @confirmable
      render 'devise/confirmations/new' #Change this if you don't have the views on default path
    end
  end
  
  protected
  
  def with_unconfirmed_confirmable
    @confirmable = Agent.find_or_initialize_with_error_by(:confirmation_token, params[:confirmation_token])
    if !@confirmable.new_record?
      @confirmable.only_if_unconfirmed {yield}
    end
  end
  
  def do_show
    @confirmation_token = params[:confirmation_token]
    @requires_password = true
    self.resource = @confirmable
    render 'show' #Change this if you don't have the views on default path
  end
  
  def do_confirm
    @confirmable.confirm!
    set_flash_message :notice, :confirmed
    render 'congratulation'
  end
end
