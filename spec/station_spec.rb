require 'station'

describe Station do
  let(:station) { Station.new('Angel', 'Zone 1') }
  it 'returns a name' do
    expect(station.name).to eq('Angel')
  end
  it 'returns a zone' do
    expect(station.zone).to eq('Zone 1')
  end
end
