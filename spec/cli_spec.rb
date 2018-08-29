RSpec.describe KaiserRuby do
  let(:cli) { KaiserRuby::CLI.new }

  context 'rock' do
    let(:output) { capture(:stdout) { cli.rock } }

    it 'should run the REPL' do
      expect(Thor::LineEditor).to receive(:readline).with('\m/> ', {}).and_return('exit')
      expect(output).to eq "Type 'exit' to exit the console. Otherwise, rock on!\n"
    end
  end
end
