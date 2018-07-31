RSpec.describe KaiserRuby do
  let(:result) { KaiserRuby.transpile(input) }

  context 'one word proper variables' do
    let(:input) { "Love is right" }

    it 'makes a variable' do
      expect(result).to eq "love = true"
    end
  end

  context 'more than one word' do
    let(:input) { "Billie Jean is bad as lover" }

    it 'makes a variable' do
      expect(result).to eq "billie_jean = 325"
    end
  end

  context 'common variables' do
    let(:input) { "My world is empty" }

    it 'makes a variable' do
      expect(result).to eq "my_world = nil"
    end
  end
end