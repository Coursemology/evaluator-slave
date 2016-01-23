RSpec.describe Coursemology::Evaluator::DockerContainer do
  let(:image) { 'coursemology/evaluator-image-python:2.7' }
  subject { Coursemology::Evaluator::DockerContainer.create(image) }

  describe '.create' do
    it 'instruments the pull' do
      expect { subject }.to instrument_notification('pull.docker.evaluator.coursemology')
    end

    it 'instruments the creation' do
      expect { subject }.to instrument_notification('create.docker.evaluator.coursemology')
    end
  end

  describe '#delete' do
    it 'instruments the destruction' do
      expect { subject.delete }.to instrument_notification('destroy.docker.evaluator.coursemology')
    end
  end
end
