module Conversations::Messages::BaseController
  extend ActiveSupport::Concern

  included do
    account_load_and_authorize_resource :message, through: :conversation, through_association: :messages, member_actions: [:reply, :thread]  if defined?(account_load_and_authorize_resource)
  end

  # GET /account/conversations/:conversation_id/conversations/messages
  # GET /account/conversations/:conversation_id/conversations/messages.json
  def index
    # since we're showing messages on the conversation show page by default,
    # we might as well just go there.
    redirect_to [:account, @conversation]
  end

  # GET /account/conversations/messages/:id
  # GET /account/conversations/messages/:id.json
  def show
  end

  # GET /account/conversations/:conversation_id/conversations/messages/new
  def new
  end

  # GET /account/conversations/messages/:id/edit
  def edit
  end

  # POST /account/conversations/:conversation_id/conversations/messages
  # POST /account/conversations/:conversation_id/conversations/messages.json
  def create
    respond_to do |format|
      @message.send(author, send(author_helper))
      @style = params[:conversations_message][:style] || :conversation
      if @message.save
        format.turbo_stream { render('account/conversations/messages/create') }
        format.html { redirect_back(fallback_location: [:account, @conversation, :conversations_messages]) }
        format.json { render :show, status: :created, location: [:account, @conversation, @message] }
      else
        format.html { redirect_back(fallback_location: [:account, @conversation, :conversations_messages]) }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/conversations/messages/:id
  # PATCH/PUT /account/conversations/messages/:id.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to [:account, @message], notice: I18n.t("conversations/messages.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @message] }
      else
        format.html { render :edit }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/conversations/messages/:id
  # DELETE /account/conversations/messages/:id.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @conversation, :conversations, :messages], notice: I18n.t("conversations/messages.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  def reply
    @reply = @message.replies.build
  end

  def thread
    render "account/conversations/messages/thread", layout: false
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def message_params
    strong_params = params.require(:conversations_message).permit(
      :body,
      :parent_message_id,
      # 🚅 super scaffolding will insert new fields above this line.
      # 🚅 super scaffolding will insert new arrays above this line.
    )

    # 🚅 super scaffolding will insert processing for new fields above this line.

    strong_params
  end
end
