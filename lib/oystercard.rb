
class Oystercard
  attr_reader :balance, :limit, :entry_station

  LIMIT = 90
  MINIMUM_FARE = 1

  def initialize
    @balance = 0
  end

  def top_up(value)
    raise "top up limit of #{LIMIT} exceeded" if @balance + value > LIMIT
    @balance += value
  end

  def touch_in station
    raise "balance too low" if @balance < MINIMUM_FARE
    @entry_station = station
  end

  def in_journey?
    !(@entry_station == nil)
  end

  def touch_out
    deduct(MINIMUM_FARE)
    @entry_station = nil
  end

  private

  def deduct(value)
    @balance -= value
  end

end
