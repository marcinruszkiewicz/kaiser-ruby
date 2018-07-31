RSpec.describe KaiserRuby do
  let(:result) { KaiserRuby.transpile(input) }

  context 'number assignment' do
    let(:input) { "Tommy was a lean mean wrecking machine" }

    it "assigns a number to a variable" do
      expect(result).to eq "tommy = 14487"
    end
  end
end
