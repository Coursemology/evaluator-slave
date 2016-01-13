require 'spec_helper'

RSpec.describe Coursemology::Polyglot::Language do
  let(:type) { Coursemology::Polyglot::Language::Python::Python3Point4.name }

  describe '.find_by' do
    context 'when given a Polyglot language' do
      it 'returns a new instance of the language' do
        expect(subject.class.find_by(type: type).class.name).to eq(type)
      end
    end

    context 'when given a non-existent language' do
      it 'returns nil' do
        expect(subject.class.find_by(type: '')).to be_nil
      end
    end
  end

  describe '.find_by!' do
    context 'when given a Polyglot language' do
      it 'returns a new instance of the language' do
        expect(subject.class.find_by!(type: type).class.name).to eq(type)
      end
    end

    context 'when given a non-existent language' do
      it 'returns nil' do
        expect { subject.class.find_by!(type: '') }.to raise_error(ArgumentError)
      end
    end
  end
end
