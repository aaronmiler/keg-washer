module Cycle

  @cycles = {
    empty: %i[ drain ],
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
  ensure
    warn "Cleanup Time"
    Pins.cleanup
  end

  def step(step)
    duration = settings[step] || 5
    warn "Cycle: #{step}"

    cycle = @cycles[step]
    pause = cycle.delete(:pause).present?

    cycle.each { |x| Pins.on(x) }

    s = Time.now
    until Time.now - s > duration
      raise "ABORT!" if RPi::GPIO.high? Pins.red_button
      printf '.'
      sleep 0.1
    end

    cycle.each { |x| Pins.off(x) }

    if pause
      p = cycle.select { |x| x.to_s.include?('return') || x == :drain }
      warn "Pause #{p.inspect}"
      Pins.on(p[0])
      sleep(1)
      Pins.off(p[0])
    end
  end

  def settings
    @_s ||= JSON.parse((redis.get('cycle_settings') || '{}'), symbolize_names: true)
  end

  def redis
    @r ||= Redis.new
  end
end
