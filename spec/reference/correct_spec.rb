RSpec.describe KaiserRuby do
  context 'poetic literals' do
    let(:input) { file_fixture "reference/correct/poeticLiterals.rock" }
    let(:output) { file_fixture "reference/correct/poeticLiterals.rock.out" }

    it 'is correct' do
      expect(KaiserRuby.execute(input.read)).to eq output.read
    end
  end

  context 'poetic numbers' do
    let(:input) { file_fixture "reference/correct/poeticNumbers.rock" }
    let(:output) { file_fixture "reference/correct/poeticNumbers.rock.out" }

    it 'is correct' do
      expect(KaiserRuby.execute(input.read)).to eq output.read
    end
  end

  context 'poetic strings' do
    let(:input) { file_fixture "reference/correct/poeticStrings.rock" }
    let(:output) { file_fixture "reference/correct/poeticStrings.rock.out" }

    it 'is correct' do
      expect(KaiserRuby.execute(input.read)).to eq output.read
    end
  end  
end