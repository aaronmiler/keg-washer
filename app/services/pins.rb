class Pins
  class << self
    @pin_map = {
      green_button: 11,
      red_button: 12,
      pump: 31,
      water: 36,
      drain: 29,
      cleaner: 22,
      cleaner_drain: 40,
      sani: 37,
      sani_drain: 33,
      air: 35,
      co2: 38,
      # UNSUED --- \/
      relay_8: 13,
      # UNSUED --- ^
      red_light: 16,
      yellow_light: 15,
      green_light: 32,
    }
    @pin_map.each do |name, pin|
      define_method(name) do
        return pin
      end
    end

    def on(pin)
      warn "Turning on #{pin}"
      return unless Rails.application.config.raspi
      RPi::GPIO.set_high self.send(pin)
    end

    def off(pin)
      warn "Turning off #{pin}"
      return unless Rails.application.config.raspi
      RPi::GPIO.set_high self.send(pin)
    end

    def setup_pins
      warn "Setting Pins"
      return unless Rails.application.config.raspi

      RPi::GPIO.set_numbering :board
      @pin_map.values.each do |p|
        RPi::GPIO.setup p, as: :output
      end
    end

    def cleanup
      return unless Rails.application.config.raspi
      RPi::GPIO.reset
    end
  end
end
