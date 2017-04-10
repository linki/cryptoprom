require 'rack'
require 'prometheus/middleware/collector'
require 'prometheus/middleware/exporter'

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'cryptoprom'

CryptoProm.run_async

use Rack::Deflater, if: ->(_, _, _, body) { body.any? && body[0].length > 512 }
use Prometheus::Middleware::Collector
use Prometheus::Middleware::Exporter

run ->(_) { [200, {'Content-Type' => 'text/html'}, ['OK']] }
