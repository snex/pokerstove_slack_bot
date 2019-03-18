require_relative 'spec_helper'
require_relative '../poker_stove_bot'

RSpec.describe PokerStoveBot do
  subject do
    PokerStoveBot.instance
  end

  it_behaves_like 'a slack ruby bot'

  it 'works' do
    expect(Process).to receive(:spawn).and_wrap_original do |m, cmd, *args|
      m.call('echo', *args)
    end
    expect(message: '!ps hello world').to respond_with_slack_message("hello world\n")
  end
end
