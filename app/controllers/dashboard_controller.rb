class DashboardController < ApplicationController
  def index
  end

  def broadcast
    warn "Hi - #{params.inspect}"
    ButtonChannel.broadcast_to(params[:button], message: params[:message])
    render partial: 'broadcast'
  end

  def set_button
    $r.set("buttons:#{params[:button]}", params[:value])
    ButtonChannel.broadcast_to(params[:button], { state: params[:value] })
    render partial: 'broadcast'
  end
end
