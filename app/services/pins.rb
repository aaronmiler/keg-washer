class Pins
  PIN_MAP = {
    green_button: 11,
    red_button: 12,
    pump: 31,
    water: 36,
    drain: 29,
    cleaner: 22,
    cleaner_return: 40,
    sani: 37,
    sani_return: 33,
    air: 35,
    co2: 38,
    # UNSUED --- \/
    relay_8: 13,
    # UNSUED --- ^
    red_light: 16,
    yellow_light: 15,
    green_light: 32,
  }

  class << self
    PIN_MAP.each do |name, pin|
      define_method(name) do
        return pin
      end
    end

    def on(pin)
      warn " -- Turning on #{pin}"
      return unless Rails.application.config.raspi
      RPi::GPIO.set_high self.send(pin)
    end

    def off(pin)
      warn " -- Turning off #{pin}"
      return unless Rails.application.config.raspi
      RPi::GPIO.set_low self.send(pin)
    end

    def setup_pins
      warn "Setting Pins"
      return unless Rails.application.config.raspi

      RPi::GPIO.set_numbering :board
      PIN_MAP.each do |name, p|
        if name.to_s.include? 'button'
          RPi::GPIO.setup p, as: :input, pull: :up
        else
          RPi::GPIO.setup p, as: :output, initialize: :low
        end
      end
    end

    def cleanup
      return unless Rails.application.config.raspi
      RPi::GPIO.reset
    end
  end
end
