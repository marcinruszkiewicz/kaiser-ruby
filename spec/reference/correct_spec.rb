RSpec.describe KaiserRuby do
  Dir.glob("spec/fixtures/reference/correct/*.rock").each do |filename|
    context "#{filename}" do
      let(:source) { file_fixture "#{filename}" }
      let(:output) { file_fixture "#{filename}.out" }

      it 'is correct' do
        expect(KaiserRuby.execute(source.read)).to eq output.read
      end
    end
  end
end