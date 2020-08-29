require 'redis'
require 'json'

module SettingsStore
  module_function
  def set(key, val)
    s = settings
    s[key] = val
    redis.set('cycle_settings', s.to_json)
  end

  def get(key)
    settings[key]
  end

  def settings
    d = redis.get('cycle_settings') || '{}'
    JSON.parse(d, symbolize_names: true)
  end

  def redis
    @__redis ||= Redis.new
  end
end
