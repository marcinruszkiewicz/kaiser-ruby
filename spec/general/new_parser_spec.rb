RSpec.describe KaiserRuby do
  let(:input) do <<~END
      Build max up, up, up
      Knock mary down
      Mary is nothing
      Tom was a dancer
      my world is spinning around
      Rock says hello there
      Listen to the noise
      Give back Tom
      Say my name
      take it to the top
      break it down
      Midnight taking 1, 3
      put nothing into heart
    END
  end

  let(:one_argument) do <<~END
      Midnight takes Hate
      If Desire is nothing
      Shout Desire
      If Hate is nothing
      Shout Hate


      Give back Desire

      Say my name
    END
  end  

  it 'works' do
    o = KaiserRuby.parse(one_argument)
  end
end