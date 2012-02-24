class UsersController < ApplicationController
  skip_before_filter :require_user, :only => [:new, :create, :forgot_password, :profiles]
  # GET /users
  # GET /users.xml
  # GET /users.fxml
  def index
      respond_to do |format|
        respond_to_do(format, current_user,{:profiles =>{:only=>[:id,:title],
						         :include=>{:profile_category=>{:only=>[:id,:title]}}
							}
					   },[],[:crypted_password,:password_salt])
      end
  end

  # GET /users/1
  # GET /users/1.xml
  # GET /users/1.fxml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      respond_to_do(format, @user,{:profiles=>{:include=>{:category=>{:only=>[:id,:title]}},:only=>[:title,:id]}})
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    if current_user && @user.id != current_user.id
      flash[:notice] = 'You are not the owner of this account, please login'
      redirect_to new_user_sessions_path
    end
  end

  # POST /users
  # POST /users.xml
  # POST /users.fxml
  def create
    if !params[:auto_populate].blank?
      params[:user][:email_home] = params[:user][:email_work]
      new_password = generate_password
      params[:user][:password_confirmation] = new_password
      params[:user][:password] = new_password
    else
      primary_email = params[:user][:is_email_home] ? params[:user][:email_home] : params[:user][:email_work]
      params[:user][:login] = primary_email
    end
    
    @user = User.create(params[:user])     
    
    respond_to do |format|
      if @user.errors.empty?
        flash[:notice] = 'User was successfully created.'
        start_autopopulate if !params[:auto_populate].blank?
        send_thanks_email(params[:user][:password])
        respond_to_do(format, @user,
                             {:profiles =>{:only=>[:id,:title],
                                           :include=>{:profile_category=>{:only=>[:id,:title]}}}})
      else
        respond_error_to_do(format, @user,"new")
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  # PUT /users/1.fxml
  def update
    @user = User.find(params[:id])
    is_new = @user.profiles.length < 1 && @user.access_tokens.size < 1
    
    unless params[:user][:email_work].blank?
      is_exist = User.find_by_email_work(params[:user][:email_work])
      @user.errors.add(:email_work,"is already taken.") if is_exist
    end if is_new
    
    respond_to do |format|
      if @user.errors.length < 1 && @user.update_attributes(params[:user])
        @user = User.find(params[:id])
        start_autopopulate if !params[:auto_populate].blank?
        send_thanks_email(params[:user][:password]) if is_new
        flash[:notice] = 'User was successfully updated.'
        respond_to_do(format, @user,
                             {:profiles =>{:only=>[:id,:title],
                                           :include=>{:profile_category=>{:only=>[:id,:title]}}}})
      else
        respond_error_to_do(format, @user,"edit")
      end
    end
  end
  
  def generate_population
    start_autopopulate if current_user
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  # DELETE /users/1.fxml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { render :xml => @user, :status => 200}
      format.json { render :json => @user, :status => 200 }
      format.fxml  { render :fxml => @user }
    end
  end

  def forgot_password
    is_success = false
    new_password = generate_password
    user = User.find(:first, :conditions=> ["email_work=? OR email_home=? OR login = ?",params[:email],params[:email],params[:email]])
    if user
      user.update_attribute(:password,new_password)
      is_success = true
    end
    require 'smtp-tls'
    respond_to do |format|
      if is_success
        Resque.enqueue(Finfores::Backgrounds::EmailAlert,"forgot_password", {:user=>user.id, :password=>new_password}.to_yaml)
        #Finfores::Jobs::AlertWorker.new("forgot_password", {:user=>user.id, :password=>new_password}.to_yaml)
        format.html { render :text=> "SUCCESS"}
	format.json { render :json => {:status=>"SUCCESS"}, :status => 200 }
      else
        format.html { render :text=> "FAILED"}
        format.json { render :json => {:status=>"FAILED"}, :status => 200 }
      end
    end
  end

  def profiles
     categories = ProfileCategory.find(:all,:include=>:profiles,:select=>"profiles.*,id,title",:conditions=>["profiles.is_private != ?",true])
     respond_to do |format|
        respond_to_do(format, categories,{:profiles=>{:only=>[:id,:title]}},[:id,:title])
    end
  end

  def contact_admin
    #if verify_recaptcha()
     if !Akismetor.spam?(akismet_attributes(params[:form]))
      Resque.enqueue(Finfores::Backgrounds::EmailAlert,"contact_admin", params[:form].to_yaml)     
      status = "SUCCESS"
    else
      status = "SPAM"
    end
    respond_to do |format|
      format.html { render :text=> status}
    end
  end

  private
    def generate_password
      return (1..8).map{ (0..?z).map(&:chr).grep(/[a-z\d]/i)[rand(62)]}.join
    end

    def akismet_attributes options
	 {
	    :key                  => '00864d8d758f',
	    :blog                 => 'http://finfore.net',
	    :user_ip              => request.remote_ip,
	    :user_agent           => request.env['HTTP_USER_AGENT'],
	    :comment_author       => options[:name],
	    :comment_author_email => options[:email],
	    :comment_author_url   => '',
	    :comment_content      => options[:message]
	  }
    end

    def send_thanks_email(password)
      Resque.enqueue(Finfores::Backgrounds::EmailAlert,"welcome_email", {:user=>@user.id, :password=>password}.to_yaml)
      #Finfores::Jobs::AlertWorker.new("welcome_email", {:user=>@user.id, :password=>password}.to_yaml)
    end
    
end