class BlackjackGame < ApplicationRecord
  belongs_to :user_world

  after_initialize :initialize_game

  def initialize_game
    self.state ||= {
      deck: init_deck,
      player_hand: [],
      dealer_hand: [],
      player_score: 0,
      dealer_score: 0,
      status: 'ongoing'
    }
    deal_initial_cards
  end

  def init_deck
    suits = %w[hearts diamonds clubs spades]
    values = %w[2 3 4 5 6 7 8 9 10 J Q K A]

    suits.product(values).shuffle
  end

  def deal_card(hand)
    card = state[:deck].pop
    hand << card
    save
  end

  def calculate_score(hand)
    values = hand.map { |card| card_value(card[1]) }
    score = values.sum
    values.count(11).times { score -= 10 if score > 21 }
    score
  end

  def card_value(value)
    return value.to_i if value.to_i != 0
    return 10 if %w[J Q K].include?(value)
    return 11 if value == 'A'
  end

  def update_scores
    state[:player_score] = calculate_score(state[:player_hand])
    state[:dealer_score] = calculate_score(state[:dealer_hand])
    save
  end

  def hit
    deal_card(state[:player_hand])
    update_scores
    check_game_status
  end

  def stand
    while state[:dealer_score] < 17
      deal_card(state[:dealer_hand])
      update_scores
    end
    check_game_status
  end

  def check_game_status
    if state[:player_score] > 21
      state[:status] = 'player_bust'
    elsif state[:dealer_score] > 21
      state[:status] = 'dealer_bust'
    elsif state[:dealer_score] >= 17
      if state[:player_score] > state[:dealer_score]
        state[:status] = 'player_wins'
      elsif state[:player_score] < state[:dealer_score]
        state[:status] = 'dealer_wins'
      else
        state[:status] = 'push'
      end
    end
    save
  end
end
