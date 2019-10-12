RSpec.describe Martilla::Backup do
  let(:backup) { Martilla::Backup.new(Martilla::Backup.sample_config) }

  describe 'formats time durations correctly' do
    it 'works for seconds only durations' do
      expect(backup.duration_format(22)).to eq('22s')
      expect(backup.duration_format(1)).to eq('1s')
      expect(backup.duration_format(59)).to eq('59s')
    end

    it 'works for minutes & seconds durations' do
      expect(backup.duration_format(192)).to eq('3m 12s')
      expect(backup.duration_format(1044)).to eq('17m 24s')
      expect(backup.duration_format(3599)).to eq('59m 59s')
      expect(backup.duration_format(60)).to eq('1m 0s')
    end

    it 'works for hours & minutes & seconds durations' do
      expect(backup.duration_format(12292)).to eq('3h 24m 52s')
      expect(backup.duration_format(7044)).to eq('1h 57m 24s')
      expect(backup.duration_format(82599)).to eq('22h 56m 39s')
      expect(backup.duration_format(3600)).to eq('1h 0m 0s')
      expect(backup.duration_format(43200)).to eq('12h 0m 0s')
    end
  end
end
