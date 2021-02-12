require 'oystercard'
require 'station'

describe Oystercard do
  let(:station){ double :station }
  let(:exit_station){ double :station }

  it 'has a balance of 0 by default' do
    expect(subject.balance).to eq(0)
  end
  it 'has a limit' do
    expect(Oystercard::LIMIT).to eq(90)
  end
  it 'has a minimum fare' do
    expect(Oystercard::MINIMUM_FARE).to eq(1)
  end
  it 'has an empty list of journeys' do
    expect(subject.journey_list.length).to eq(0)
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

  describe '#touch_in' do
    it 'changes in_journey status to true' do
      subject.instance_variable_set(:@balance, 5)
      subject.touch_in(station)
      expect(subject).to be_in_journey
    end
    it 'should raise an error if the balance is less than the minimum fare' do
      expect { subject.touch_in(station) }.to raise_error("balance too low")
    end
  end

  describe '#in_journey' do
    it 'responds to a in_journey method' do
      expect(subject).to respond_to(:in_journey?)
    end
  end

  describe '#touch_out' do
    before (:each) do
      subject.instance_variable_set(:@journey_list, [{entry_station: station, exit_station: nil}])
      subject.instance_variable_set(:@balance, 10)
    end
    it 'changes in_journey status to false' do
      subject.touch_in(station)
      subject.touch_out(exit_station)
      expect(subject).not_to be_in_journey
    end
    it 'reduces the balance by minimum fare' do
      expect { subject.touch_out(exit_station) }.to change{ subject.balance }.by(-Oystercard::MINIMUM_FARE)
    end
  end

  describe "station history" do
    let(:started_journey){ {entry_station: station, exit_station: nil} }
    let(:completed_journey){ {entry_station: station, exit_station: exit_station} }
    before (:each) do
      subject.instance_variable_set(:@balance, 10)
      subject.touch_in(station)
    end
    it "remembers the entry station on touch in" do
      expect(subject.entry_station).to eq station
    end
    it "forgets the entry station on touch out" do
      subject.touch_out(exit_station)
      expect(subject.entry_station).to eq nil
    end
    it "pushes entry station to journey list" do
      expect(subject.journey_list).to include started_journey
    end
    it "pushes exit station to journey list" do
      subject.touch_out(exit_station)
      expect(subject.journey_list).to include completed_journey
    end
  end
end
