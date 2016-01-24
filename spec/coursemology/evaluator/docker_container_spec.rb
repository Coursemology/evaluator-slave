RSpec.describe Coursemology::Evaluator::DockerContainer do
  let(:image) { 'coursemology/evaluator-image-python:2.7' }
  let(:delete_subject) { true }
  subject { Coursemology::Evaluator::DockerContainer.create(image) }
  after { subject.delete if delete_subject }

  describe '.create' do
    it 'instruments the pull' do
      expect { subject }.to instrument_notification('pull.docker.evaluator.coursemology')
    end

    it 'instruments the creation' do
      expect { subject }.to instrument_notification('create.docker.evaluator.coursemology')
    end
  end

  describe '#wait' do
    it 'retries until the container finishes' do
      subject.start!
      expect(subject).to receive(:refresh!).and_call_original.at_least(:once)

      expect(subject.wait(0)).not_to be_nil
    end

    it 'returns the exit code of the container' do
      expect(subject.wait).to eq(subject.exit_code)
    end
  end

  describe '#exit_code' do
    context 'when the container has been waited upon' do
      it 'returns the exit code of the container' do
        subject.wait
        expect(subject.exit_code).not_to be_nil
      end
    end

    context 'when the container is still running' do
      it 'returns nil' do
        expect(subject.exit_code).to be_nil
      end
    end
  end

  describe '#delete' do
    let(:delete_subject) { false }
    it 'instruments the destruction' do
      expect { subject.delete }.to instrument_notification('destroy.docker.evaluator.coursemology')
    end
  end
end
