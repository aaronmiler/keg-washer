require 'rpi_gpio'
require 'redis'
require File.expand_path('../../../config/environment', __FILE__)

r = Redis.new
count = 0
status = :red_light

Rails.application.eager_load!

# Setup Pins
RPi::GPIO.set_numbering :board
RPi::GPIO.setup Pins.green_button, as: :input, pull: :up
RPi::GPIO.setup Pins.red_light, as: :output, initialize: :low
RPi::GPIO.setup Pins.yellow_light, as: :output, initialize: :low
RPi::GPIO.setup Pins.green_light, as: :output, initialize: :low


def clear_lights
  Pins.off(:green_light)
  Pins.off(:yellow_light)
  Pins.off(:red_light)
end

begin
  Pins.on(:red_light)
  Pins.on(:green_light)
  Pins.on(:yellow_light)
  loop do
    if RPi::GPIO.low? Pins.green_button
      count += 1
    else
      count = 0
    end

    begin
      if count > 2
        clear_lights
        Pins.on(:yellow_light)
        warn "Starting Cycle"
        Cycle.run
        clear_lights
        Pins.on(:green_light)
      end
    rescue
      clear_lights
      Pins.on(:red_light)
      puts "Cycle Aborted"
    end

    sleep(0.1)
  end
ensure
  RPi::GPIO.reset
end
