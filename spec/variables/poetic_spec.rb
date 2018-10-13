RSpec.describe KaiserRuby do
  context 'poetic string literals' do
    it 'assigns string to a variable' do
      expect(KaiserRuby.transpile('Peter says Hello San Francisco!')).to eq '@peter = "Hello San Francisco!"'
    end

    it "doesn't strip apostrophes in the string" do
      expect(KaiserRuby.transpile("Newton says he's got a new theory to share")).to eq %Q{@newton = "he's got a new theory to share"}
    end
  end

  context 'poetic type literals' do
    it 'assigns a true to common variable' do
      expect(KaiserRuby.transpile('My heart is true')).to eq '@my_heart = true'
    end

    it 'assigns a zero to proper variable' do
      expect(KaiserRuby.transpile('Tommy is nobody')).to eq '@tommy = 0'
    end

    it 'assigns a false' do
      expect(KaiserRuby.transpile('Bad Wolf is wrong')).to eq '@bad_wolf = false'
    end

    it 'assigns a nil' do
      expect(KaiserRuby.transpile('Bad Wolf is mysterious')).to eq '@bad_wolf = nil'
    end

    it 'assigns a string' do
      expect(KaiserRuby.transpile('the password is "open sesame"')).to eq '@the_password = "open sesame"'
    end

    it 'assigns a literal number' do
      expect(KaiserRuby.transpile('Answer is 42')).to eq '@answer = 42'
    end    

    it 'captures a string as a numeric variable' do
      expect(KaiserRuby.transpile('Tommy was a lovestruck ladykiller')).to eq '@tommy = 100'
    end

    it 'ignores reserved words in the string' do
      expect(KaiserRuby.transpile('Mary is a rebel gone without lies')).to eq '@mary = 15474'
    end

    it 'ignores apostrophes and other nonalpha chars' do
      expect(KaiserRuby.transpile("My dreams were ice. A life unfulfilled; wakin' everybody up, taking booze and pills")).to eq "@my_dreams = 3.1415926535"
    end

    it 'converts decimals properly' do
      expect(KaiserRuby.transpile("Conversion is lovestruck. lovestruck and essential seasick")).to eq "@conversion = 0.0397"
    end

    it "ignores following dots" do
      expect(KaiserRuby.transpile("Conversion is lovestruck. lovestruck. and essential. seasick.")).to eq "@conversion = 0.0397"
    end

    it 'ignores nonalphabetic characters' do
      expect(KaiserRuby.transpile("my number is a 57 + true 43")).to eq "@my_number = 14"
    end

    it 'ignores nonalphabetic characters in decimals' do
      expect(KaiserRuby.transpile("my number is 100 a. 57 + true 43")).to eq "@my_number = 1.4"
    end
  end
end
