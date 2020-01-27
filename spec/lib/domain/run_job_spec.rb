describe Domain::RunJob do
  describe '#create' do
    context 'when event exists' do
      it 'fires event' do
        run_job = described_class.new('some_uid', 'email')
        run_job.create({ status: 'received', id: 1 }, 'status')

        expect(run_job.state).to eq('received')
        expect(run_job).to have_applied(event(Events::EmailReceived)).once
      end
    end

    context 'when in error state' do
      it 'raises JobInErrorState exception' do
        run_job = described_class.new('some_uid', 'email')
        allow(run_job).to receive(:error?).and_return(true)
        expect { run_job.create({ status: 'received', id: 1 }, 'status') }.to raise_error(Domain::RunJob::InErrorStateError)
      end
    end

    context 'when event does not exist' do
      it 'raises NotImplementedError error' do
        run_job = described_class.new('some_uid', 'email')
        expect { run_job.create({ status: 'not_supported_state', id: 1 }, 'status') }.to raise_error(NotImplementedError)
      end
    end
  end
end

