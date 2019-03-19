require 'slack-ruby-bot'

class PokerStoveBot < SlackRubyBot::Bot
  operator '!ps' do |client, data, match|
    args = match['expression'].strip

    begin
      rout, wout = IO.pipe
      pid = Process.spawn('./calculator', *args.split(' '), out: wout)
      status = nil

      Timeout::timeout(5) do
        _, status = Process.wait2(pid)
      end

      wout.close
      stdout = rout.readlines.join("\n")
      rout.close

      client.say(channel: data.channel, text: stdout, thread_ts: data.thread_ts || data.ts)
    rescue Timeout::Error
      Process.kill('KILL', pid)
      rout.close
      wout.close
      client.say(channel: data.channel, text: "Timed out trying to evaluate #{args}", thread_ts: data.thread_ts || data.ts)
    end
  end
end
