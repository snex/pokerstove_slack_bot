require_relative 'poker_stove_bot'

SlackRubyBot.configure do |config|
  config.allow_message_loops = true
end

PokerStoveBot.run
