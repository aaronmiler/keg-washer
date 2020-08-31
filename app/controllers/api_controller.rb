class APIController < ActionController::API
  def update_setting
    SettingsStore.set(params[:key], params[:value])
    render json: { settings: SettingsStore.settings }
  end
end
