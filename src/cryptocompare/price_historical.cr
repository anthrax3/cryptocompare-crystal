require "http/client"
require "json"

module Cryptocompare
  module PriceHistorical
    API_URL = "https://min-api.cryptocompare.com/data/pricehistorical"

    # Finds the price of any cryptocurrency in any other currency that you need
    # at a given timestamp. The price comes from the daily info - so it would be
    # the price at the end of the day GMT based on the requested timestamp.  If
    # the crypto does not trade directly into the toSymbol requested, BTC will
    # be used for conversion. Tries to get direct trading pair data, if there is
    # none or it is more than 30 days before the ts requested, it uses BTC
    # conversion. If the opposite pair trades we invert it (eg.: BTC-XMR).
    #
    # ==== Parameters
    #
    # * +from_sym+  [String]           - (required) currency symbol (ex: "BTC", "ETH", "LTC", "USD", "EUR", "CNY")
    # * +to_syms+   [String, Array]    - (required) currency symbol(s)  (ex: "USD", "EUR", "CNY", "USD", "EUR", "CNY")
    # * +opts+      [Hash]             - (optional) options hash
    #
    # ==== Options
    #
    # * +ts+        [String, Integer]  - (optional) timestamp
    #
    # ==== Returns
    #
    # [Hash] Hash with currency prices
    #
    # ==== Examples
    #
    # Find historical price of cryptocurrency.
    #
    #   Cryptocompare::PriceHistorical.find("ETH", "USD")
    #   #=> {"ETH"=>{"USD"=>225.93}}
    #
    # Find historical price of cryptocurrency at a given timestamp.
    #
    #   Cryptocompare::PriceHistorical.find("ETH", "USD", {"ts" => 1452680400})
    #   #=> {"ETH"=>{"USD"=>223.2}}
    #
    # Find historical price of cryptocurrency in many currencies at a given timestamp.
    #
    #   Cryptocompare::PriceHistorical.find("ETH", ["BTC", "USD", "EUR"], {"ts" => "1452680400"})
    #   #=> {"ETH"=>{"BTC"=>0.08006, "USD"=>225.93, "EUR"=>194.24}}
    def self.find(from_sym, to_syms, opts = {} of String => String)
      params = Cryptocompare::QueryParamHelper.build_find_params(from_sym, to_syms).merge(opts)
      full_path = Cryptocompare::QueryParamHelper.set_query_params(API_URL, params)

      api_resp = HTTP::Client.get(full_path)
      JSON.parse(api_resp.body)
    end
  end
end
