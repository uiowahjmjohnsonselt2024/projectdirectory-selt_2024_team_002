# frozen_string_literal: true

# mock card class for testing
class Card
  def initialize(suit, value)
    @suit = suit
    @value = value
  end

  def value
    case @value
    when 'A'
      11
    when 'J', 'Q', 'K'
      10
    else
      @value.to_i
    end
  end
end
