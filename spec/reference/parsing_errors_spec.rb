RSpec.describe KaiserRuby do
  describe 'parsing errors' do
    Dir.glob("spec/fixtures/reference/parse-errors/*.rock").each do |filename|
      context "#{filename.split('/').last}" do
        let(:source) { file_fixture "#{filename}" }

        it 'throws syntax error' do
          expect { KaiserRuby.execute(source.read) }.to raise_error KaiserRuby::RockstarSyntaxError
        end
      end
    end
  end
end