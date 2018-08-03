RSpec.describe KaiserRuby do
  context 'string type' do
    it 'treats double quoted string as a string' do
      expect(KaiserRuby.transpile('"Hello San Francisco"')).to eq '"Hello San Francisco"'
    end
  end

  context 'numeric type' do
    it 'converts integers' do
      expect(KaiserRuby.transpile('1234')).to eq '1234'
    end

    it 'converts floats' do
      expect(KaiserRuby.transpile('3.14')).to eq '3.14'
    end
  end

  context 'mysterious type' do
    it 'converts some words to undefined/nil' do
      expect(KaiserRuby.transpile('mysterious')).to eq 'nil'
    end
  end

  context 'null type' do
    it 'converts some words to null (actually zero)' do
      expect(KaiserRuby.transpile('empty')).to eq '0'
    end
  end

  context 'true type' do
    it 'converts some words to true' do
      expect(KaiserRuby.transpile('ok')).to eq 'true'
    end
  end

  context 'false type' do
    it 'converts some words to false' do
      expect(KaiserRuby.transpile('wrong')).to eq 'false'
    end
  end
end