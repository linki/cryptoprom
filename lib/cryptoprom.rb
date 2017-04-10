require 'concurrent'
require 'cryptoprom/coinbase'
require 'cryptoprom/prometheus'

module CryptoProm
  def self.run_async
    Concurrent::TimerTask.new(run_now: true) { run_once }.execute
  end

  def self.run_once
    prometheus.collect_rates coinbase.fetch_rates
  end
end
