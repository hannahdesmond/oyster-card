
class Oystercard
  attr_reader :balance, :limit, :entry_station, :journey_list

  LIMIT = 90
  MINIMUM_FARE = 1

  def initialize
    @balance = 0
    @journey_list = []
  end

  def top_up(value)
    raise "top up limit of #{LIMIT} exceeded" if @balance + value > LIMIT
    @balance += value
  end

  def touch_in station
    raise "balance too low" if @balance < MINIMUM_FARE
    @entry_station = station
    started_journey = { entry_station: station, exit_station: nil }
    @journey_list << started_journey
  end

  def in_journey?
    !(@entry_station == nil)
  end

  def touch_out exit_station
    deduct(MINIMUM_FARE)
    @entry_station = nil
    @journey_list.last[:exit_station] = exit_station 
  end

  private

  def deduct(value)
    @balance -= value
  end

end
