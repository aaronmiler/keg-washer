class Pins
  class << self
    @pin_map = {
      green_button: 11,
      red_button: 12,
      pump: 10,
      water: 10,
      drain: 10,
      cleaner: 10,
      cleaner_drain: 10,
      sani: 10,
      sani_drain: 10,
      air: 10,
      co2: 10,
      relay_10: 10,
      red_light: 10,
      yellow_light: 10,
      green_light: 10,
    }
    @pin_map.each do |name, pin|
      define_method(name) do
        return pin
      end
    end
  end
end
