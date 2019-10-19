RSpec.describe Martilla::EmailNotifier do
  describe 'options allow to customize default values' do
    it 'success_subject' do
      options = { 'success_subject' => 'GREAT SUCCESS' }
      notifier = Martilla::EmailNotifier.new(options)
      expect(notifier.send(:success_subject)).to eq(options['success_subject'])
    end

    it 'failure_subject' do
      options = { 'failure_subject' => 'HIGH FIVE' }
      notifier = Martilla::EmailNotifier.new(options)
      expect(notifier.send(:failure_subject)).to eq(options['failure_subject'])
    end
  end
end
