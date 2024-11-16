class Account::ConversationsController < Account::ApplicationController
  include Conversations::BaseController

  account_load_and_authorize_resource :conversation, through: BulletTrain::Conversations.parent_association, through_association: :conversations, except: [:create] if defined?(account_load_and_authorize_resource)

  def author
    :membership
  end

  def author_helper
    :current_membership
  end
end
