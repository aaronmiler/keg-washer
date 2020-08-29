class ButtonChannel < ApplicationCable::Channel
  def subscribed
    stream_from "button:#{params[:button]}"
    # stream_from "some_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
