require 'webrick/httpproxy'
require 'json'
require 'highline/import'
require 'webrick'
require 'cgi'

# A HttpWatch proxy clone (without the license!)
class CustomWEBrickProxyServer < WEBrick::HTTPProxyServer
  def do_PUT(req, res)
    perform_proxy_request(req, res) do |http, path, header|
      http.put(path, req.body || '', header)
    end
  end

  # This method is not needed for PUT but I added for completeness
  def do_OPTIONS(_req, res)
    res['allow'] = 'GET,HEAD,POST,OPTIONS,CONNECT,PUT'
  end
end

module ProxyHelper
  @proxy_port = 9998
  @host = 'demo.accelior'
  @responce = ''
  @request = ''
  $res_arry = []
  $req_arry = []

  # noinspection ALL
  class << self
    def init_proxy
      @server = CustomWEBrickProxyServer.new(
        Port: @proxy_port,
        AccessLog: [], # suppress standard messages
        ProxyContentHandler: proc do |req, res|
          unless req.request_uri.nil?
            if req.request_uri.host.include?(@host)

              short_resp = $req_arry[0].to_s.lines.first + $res_arry[0].to_s.lines.first
              debug short_resp.gsub("\r\n", ' ')

              loggers[:proxy_run].debug '>' * 75
              loggers[:proxy_run].debug req
              loggers[:proxy_run].debug '<' * 75
              loggers[:proxy_run].debug res
              loggers[:proxy_run].debug '=' * 75

              $res_arry << res
              $req_arry << req
            end
          end
        end

      )
      %w(TERM INT).each do |signal|
        trap(signal) { @server.shutdown }
      end
      @server
    end

    def start(srv)
      srv.start
    end

    def stop(srv)
      srv.stop
    end
  end
end
