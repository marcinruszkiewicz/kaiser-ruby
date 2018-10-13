RSpec.describe KaiserRuby do
  Dir.glob("*.rock", base: file_fixture("reference/correct")).each do |filename|
    context "#{filename}" do
      let(:source) { file_fixture "reference/correct/#{filename}" }
      let(:output) { file_fixture "reference/correct/#{filename}.out" }

      it 'is correct' do
        expect(KaiserRuby.execute(source.read)).to eq output.read
      end
    end
  end
end