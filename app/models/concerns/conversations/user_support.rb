module Conversations::UserSupport
  extend ActiveSupport::Concern
  include Conversations::Notifiable

  included do
    has_many :conversations_subscriptions, through: :memberships
    has_many :conversations, -> { distinct }, through: :conversations_subscriptions
  end
end


