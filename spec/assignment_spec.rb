RSpec.describe KaiserRuby do
  let(:result) { KaiserRuby.transpile(input) }

  context 'poetic number assignment' do
    context 'default behaviour' do
      let(:input) { "Tommy was a lean mean wrecking machine" }

      it "assigns a number to a variable" do
        expect(result).to eq "tommy = 14487"
      end
    end

    context "shortened is" do
      let(:input) { "Janie's got a gun" }

      it "assigns a number to a variable" do
        expect(result).to eq "janie = 313"
      end
    end
  end

  context 'poetic string assignment' do
    let(:input) { "Peter says Hello San Francisco!" }

    it 'assigns a string to a variable' do
      expect(result).to eq 'peter = "Hello San Francisco!"'
    end
  end

  context 'poetic type assignment' do
    context 'true' do
      let(:input) { "Desire is true" }

      it "assigns true value to a variable" do
        expect(result).to eq "desire = true"
      end
    end

    context 'false' do
      let(:input) { "Hate is wrong" }

      it "assigns false value to a variable" do
        expect(result).to eq "hate = false"
      end
    end

    context 'nil' do
      let(:input) { 'Love is gone' }

      it "assigns a null value to a variable" do
        expect(result).to eq "love = nil"
      end
    end

    context "shortened is" do
      let(:input) { "Janie's nowhere" }

      it "assigns a null value to a variable" do
        expect(result).to eq "janie = nil"
      end
    end
  end
end
