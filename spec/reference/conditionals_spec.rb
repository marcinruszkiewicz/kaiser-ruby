# frozen_string_literal: true

RSpec.describe KaiserRuby do
  describe 'conditionals specs' do
    Dir.glob('spec/fixtures/conditionals/*.rock').each do |filename|
      context filename.split('/').last.to_s do
        let(:source) { file_fixture filename.to_s }
        let(:output) { file_fixture "#{filename}.out" }

        it 'executes correctly' do
          expect(KaiserRuby.execute(source.read)).to eq output.read
        end
      end
    end
  end
end
