require 'slack-ruby-bot'

class PokerStoveBot < SlackRubyBot::Bot
  operator '!ps' do |client, data, match|
    args = match['expression']
    begin
      rout, wout = IO.pipe
      pid = Process.spawn('ps-eval', *args.split(' '), out: wout)
      status = nil

      Timeout::timeout(5) do
        _, status = Process.wait2(pid)
      end

      wout.close
      stdout = rout.readlines.join("\n")
      rout.close
      ex_status = status.exitstatus

      if ex_status == 0
        client.say(channel: data.channel, text: stdout, thread_ts: data.thread_ts || data.ts)
      else
        client.say(channel: data.channel, text: "Invalid format '#{match['expression']}'", thread_ts: data.thread_ts || data.ts)
      end
    rescue Timeout::Error
      Process.kill('KILL', pid)
      rout.close
      wout.close
      client.say(channel: data.channel, text: "Timed out trying to evaluate #{match['expression']}", thread_ts: data.thread_ts || data.ts)
    end
  end
end
