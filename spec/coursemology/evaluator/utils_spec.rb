# frozen_string_literal: true
RSpec.describe Coursemology::Evaluator::Utils do
  describe '.parse_docker_stream' do
    def build_docker_header(stream, length)
      [stream, 0, 0, 0, length].pack('CCCCN')
    end

    def build_docker_block(stream, data)
      build_docker_header(stream, data.length) + data
    end

    let(:data) { 'abcdefgh' }
    let(:stream) { STDOUT.fileno }
    let(:docker_block) { build_docker_block(stream, data) }
    subject { Coursemology::Evaluator::Utils.parse_docker_stream(docker_block) }

    it 'parses a Docker Attach protocol fragment' do
      expect(subject).to eq(['', data, ''])
    end

    context 'when the stream has a malformed header' do
      let(:docker_block) { super()[0..5] }
      it 'raises an IOError' do
        expect { subject }.to raise_error(IOError)
      end
    end

    context 'when the stream has a block that is nonstandard' do
      let(:stream) { 7 }
      it 'does not return the stream' do
        expect(subject).to eq(['', '', ''])
      end
    end
  end
end
