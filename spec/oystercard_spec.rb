require 'oystercard'

describe Oystercard do
  it 'has a balance of 0 by default' do
    expect(subject.balance).to eq(0)
  end
  it 'has a limit' do
    expect(Oystercard::LIMIT).to eq(90)
  end
  it 'has a minimum fare' do
    expect(Oystercard::MINIMUM_FARE).to eq(1)
  end

  describe '#top_up' do
    it 'should take a top-up value and add it to the card balance' do
      subject.top_up(10)
      expect(subject.balance).to eq(10)
    end
    it 'should raise an error if top_up returns more than 90' do
      subject.top_up(Oystercard::LIMIT)
      expect { subject.top_up(1) }.to raise_error("top up limit of #{Oystercard::LIMIT} exceeded")
    end
  end

  describe '#deduct' do
    it 'responds to a deduct method' do
      expect(subject).to respond_to(:deduct).with(1).argument
    end
    it 'should deduct the fare from the balance' do
      subject.top_up(10)
      expect(subject.deduct(5)).to eq(5)
    end
  end

  describe '#touch_in' do
    it 'responds to a touch_in method' do
      expect(subject).to respond_to(:touch_in)
    end
    it 'changes in_journey status to true' do
      subject.touch_in
      expect(subject).to be_in_journey
    end
    it 'should raise an error if the balance is less than the minimum fare' do
      expect { subject.touch_in }.to raise_error("balance too low")  
    end
  end

  describe '#in_journey' do
    it 'responds to a in_journey method' do
      expect(subject).to respond_to(:in_journey?)
    end
  end

  describe '#touch_out' do
    it 'responds to a touch_out method' do
      expect(subject).to respond_to(:touch_out)
    end
    it 'changes in_journey status to false' do
      subject.touch_in
      subject.touch_out
      expect(subject).not_to be_in_journey
    end
  end

end
