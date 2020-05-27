require_relative 'poker_stove_bot'

begin
  PokerStoveBot.run
rescue OpenSSL::SSL::SSLError
  PokerStoveBot.run
end
