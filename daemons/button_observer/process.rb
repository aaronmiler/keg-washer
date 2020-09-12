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
RPi::GPIO.setup Pins.green_light, as: :output, initialize: :low
RPi::GPIO.setup Pins.yellow_light, as: :output, initialize: :low

def flash_yellow
  clear_lights
  Thread.new {
    loop do
      Pins.on(:yellow_light)
      sleep(1)
      Pins.off(:yellow_light)
      sleep(1)
    end
  }
end

def clear_lights
  Pins.off(:green_light)
  Pins.off(:yellow_light)
  Pins.off(:red_light)
end

def light_on(color)
  clear_lights
  case color
    when :green then Pins.on(:green_light)
    when :red then Pins.on(:red_light)
  end
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
        t = flash_yellow
        warn "Starting Cycle"
        Cycle.run
        t.exit
        light_on(:green)
      end
    rescue
      t.exit
      light_on(:red)
      puts "Cycle Aborted"
    end

    sleep(0.1)
  end
ensure
  RPi::GPIO.reset
end
