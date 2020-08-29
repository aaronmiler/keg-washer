require 'rpi_gpio'
require 'redis'
require File.expand_path('../../../config/environment', __FILE__)

r = Redis.new

Rails.application.eager_load!

RPi::GPIO.set_numbering :board
RPi::GPIO.setup Pins.red_button, as: :input, pull: :up
RPi::GPIO.setup Pins.green_button, as: :input, pull: :up

counts = Hash.new(0)

loop do
  if RPi::GPIO.low? Pins.green_button
    ButtonChannel.broadcast_to('green', { state: true })
    counts[:green] = 0
  else
    ButtonChannel.broadcast_to('green', { state: false }) if counts[:green] = 5
    counts[:green] += 1
  end

  if RPi::GPIO.high? Pins.red_button
    ButtonChannel.broadcast_to('red', { state: true })
    counts[:red] = 0
  else
    ButtonChannel.broadcast_to('red', { state: false }) if counts[:red] = 5
    counts[:red] += 1
  end
  sleep(0.1)
end
