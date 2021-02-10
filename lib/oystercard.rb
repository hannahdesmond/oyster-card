
class Oystercard
  attr_reader :balance, :limit

  LIMIT = 90
  MINIMUM_FARE = 1

  def initialize
    @balance = 0
    @in_journey = false
  end

  def top_up(value)
    raise "top up limit of #{LIMIT} exceeded" if @balance + value > LIMIT
    @balance += value
  end

  def deduct(value)
    @balance -= value
  end

  def touch_in
    raise "balance too low" if @balance < MINIMUM_FARE
    @in_journey = true
  end

  def in_journey?
    @in_journey
  end

  def touch_out
    @in_journey = false
  end

end
