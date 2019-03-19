require_relative 'spec_helper'
require_relative '../poker_stove_bot'

RSpec.describe PokerStoveBot do
  subject do
    PokerStoveBot.instance
  end

  it_behaves_like 'a slack ruby bot'

  context 'no timeout' do
    it 'says the STDOUT of the calculator process' do
      expect(Process).to receive(:spawn).and_wrap_original do |m, cmd, *args|
        m.call('echo', *args)
      end
      expect(message: '!ps hello world').to respond_with_slack_message("hello world\n")
    end
  end

  context 'timeout' do
    it 'gives a timeout message' do
      expect(Process).to receive(:wait2).and_raise(Timeout::Error)
      expect(message: '!ps hello world').to respond_with_slack_message("Timed out trying to evaluate hello world")
    end
  end
end
