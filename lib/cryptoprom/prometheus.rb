require 'prometheus/client'

module CryptoProm
  def self.prometheus
    @prometheus ||= Prometheus.new
  end

  class Prometheus
    def collect_rates(rates)
      rates.each do |name, price|
        self.class.metrics.set({ currency: name, 'denominator': 'USD' }, price)
      end
    end

    def self.metrics
      @metrics ||= client.gauge(
        :cryptoprom_cryptocurrency_rates, 'Current exchange rates in USD'
      )
    end

    def self.client
      @client ||= ::Prometheus::Client.registry
    end
  end
end
