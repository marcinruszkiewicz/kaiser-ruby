# frozen_string_literal: true

RSpec.describe KaiserRuby do
  describe 'io specs' do
    Dir.glob('spec/fixtures/io/*.rock').each do |filename|
      context filename.split('/').last.to_s do
        let(:source) { file_fixture filename.to_s }
        let(:input) { file_fixture "#{filename}.in'" }
        let(:output) { file_fixture "#{filename}.out" }

        it 'executes correctly' do
          InputFaker.with_fake_input(input.read.split("\n")) do
            expect(KaiserRuby.execute(source.read)).to eq output.read
          end
        end
      end
    end
  end
end
