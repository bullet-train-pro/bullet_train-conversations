class Account::Conversations::SubscriptionsController < Account::ApplicationController
  account_load_and_authorize_resource :subscription, through: :user, through_association: :conversations_subscriptions, member_actions: [:subscribe, :unsubscribe]  if defined?(account_load_and_authorize_resource)

  def load_team
    # TODO Why do we need this? Is it because we're a resource controller that belongs to a user instead of a team?
  end

  before_action do
    @remove_content_padding = true
    @body_class = "fixed-height"
  end

  # GET /account/users/:user_id/conversations/subscriptions
  # GET /account/users/:user_id/conversations/subscriptions.json
  def index
    conversation_id = params[:conversation_id] || session[:last_inbox_conversation_id]
    session[:last_inbox_conversation_id] = conversation_id
    if conversation_id
      @conversation = Conversation.find_by(id: conversation_id)
      if @conversation.nil? || @conversation.subscriptions.where(membership: current_membership).none?
        @conversation = nil
        session[:last_inbox_conversation_id] = nil
      else
        raise "Unauthorized" unless can? :show, @conversation
        @conversation.mark_read_for_membership(current_membership)
      end
    end
  end

  # GET /account/conversations/subscriptions/:id
  # GET /account/conversations/subscriptions/:id.json
  def show
    @subscription.mark_read
  end

  # GET /account/users/:user_id/conversations/subscriptions/new
  def new
  end

  # GET /account/conversations/subscriptions/:id/edit
  def edit
  end

  # POST /account/users/:user_id/conversations/subscriptions
  # POST /account/users/:user_id/conversations/subscriptions.json
  def create
    respond_to do |format|
      if @subscription.save
        format.html { redirect_to [:account, @user, :conversations_subscriptions], notice: I18n.t("conversations/subscriptions.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @user, @subscription] }
      else
        format.html { render :new }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/conversations/subscriptions/:id
  # PATCH/PUT /account/conversations/subscriptions/:id.json
  def update
    respond_to do |format|
      if @subscription.update(subscription_params)
        format.html { redirect_to [:account, @subscription], notice: I18n.t("conversations/subscriptions.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @subscription] }
      else
        format.html { render :edit }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/conversations/subscriptions/:id
  # DELETE /account/conversations/subscriptions/:id.json
  def destroy
    @subscription.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @user, :conversations, :subscriptions], notice: I18n.t("conversations/subscriptions.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  def subscribe
    @subscription.update(unsubscribed_at: nil)
    redirect_to return_path || [:account, @subscription.user, :conversations, :subscriptions]
  end

  def unsubscribe
    @subscription.update(unsubscribed_at: Time.zone.now)
    redirect_to return_path || [:account, @subscription.user, :conversations, :subscriptions]
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def subscription_params
    strong_params = params.require(:conversations_subscription).permit
    # 🚅 super scaffolding will insert new fields above this line.
    # 🚅 super scaffolding will insert new arrays above this line.

    # 🚅 super scaffolding will insert processing for new fields above this line.

    strong_params
  end
end
