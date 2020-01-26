describe Domain::RunJob do
  describe '#create' do
    context 'when event exists' do
      it 'fires event' do
        run_job = described_class.new('some_uid', 'email')
        run_job.create({ action: 'received', id: 1 })
        expect(run_job).to have_applied(event(Events::EmailReceived)).once
      end
    end

    context 'when event does not exist' do
      it 'raises NotImplementedError error' do
        run_job = described_class.new('some_uid', 'email')
        expect { run_job.create({ action: 'not_supported_action', id: 1 }) }.to raise_error(NotImplementedError)
      end
    end
  end
end

