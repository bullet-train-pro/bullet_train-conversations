class Account::ConversationsController < Account::ApplicationController
  include Conversations::BaseController
  include Account::Controllers::Base

  account_load_and_authorize_resource :conversation, through: BulletTrain::Conversations.parent_association, through_association: :conversations, except: [:create]

  def author
    :membership
  end

  def author_helper
    :current_membership
  end
end
