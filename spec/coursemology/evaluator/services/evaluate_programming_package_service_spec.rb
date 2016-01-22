require 'spec_helper'

RSpec.describe Coursemology::Evaluator::Services::EvaluateProgrammingPackageService do
  let(:package) { build(:programming_evaluation) }
  subject { Coursemology::Evaluator::Services::EvaluateProgrammingPackageService.new(package) }

  describe '.execute' do
    it 'returns a Coursemology::Evaluator::Services::EvaluateProgrammingPackageService::Result' do
      expect(subject.class.execute(package)).to \
        be_a(Coursemology::Evaluator::Services::EvaluateProgrammingPackageService::Result)
    end
  end

  describe '#create_container' do
    let(:image) { 'python:2.7' }
    let(:container) { subject.send(:create_container, image) }

    it 'prefixes the image with coursemology/evaluator-image' do
      expect(Docker::Image).to \
        receive(:create).with('fromImage' => "coursemology/evaluator-image-#{image}").
        and_call_original
      expect(Docker::Container).to \
        receive(:create).with('Image' => "coursemology/evaluator-image-#{image}")

      container
    end

    it 'instruments the pull' do
      expect { subject.send(:create_container, image) }.to \
        instrument_notification('pull.docker.evaluator.coursemology')
    end

    it 'instruments the creation' do
      expect { subject.send(:create_container, image) }.to \
        instrument_notification('create.docker.evaluator.coursemology')
    end
  end

  describe '#copy_package' do
    let(:container) { double }
    it 'copies to the home directory' do
      expect(container).to receive(:archive_in_stream).with(subject.class::HOME_PATH)
      subject.send(:copy_package, container)
    end
  end

  describe '#tar_package' do
    let(:tar_stream) { subject.send(:tar_package, package.package) }
    it 'resets the stream to the start' do
      expect(tar_stream.tell).to eq(0)
    end

    it 'copies all files, prefixed with the package directory name' do
      tar = Gem::Package::TarReader.new(tar_stream)
      entries = []
      tar.each do |entry|
        entries << entry.full_name
      end

      expect(entries).to contain_exactly('package/Makefile', 'package/submission/__init__.py')
    end
  end

  describe '#execute_package' do
    let(:image) { 'python:2.7' }
    let(:container) { subject.send(:create_container, image) }
    after { subject.send(:destroy_container, container) }

    def evaluate_result
      expect(container).to receive(:start!).and_call_original
      subject.send(:execute_package, container)
    end

    it 'evaluates the result' do
      evaluate_result
    end

    it 'returns only when the container has stopped running' do
      evaluate_result
      container.refresh!
      expect(container.info['State']['Running']).to be(false)
    end
  end

  describe '#extract_result' do
    let(:image) { 'python:2.7' }
    let(:container) do
      subject.send(:create_container, image).tap do |container|
        subject.send(:execute_package, container)
      end
    end
    after { subject.send(:destroy_container, container) }

    it 'does not expose raw Docker Attach Protocol in the output' do
      result = subject.send(:extract_result, container)
      expect(result.stdout).not_to include("\u0000")
      expect(result.stderr).not_to include("\u0000")
    end
  end

  describe '#extract_test_report' do
    let(:image) { 'python:2.7' }
    let(:report_path) { File.join(__dir__, '../../../fixtures/sample_report.xml') }
    let(:report_contents) { File.read(report_path) }
    let(:container) { subject.send(:create_container, image) }

    def copy_dummy_report
      container.start!
      container.wait
      tar = StringIO.new(Docker::Util.create_tar('report.xml' => report_contents))
      container.archive_in_stream(Coursemology::Evaluator::Services::
          EvaluateProgrammingPackageService::PACKAGE_PATH) do
        tar.read
      end
    end
    after { subject.send(:destroy_container, container) }

    it 'returns the test report' do
      copy_dummy_report
      expect(subject.send(:extract_test_report, container)).to eq(report_contents)
    end

    context 'when running the tests fails' do
      it 'returns nil' do
        expect(subject.send(:extract_test_report, container)).to be_nil
      end
    end
  end

  describe '#destroy_container' do
    let(:image) { 'python:2.7' }
    let(:container) { subject.send(:create_container, image) }

    it 'instruments the destruction' do
      expect { subject.send(:destroy_container, container) }.to \
        instrument_notification('destroy.docker.evaluator.coursemology')
    end
  end
end
