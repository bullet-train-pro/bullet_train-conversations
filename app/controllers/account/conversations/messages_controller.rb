class Account::Conversations::MessagesController < Account::ApplicationController
  include Conversations::Messages::BaseController

  account_load_and_authorize_resource :message, through: :conversation, through_association: :messages, member_actions: [:reply, :thread] if defined?(account_load_and_authorize_resource)

  private

  def author
    :membership=
  end

  def author_helper
    :current_membership
  end
end



