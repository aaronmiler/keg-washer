module Cycle

  @cycles = {
    empty: %i[ drain pause ],
    water: %i[ pump drain water pause ],
    air: %i[ air drain pause ],
    cleaner: %i[ pump cleaner cleaner_return water pause ],
    sani: %i[ pump sani sani_return water pause ],
    co2: %i[ co2 drain ],
  }

  @routine = [
    :empty,
    :water,
    :air,
    :cleaner,
    :air,
    :sani,
    :air,
    :co2,
  ]

  # step
  # close all
  # step
  # close all

  module_function

  def run
    Pins.setup_pins
    redis.set("start_time", Time.now)

    @routine.each_with_index do |s, i|
      redis.set("current_step", i)
      step(s)
    end
    redis.set("completed", Time.now)
    "Complete"
  end

  def step(step)
    cycle = @cycles[step]
    cycle.each { |x| Pins.on(x) }
    sleep(5)
    cycle.each { |x| Pins.off(x) }
  end

  def settings
    @_s ||= JSON.parse(redis.get('cycle_settings'), symbolize_names: true)
  end

  def redis
    @r ||= Redis.new
  end
end
