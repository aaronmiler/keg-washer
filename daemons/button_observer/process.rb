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
    counts[:green] = 0
  else
    counts[:green] += 1
  end

  if counts[:green] > 5
    Cycle.run
  end

  sleep(0.1)
end
