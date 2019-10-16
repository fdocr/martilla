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
      expect(backup.duration_format(1_044)).to eq('17m 24s')
      expect(backup.duration_format(3_599)).to eq('59m 59s')
      expect(backup.duration_format(60)).to eq('1m 0s')
    end

    it 'works for hours & minutes & seconds durations' do
      expect(backup.duration_format(12_292)).to eq('3h 24m 52s')
      expect(backup.duration_format(7_044)).to eq('1h 57m 24s')
      expect(backup.duration_format(82_599)).to eq('22h 56m 39s')
      expect(backup.duration_format(3_600)).to eq('1h 0m 0s')
      expect(backup.duration_format(432_00)).to eq('12h 0m 0s')
    end
  end

  describe 'formats file sizes correctly' do
    it 'works for KB sizes' do
      backup.instance_variable_set(:@file_size, 1_024.to_f)
      expect(backup.formatted_file_size).to eq('1.00 KB')
      backup.instance_variable_set(:@file_size, 71_509.to_f)
      expect(backup.formatted_file_size).to eq('69.83 KB')
      backup.instance_variable_set(:@file_size, 799_999.to_f)
      expect(backup.formatted_file_size).to eq('781.25 KB')
    end

    it 'works for MB sizes' do
      backup.instance_variable_set(:@file_size, 800_000.to_f)
      expect(backup.formatted_file_size).to eq('0.76 MB')
      backup.instance_variable_set(:@file_size, 20_499_999.to_f)
      expect(backup.formatted_file_size).to eq('19.55 MB')
      backup.instance_variable_set(:@file_size, 799_999_999.to_f)
      expect(backup.formatted_file_size).to eq('762.94 MB')
    end

    it 'works for GB sizes' do
      backup.instance_variable_set(:@file_size, 800_000_000.to_f)
      expect(backup.formatted_file_size).to eq('0.75 GB')
      backup.instance_variable_set(:@file_size, 881_508_000_000.to_f)
      expect(backup.formatted_file_size).to eq('820.97 GB')
    end
  end

  it 'returns a valid sample_config' do
    sample_config_hash = Martilla::Backup.sample_config
    sample_backup = Martilla::Backup.new(sample_config_hash)
    expect(sample_backup).to be_instance_of(Martilla::Backup)
  end
end
