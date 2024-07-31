class Participants::ConversationsController <  BulletTrain::Conversations.participant_parent_controller.constantize
  include ::Conversations::BaseController

  account_load_and_authorize_resource :conversation, through: BulletTrain::Conversations.participant_parent_association, through_association: :conversations, except: [:create] if defined?(account_load_and_authorize_resource)

  def author
    :participant
  end

  def author_helper
    BulletTrain::Conversations.current_participant_helper_method
  end
end
