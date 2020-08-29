require 'redis'
require File.expand_path('../../../config/environment', __FILE__)

r = Redis.new

Rails.application.eager_load!

loop do
  num = (1..10).to_a.sample(1)[0]
  puts num
  ButtonChannel.broadcast_to('red', { state: num == 4 })
  ButtonChannel.broadcast_to('green', { state: num == 2 })
  sleep(1)
end
