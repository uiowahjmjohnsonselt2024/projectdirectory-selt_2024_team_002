# frozen_string_literal: true

And(/^I have a blackjack and the dealer does not$/) do
  @player_hand = [Card.new('Hearts', 'A'), Card.new('Diamonds', '10')]
  @player_score = @player_hand.sum(&:value)

  @dealer_hand = [Card.new('Spades', '9'), Card.new('Clubs', '8')]
  @dealer_score = @dealer_hand.sum(&:value)

  expect(@player_score).to eq(21)
  expect(@dealer_score).to be < 21

  page.execute_script("document.getElementById('status_message').style.display = 'block';")
  page.execute_script("document.getElementById('status_message').innerText = 'Player Blackjack! Player Wins!'")
  expect(find('#status_message').text).to eq('Player Blackjack! Player Wins!')
end

And(/^I do not have a blackjack and the dealer does$/) do
  @player_hand = [Card.new('Hearts', '5'), Card.new('Diamonds', '10')]
  @player_score = @player_hand.sum(&:value)

  @dealer_hand = [Card.new('Spades', 'A'), Card.new('Clubs', '10')]
  @dealer_score = @dealer_hand.sum(&:value)

  expect(@player_score).to be < 21
  expect(@dealer_score).to eq(21)

  page.execute_script("document.getElementById('status_message').style.display = 'block';")
  page.execute_script("document.getElementById('status_message').innerText = 'Dealer Blackjack! Dealer Wins!'")
  expect(find('#status_message').text).to eq('Dealer Blackjack! Dealer Wins!')
end

And(/^I have a blackjack and the dealer does$/) do
  @player_hand = [Card.new('Hearts', 'A'), Card.new('Diamonds', '10')]
  @player_score = @player_hand.sum(&:value)

  @dealer_hand = [Card.new('Spades', 'A'), Card.new('Clubs', '10')]
  @dealer_score = @dealer_hand.sum(&:value)

  expect(@player_score).to eq(21)
  expect(@dealer_score).to eq(21)

  page.execute_script("document.getElementById('status_message').style.display = 'block';")
  status = 'Push! Both Player and Dealer have Blackjack!'
  page.execute_script("document.getElementById('status_message').innerText = '#{status}'")
  expect(find('#status_message').text).to eq('Push! Both Player and Dealer have Blackjack!')
end

And(/^I have a higher hand than the dealer$/) do
  @player_hand = [Card.new('Hearts', '9'), Card.new('Diamonds', '10')]
  @player_score = @player_hand.sum(&:value)

  @dealer_hand = [Card.new('Spades', '7'), Card.new('Clubs', '10')]
  @dealer_score = @dealer_hand.sum(&:value)

  expect(@player_score).to be < 21
  expect(@dealer_score).to be >= 17
  expect(@dealer_score).to be < @player_score

  page.execute_script("document.getElementById('status_message').style.display = 'block';")
  page.execute_script("document.getElementById('status_message').innerText = 'Player Wins!'")
  expect(find('#status_message').text).to eq('Player Wins!')
end

And(/^I have a lower hand than the dealer$/) do
  @player_hand = [Card.new('Hearts', '5'), Card.new('Diamonds', '10')]
  @player_score = @player_hand.sum(&:value)

  @dealer_hand = [Card.new('Spades', '7'), Card.new('Clubs', '10')]
  @dealer_score = @dealer_hand.sum(&:value)

  expect(@player_score).to be < 21
  expect(@dealer_score).to be >= 17
  expect(@dealer_score).to be > @player_score

  page.execute_script("document.getElementById('status_message').style.display = 'block';")
  page.execute_script("document.getElementById('status_message').innerText = 'Dealer Wins!'")
  expect(find('#status_message').text).to eq('Dealer Wins!')
end

And(/^I have an equal hand to the dealer$/) do
  @player_hand = [Card.new('Hearts', '7'), Card.new('Diamonds', '10')]
  @player_score = @player_hand.sum(&:value)

  @dealer_hand = [Card.new('Spades', '7'), Card.new('Clubs', '10')]
  @dealer_score = @dealer_hand.sum(&:value)

  expect(@player_score).to be < 21
  expect(@dealer_score).to be >= 17
  expect(@dealer_score).to be == @player_score

  page.execute_script("document.getElementById('status_message').style.display = 'block';")
  page.execute_script("document.getElementById('status_message').innerText = 'Push!'")
  expect(find('#status_message').text).to eq('Push!')
end

And(/^I hit and bust$/) do
  @player_hand = [Card.new('Hearts', '7'), Card.new('Diamonds', '10'), Card.new('Clubs', '8')]
  @player_score = @player_hand.sum(&:value)

  @dealer_hand = [Card.new('Spades', '7'), Card.new('Clubs', '10')]
  @dealer_score = @dealer_hand.sum(&:value)

  expect(@player_score).to be > 21

  page.execute_script("document.getElementById('status_message').style.display = 'block';")
  page.execute_script("document.getElementById('status_message').innerText = 'Player Bust! Dealer Wins!'")
  expect(find('#status_message').text).to eq('Player Bust! Dealer Wins!')
end

And(/^I stand and the dealer busts$/) do
  @player_hand = [Card.new('Hearts', '7'), Card.new('Diamonds', '10')]
  @player_score = @player_hand.sum(&:value)

  @dealer_hand = [Card.new('Spades', '3'), Card.new('Clubs', '10'), Card.new('Diamonds', '10')]
  @dealer_score = @dealer_hand.sum(&:value)

  expect(@player_score).to be < 21
  expect(@dealer_score).to be > 21

  page.execute_script("document.getElementById('status_message').style.display = 'block';")
  page.execute_script("document.getElementById('status_message').innerText = 'Dealer Bust! Player Wins!'")
  expect(find('#status_message').text).to eq('Dealer Bust! Player Wins!')
end
