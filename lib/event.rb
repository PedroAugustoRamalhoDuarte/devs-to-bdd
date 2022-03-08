# frozen_string_literal: true

class Event
  attr_reader :sender, :action, :receiver

  def initialize(sender:, action:, receiver:)
    @sender = sender
    @action = action
    @receiver = receiver
  end

  def to_s
    "#{@sender} sends #{@action} to #{@receiver}"
  end

  def to_h
    {
      sender: @sender,
      action: @action,
      receiver: @receiver
    }
  end
end
