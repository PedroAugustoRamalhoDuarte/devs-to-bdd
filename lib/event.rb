class Event
  attr_reader :sender, :action, :receiver

  def initialize(sender:, action:, receiver:)
    @sender = sender
    @action = action
    @receiver = receiver
  end

  def to_s
    "#{@sender} send #{@action} to #{@receiver}"
  end
end