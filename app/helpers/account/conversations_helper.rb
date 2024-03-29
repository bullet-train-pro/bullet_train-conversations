module Account::ConversationsHelper
  def message_anchor(message)
    return nil unless message
    "message-#{message.id}"
  end

  def message_thread_border side:, position:
    valid_sides = %i[right left]
    raise "Invalid side for message border" unless valid_sides.include?(side)
    valid_positions = %i[start middle end]
    raise "Invalid position for message border #{position}" unless valid_positions.include?(position)
    # Convenience helpers to make the conditionals below read a bit easier
    left = side == :left
    right = side == :right
    start = position == :start
    p_end = position == :end

    border_classes = if start && left
      "rounded-tl-lg"
    elsif start && right
      "rounded-tr-lg"
    elsif p_end && left
      "rounded-bl-lg"
    elsif p_end && right
      "rounded-br-lg"
    else
      ""
    end

    border_classes += " border-t-2 mt-2" if start
    border_classes += " border-b-2 mb-2" if p_end
    border_classes += " border-l-2" if left
    border_classes += " border-r-2" if right

    render "account/shared/conversations/thread_border", border_classes: border_classes, side: side
  end

  def message_corner_class next_message_in_series, current_user_message
    if next_message_in_series
      ""
    elsif current_user_message
      "rounded-br-none"
    else
      "rounded-bl-none"
    end
  end

  def get_conversation_namespace
    controller.class.name.split("::").each do |namespace_candidate|
      return BulletTrain::Conversations.participant_namespace_as_symbol if namespace_candidate == BulletTrain::Conversations.participant_namespace
    end

    return BulletTrain::Conversations.participant_namespace_as_symbol if controller.class.name.include?('Participants::Conversations')

    :account
  end

  def in_participant_namespace?
    get_conversation_namespace == BulletTrain::Conversations.participant_namespace_as_symbol
  end

  def conversations_message_mentions
    mentions = []

    if can?(:read, current_team)
      mentions << {key: current_team.name, value: current_team.id, protocol: 'bullettrain', model: 'teams', id: current_team.id, label: current_team.name, photo: photo_for(current_team)}
    end

    current_team.memberships.current_and_invited.map { |membership|
      if can?(:read, membership)
        mentions << {
          key: membership.name,
          value: membership.id,
          protocol: 'bullettrain',
          model: 'memberships',
          id: membership.id,
          label: membership.name,
          photo: membership_profile_photo_url(membership)
        }
      end
    }

    mentions
  end
end
