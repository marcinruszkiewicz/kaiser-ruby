RSpec.describe KaiserRuby do
  let(:result) { KaiserRuby.transpile(input) }

  context 'single block' do
    let(:input) do %{Lucy was a demon
Mark was an angel}
    end

    it 'makes lines from a single block' do
      expect(result).to eq %{lucy = 15
mark = 25}
    end
  end

  context 'multiple blocks' do
    let(:input) do %{Lucy was a demon
Mark was an angel

Hate is wrong
Love is true}
    end

    it 'keeps separate lines' do
      expect(result).to eq %{lucy = 15
mark = 25

hate = false
love = true}
    end
  end
end