require 'tcfg'

module TCFG
  module Helper
    def recursive_symbolize_keys(h)
      case h
      when Hash
        Hash[h.map do |k, v|
          [k.respond_to?(:to_sym) ? k.to_sym : k, recursive_symbolize_keys(v)]
        end]
      when Enumerable
        h.map { |v| recursive_symbolize_keys(v) }
      else
        h
      end
    end
  end
end

RSpec.configure do |config|
  config.include TCFG::Helper

  # config.before(:all) do
  #   debug "Executing tests with this configuration:\n#{tcfg.to_yaml}"
  # end
end
