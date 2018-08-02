RSpec.describe KaiserRuby do
  context 'poetic type literals' do
    it 'assigns a boolean to common variable' do
      expect(KaiserRuby.transpile('My heart is true')).to eq 'my_heart = true'
    end

    it 'assigns a boolean to proper variable' do
      expect(KaiserRuby.transpile('Tommy is nobody')).to eq 'tommy = nil'
    end
  end

  context 'poetic string literals' do
    it 'assigns string to a variable' do
      expect(KaiserRuby.transpile('Peter says Hello San Francisco!')).to eq 'peter = "Hello San Francisco!"'
    end
  end

  context 'poetic number literals' do
    it 'captures a string as a numeric variable' do
      expect(KaiserRuby.transpile('Tommy was a lovestruck ladykiller')).to eq 'tommy = 100'
    end

    it 'ignores reserved words in the string' do
      expect(KaiserRuby.transpile('Mary is a rebel gone without lies')).to eq 'mary = 15474'
    end

    it 'ignores apostrophes and other nonalpha chars' do
      expect(KaiserRuby.transpile("My dreams were ice. A life unfulfilled; wakin' everybody up, taking booze and pills")).to eq "my_dreams = 3.1415926535"
    end
  end
end