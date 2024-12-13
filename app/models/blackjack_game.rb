# frozen_string_literal: true

# Model for the Blackjack game
class BlackjackGame < ApplicationRecord
  belongs_to :user_world

  # serialize :state, type: Hash

  after_initialize :initialize_game

  def state
    @state ||= begin
      raw_state = read_attribute(:state)
      raw_state.is_a?(String) ? JSON.parse(raw_state) : raw_state
    end
  end

  def state=(value)
    super(value.to_json)
    @state = value
  end

  def initialize_game
    if state.blank? || state == {}
      self.state = default_state
    end
    puts "Initialized state: #{self.state.inspect}" # Debug statement
    deal_initial_cards if state['deck'].nil? || state['deck'].empty?
    save
  end

  def reset_game
    self.state = default_state
    deal_initial_cards
    save
  end

  def default_state
    {
      deck: init_deck,
      player_hand: [],
      dealer_hand: [],
      player_score: 0,
      dealer_score: 0,
      status: 'ongoing'
    }
  end

  def init_deck
    suits = %w[hearts diamonds clubs spades]
    values = %w[2 3 4 5 6 7 8 9 10 J Q K A]
    deck = suits.product(values).shuffle
    Rails.logger.debug "Initialized deck: #{deck.inspect}" # Debug statement
    deck
  end

  def deal_initial_cards
    state['deck'] ||= init_deck
    state['player_hand'] ||= []
    state['dealer_hand'] ||= []
    2.times do
      deal_card(state['player_hand'])
      deal_card(state['dealer_hand'])
    end
    update_scores
  end

  def deal_card(hand)
    card = state['deck'].pop
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

    11 if value == 'A'
  end

  def update_scores
    state['player_score'] = calculate_score(state['player_hand'])
    state['dealer_score'] = calculate_score(state['dealer_hand'])
    save
  end

  def hit
    deal_card(state['player_hand'])
    update_scores
    check_game_status
  end

  def stand
    while state['dealer_score'] < 17
      deal_card(state['dealer_hand'])
      update_scores
    end
    check_game_status
  end

  # rubocop:disable Metrics/MethodLength
  def check_game_status
    if state['player_score'] > 21
      state['status'] = 'player_bust'
    elsif state['dealer_score'] > 21
      state['status'] = 'dealer_bust'
    elsif state['dealer_score'] >= 17
      state['status'] = if state['player_score'] > state['dealer_score']
                          'player_wins'
                        elsif state['player_score'] < state['dealer_score']
                          'dealer_wins'
                        else
                          'push'
                        end
    end
    save
  end
  # rubocop:enable Metrics/MethodLength
end

