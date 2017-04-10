require 'coinbase/wallet'
require 'cryptoprom/prometheus'

module CryptoProm
  def self.coinbase
    @coinbase ||= Coinbase.new
  end

  class Coinbase
    def client
      @client ||= ::Coinbase::Wallet::Client.new(
        api_key: ENV.fetch('COINBASE_API_KEY'),
        api_secret: ENV.fetch('COINBASE_API_SECRET')
      )
    end

    def fetch_rates
      self.class.metrics.increment

      client.exchange_rates.fetch('rates').inject({}) do |rates, (name, rate)|
        rates[name] = 1 / Float(rate)
        rates
      end
    end

    def self.metrics
      @metrics ||= prometheus.counter(
        :cryptoprom_coinbase_api_requests_total,
        'Total number of requests to the Coinbase API'
      )
    end

    def self.prometheus
      @prometheus ||= Prometheus.client
    end
  end
end
