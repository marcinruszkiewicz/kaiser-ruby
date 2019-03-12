# frozen_string_literal: true

RSpec.describe KaiserRuby do
  describe 'trying to call a non-function' do
    Dir.glob('spec/fixtures/old_reference_tests/runtime-errors/notCallable/*.rock').each do |filename|
      context filename.split('/').last.to_s do
        let(:source) { file_fixture filename.to_s }

        it 'raises no method error' do
          expect { KaiserRuby.execute(source.read) }.to raise_error NoMethodError
        end
      end
    end
  end

  describe 'calling a function with wrong number of arguments' do
    let(:source) { file_fixture 'spec/fixtures/old_reference_tests/runtime-errors/wrongNumberOfArguments.rock' }

    it 'raises argument error' do
      expect { KaiserRuby.execute(source.read) }.to raise_error ArgumentError
    end
  end

  describe 'division by zero' do
    let(:source) { file_fixture 'spec/fixtures/old_reference_tests/runtime-errors/nestedError.rock' }

    it 'raises zerodivision error' do
      expect { KaiserRuby.execute(source.read) }.to raise_error ZeroDivisionError
    end
  end
end
