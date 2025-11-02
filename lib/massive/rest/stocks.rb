require_relative "stocks/version"
require 'massive/rest'
require 'uri'

module Massive
  module REST
    module Stocks
      class Error < StandardError; end

      # Get the previous day's OHLC for a stock ticker
      #
      # @param ticker [String] Stock ticker symbol (e.g., 'AAPL')
      # @param adjusted [Boolean, nil] Whether results are adjusted for splits (default: true)
      # @return [Hash] Previous day's bar data
      #
      # @example
      #   Massive::REST::Stocks.previous_close('AAPL')
      #   # => { "ticker" => "AAPL", "results" => [{ "o" => 115.55, "h" => 117.59, ... }], ... }
      def self.previous_close(ticker, adjusted: nil)
        uri = build_uri("/v2/aggs/ticker/#{ticker}/prev", adjusted: adjusted)
        Massive::REST.client.get_json(uri)
      end

      # Get aggregate bars for a stock over a date range
      #
      # @param ticker [String] Stock ticker symbol (e.g., 'AAPL')
      # @param multiplier [Integer] Size of the timespan multiplier
      # @param timespan [String] Size of the time window ('second', 'minute', 'hour', 'day', 'week', 'month', 'quarter', 'year')
      # @param from [String] Start of the aggregate time window (YYYY-MM-DD or millisecond timestamp)
      # @param to [String] End of the aggregate time window (YYYY-MM-DD or millisecond timestamp)
      # @param adjusted [Boolean, nil] Whether results are adjusted for splits (default: true)
      # @param sort [String, nil] Sort order ('asc' or 'desc')
      # @param limit [Integer, nil] Limit number of base aggregates (max 50000, default 5000)
      # @return [Hash] Aggregate bars data
      #
      # @example Get daily bars for a month
      #   Massive::REST::Stocks.aggregates('AAPL', 1, 'day', '2023-01-01', '2023-01-31')
      #
      # @example Get 5-minute bars
      #   Massive::REST::Stocks.aggregates('AAPL', 5, 'minute', '2023-01-09', '2023-01-10', sort: 'asc', limit: 1000)
      def self.aggregates(ticker, multiplier, timespan, from, to, adjusted: nil, sort: nil, limit: nil)
        uri = build_uri(
          "/v2/aggs/ticker/#{ticker}/range/#{multiplier}/#{timespan}/#{from}/#{to}",
          adjusted: adjusted,
          sort: sort,
          limit: limit
        )
        Massive::REST.client.get_json(uri)
      end

      # Get the most recent NBBO (National Best Bid and Offer) for a stock
      #
      # @param ticker [String] Stock ticker symbol (e.g., 'AAPL')
      # @return [Hash] Last NBBO quote data
      #
      # @example
      #   Massive::REST::Stocks.last_quote('AAPL')
      def self.last_quote(ticker)
        Massive::REST.client.get_json("/v2/last/nbbo/#{ticker}")
      end

      # Get the most recent trade for a stock
      #
      # @param ticker [String] Stock ticker symbol (e.g., 'AAPL')
      # @return [Hash] Last trade data
      #
      # @example
      #   Massive::REST::Stocks.last_trade('AAPL')
      def self.last_trade(ticker)
        Massive::REST.client.get_json("/v2/last/trade/#{ticker}")
      end

      # Get Simple Moving Average (SMA) indicator
      #
      # @param ticker [String] Stock ticker symbol (e.g., 'AAPL')
      # @param timestamp [String, Integer, nil] Query by timestamp (YYYY-MM-DD or millisecond timestamp)
      # @param timespan [String, nil] Size of the aggregate time window ('day', 'week', 'month', etc.)
      # @param adjusted [Boolean, nil] Whether results are adjusted for splits
      # @param window [Integer, nil] Window size for SMA calculation
      # @param series_type [String, nil] Price type to use ('close', 'open', 'high', 'low')
      # @param expand_underlying [Boolean, nil] Whether to include underlying aggregates
      # @param order [String, nil] Sort order ('asc' or 'desc')
      # @param limit [Integer, nil] Limit number of results (default 10, max 5000)
      # @return [Hash] SMA indicator data
      #
      # @example
      #   Massive::REST::Stocks.sma('AAPL', window: 50, timespan: 'day', limit: 100)
      def self.sma(ticker, timestamp: nil, timespan: nil, adjusted: nil, window: nil, series_type: nil, expand_underlying: nil, order: nil, limit: nil)
        uri = build_uri(
          "/v1/indicators/sma/#{ticker}",
          timestamp: timestamp,
          timespan: timespan,
          adjusted: adjusted,
          window: window,
          series_type: series_type,
          expand_underlying: expand_underlying,
          order: order,
          limit: limit
        )
        Massive::REST.client.get_json(uri)
      end

      # Get Exponential Moving Average (EMA) indicator
      #
      # @param ticker [String] Stock ticker symbol (e.g., 'AAPL')
      # @param timestamp [String, Integer, nil] Query by timestamp (YYYY-MM-DD or millisecond timestamp)
      # @param timespan [String, nil] Size of the aggregate time window
      # @param adjusted [Boolean, nil] Whether results are adjusted for splits
      # @param window [Integer, nil] Window size for EMA calculation
      # @param series_type [String, nil] Price type to use ('close', 'open', 'high', 'low')
      # @param expand_underlying [Boolean, nil] Whether to include underlying aggregates
      # @param order [String, nil] Sort order ('asc' or 'desc')
      # @param limit [Integer, nil] Limit number of results
      # @return [Hash] EMA indicator data
      #
      # @example
      #   Massive::REST::Stocks.ema('AAPL', window: 20, timespan: 'day', limit: 50)
      def self.ema(ticker, timestamp: nil, timespan: nil, adjusted: nil, window: nil, series_type: nil, expand_underlying: nil, order: nil, limit: nil)
        uri = build_uri(
          "/v1/indicators/ema/#{ticker}",
          timestamp: timestamp,
          timespan: timespan,
          adjusted: adjusted,
          window: window,
          series_type: series_type,
          expand_underlying: expand_underlying,
          order: order,
          limit: limit
        )
        Massive::REST.client.get_json(uri)
      end

      # Get Relative Strength Index (RSI) indicator
      #
      # @param ticker [String] Stock ticker symbol (e.g., 'AAPL')
      # @param timestamp [String, Integer, nil] Query by timestamp
      # @param timespan [String, nil] Size of the aggregate time window
      # @param adjusted [Boolean, nil] Whether results are adjusted for splits
      # @param window [Integer, nil] Window size for RSI calculation (typically 14)
      # @param series_type [String, nil] Price type to use
      # @param expand_underlying [Boolean, nil] Whether to include underlying aggregates
      # @param order [String, nil] Sort order
      # @param limit [Integer, nil] Limit number of results
      # @return [Hash] RSI indicator data
      #
      # @example
      #   Massive::REST::Stocks.rsi('AAPL', window: 14, timespan: 'day')
      def self.rsi(ticker, timestamp: nil, timespan: nil, adjusted: nil, window: nil, series_type: nil, expand_underlying: nil, order: nil, limit: nil)
        uri = build_uri(
          "/v1/indicators/rsi/#{ticker}",
          timestamp: timestamp,
          timespan: timespan,
          adjusted: adjusted,
          window: window,
          series_type: series_type,
          expand_underlying: expand_underlying,
          order: order,
          limit: limit
        )
        Massive::REST.client.get_json(uri)
      end

      # Get Moving Average Convergence Divergence (MACD) indicator
      #
      # @param ticker [String] Stock ticker symbol (e.g., 'AAPL')
      # @param timestamp [String, Integer, nil] Query by timestamp
      # @param timespan [String, nil] Size of the aggregate time window
      # @param adjusted [Boolean, nil] Whether results are adjusted for splits
      # @param short_window [Integer, nil] Short window size for MACD (typically 12)
      # @param long_window [Integer, nil] Long window size for MACD (typically 26)
      # @param signal_window [Integer, nil] Signal window size (typically 9)
      # @param series_type [String, nil] Price type to use
      # @param expand_underlying [Boolean, nil] Whether to include underlying aggregates
      # @param order [String, nil] Sort order
      # @param limit [Integer, nil] Limit number of results
      # @return [Hash] MACD indicator data
      #
      # @example
      #   Massive::REST::Stocks.macd('AAPL', short_window: 12, long_window: 26, signal_window: 9, timespan: 'day')
      def self.macd(ticker, timestamp: nil, timespan: nil, adjusted: nil, short_window: nil, long_window: nil, signal_window: nil, series_type: nil, expand_underlying: nil, order: nil, limit: nil)
        uri = build_uri(
          "/v1/indicators/macd/#{ticker}",
          timestamp: timestamp,
          timespan: timespan,
          adjusted: adjusted,
          short_window: short_window,
          long_window: long_window,
          signal_window: signal_window,
          series_type: series_type,
          expand_underlying: expand_underlying,
          order: order,
          limit: limit
        )
        Massive::REST.client.get_json(uri)
      end

      # Get grouped daily bars for all stocks on a specific date
      #
      # @param date [String] Date in YYYY-MM-DD format
      # @param adjusted [Boolean, nil] Whether results are adjusted for splits
      # @param include_otc [Boolean, nil] Include OTC securities
      # @return [Hash] Grouped daily bars for all stocks
      #
      # @example
      #   Massive::REST::Stocks.grouped_daily('2023-01-09')
      def self.grouped_daily(date, adjusted: nil, include_otc: nil)
        uri = build_uri(
          "/v2/aggs/grouped/locale/us/market/stocks/#{date}",
          adjusted: adjusted,
          include_otc: include_otc
        )
        Massive::REST.client.get_json(uri)
      end

      # Get snapshot of all tickers
      #
      # @param tickers [String, nil] Comma-separated list of tickers to filter by
      # @param include_otc [Boolean, nil] Include OTC securities
      # @return [Hash] Current snapshot of all tickers
      #
      # @example Get snapshot of specific tickers
      #   Massive::REST::Stocks.snapshot_all(tickers: 'AAPL,MSFT,GOOGL')
      #
      # @example Get snapshot of all tickers
      #   Massive::REST::Stocks.snapshot_all
      def self.snapshot_all(tickers: nil, include_otc: nil)
        uri = build_uri(
          "/v2/snapshot/locale/us/markets/stocks/tickers",
          tickers: tickers,
          include_otc: include_otc
        )
        Massive::REST.client.get_json(uri)
      end

      # Get snapshot of a single ticker
      #
      # @param ticker [String] Stock ticker symbol
      # @return [Hash] Current snapshot for the ticker
      #
      # @example
      #   Massive::REST::Stocks.snapshot('AAPL')
      def self.snapshot(ticker)
        Massive::REST.client.get_json("/v2/snapshot/locale/us/markets/stocks/tickers/#{ticker}")
      end

      # Get top 20 gainers for the day
      #
      # Top gainers are tickers whose price has increased by the highest
      # percentage since the previous day's close. Only includes tickers
      # with trading volume of 10,000 or more.
      #
      # @param include_otc [Boolean, nil] Include OTC securities (default: false)
      # @return [Hash] Top gainers snapshot data
      #
      # @example
      #   Massive::REST::Stocks.gainers
      #   Massive::REST::Stocks.gainers(include_otc: true)
      def self.gainers(include_otc: nil)
        uri = build_uri("/v2/snapshot/locale/us/markets/stocks/gainers", include_otc: include_otc)
        Massive::REST.client.get_json(uri)
      end

      # Get top 20 losers for the day
      #
      # Top losers are tickers whose price has decreased by the highest
      # percentage since the previous day's close. Only includes tickers
      # with trading volume of 10,000 or more.
      #
      # @param include_otc [Boolean, nil] Include OTC securities (default: false)
      # @return [Hash] Top losers snapshot data
      #
      # @example
      #   Massive::REST::Stocks.losers
      #   Massive::REST::Stocks.losers(include_otc: true)
      def self.losers(include_otc: nil)
        uri = build_uri("/v2/snapshot/locale/us/markets/stocks/losers", include_otc: include_otc)
        Massive::REST.client.get_json(uri)
      end

      # Get open and close prices for a stock on a specific date
      #
      # @param ticker [String] Stock ticker symbol
      # @param date [String] Date in YYYY-MM-DD format
      # @param adjusted [Boolean, nil] Whether results are adjusted for splits
      # @return [Hash] Open and close prices for the date
      #
      # @example
      #   Massive::REST::Stocks.open_close('AAPL', '2023-01-09')
      def self.open_close(ticker, date, adjusted: nil)
        uri = build_uri("/v1/open-close/#{ticker}/#{date}", adjusted: adjusted)
        Massive::REST.client.get_json(uri)
      end

      # Get NBBO quotes for a stock in a given time range
      #
      # @param ticker [String] Stock ticker symbol
      # @param timestamp [String, nil] Query by timestamp (YYYY-MM-DD or nanosecond timestamp)
      # @param timestamp_gte [String, nil] Timestamp greater than or equal to
      # @param timestamp_gt [String, nil] Timestamp greater than
      # @param timestamp_lte [String, nil] Timestamp less than or equal to
      # @param timestamp_lt [String, nil] Timestamp less than
      # @param order [String, nil] Order results ('asc' or 'desc', default 'desc')
      # @param limit [Integer, nil] Limit results (default 1000, max 50000)
      # @param sort [String, nil] Sort field (default 'timestamp')
      # @return [Hash] Quote data with results array
      #
      # @example Get quotes for a specific date
      #   Massive::REST::Stocks.quotes('AAPL', timestamp: '2023-01-09')
      #
      # @example Get quotes in a time range
      #   Massive::REST::Stocks.quotes('AAPL', timestamp_gte: '2023-01-09', timestamp_lt: '2023-01-10', order: 'asc')
      def self.quotes(ticker, timestamp: nil, timestamp_gte: nil, timestamp_gt: nil, timestamp_lte: nil, timestamp_lt: nil, order: nil, limit: nil, sort: nil)
        uri = build_uri(
          "/v3/quotes/#{ticker}",
          timestamp: timestamp,
          "timestamp.gte": timestamp_gte,
          "timestamp.gt": timestamp_gt,
          "timestamp.lte": timestamp_lte,
          "timestamp.lt": timestamp_lt,
          order: order,
          limit: limit,
          sort: sort,
        )
        Massive::REST.client.get_json(uri)
      end

      # Get trades for a stock in a given time range
      #
      # @param ticker [String] Stock ticker symbol
      # @param timestamp [String, nil] Query by timestamp (YYYY-MM-DD or nanosecond timestamp)
      # @param timestamp_gte [String, nil] Timestamp greater than or equal to
      # @param timestamp_gt [String, nil] Timestamp greater than
      # @param timestamp_lte [String, nil] Timestamp less than or equal to
      # @param timestamp_lt [String, nil] Timestamp less than
      # @param order [String, nil] Order results ('asc' or 'desc', default 'desc')
      # @param limit [Integer, nil] Limit results (default 1000, max 50000)
      # @param sort [String, nil] Sort field (default 'timestamp')
      # @return [Hash] Trade data with results array
      #
      # @example Get trades for a specific date
      #   Massive::REST::Stocks.trades('AAPL', timestamp: '2023-01-09')
      #
      # @example Get trades in a time range
      #   Massive::REST::Stocks.trades('AAPL', timestamp_gte: '2023-01-09', timestamp_lt: '2023-01-10', order: 'asc', limit: 100)
      def self.trades(ticker, timestamp: nil, timestamp_gte: nil, timestamp_gt: nil, timestamp_lte: nil, timestamp_lt: nil, order: nil, limit: nil, sort: nil)
        uri = build_uri(
          "/v3/trades/#{ticker}",
          timestamp: timestamp,
          "timestamp.gte": timestamp_gte,
          "timestamp.gt": timestamp_gt,
          "timestamp.lte": timestamp_lte,
          "timestamp.lt": timestamp_lt,
          order: order,
          limit: limit,
          sort: sort,
        )
        Massive::REST.client.get_json(uri)
      end

      # Get historical stock split events
      #
      # @param ticker [String, nil] Filter by ticker symbol
      # @param ticker_any_of [String, nil] Comma-separated ticker symbols
      # @param execution_date [String, nil] Filter by execution date (YYYY-MM-DD)
      # @param execution_date_gte [String, nil] Execution date greater than or equal to
      # @param execution_date_gt [String, nil] Execution date greater than
      # @param execution_date_lte [String, nil] Execution date less than or equal to
      # @param execution_date_lt [String, nil] Execution date less than
      # @param adjustment_type [String, nil] Filter by type ('forward_split', 'reverse_split', 'stock_dividend')
      # @param adjustment_type_any_of [String, nil] Comma-separated adjustment types
      # @param limit [Integer, nil] Limit number of results (default: 100, max: 5000)
      # @param sort [String, nil] Sort columns with direction (e.g., 'execution_date.desc')
      # @return [Hash] Split events with request_id, status, next_url, and results
      #
      # @example Get all AAPL splits
      #   Massive::REST::Stocks.splits(ticker: 'AAPL')
      #
      # @example Get forward splits in a date range
      #   Massive::REST::Stocks.splits(adjustment_type: 'forward_split', execution_date_gte: '2020-01-01')
      def self.splits(ticker: nil, ticker_any_of: nil, execution_date: nil, execution_date_gte: nil, execution_date_gt: nil, execution_date_lte: nil, execution_date_lt: nil, adjustment_type: nil, adjustment_type_any_of: nil, limit: nil, sort: nil)
        uri = build_uri(
          "/stocks/v1/splits",
          ticker: ticker,
          "ticker.any_of": ticker_any_of,
          execution_date: execution_date,
          "execution_date.gte": execution_date_gte,
          "execution_date.gt": execution_date_gt,
          "execution_date.lte": execution_date_lte,
          "execution_date.lt": execution_date_lt,
          adjustment_type: adjustment_type,
          "adjustment_type.any_of": adjustment_type_any_of,
          limit: limit,
          sort: sort,
        )
        Massive::REST.client.get_json(uri)
      end

      # Get historical cash dividend distributions
      #
      # @param ticker [String, nil] Filter by ticker symbol
      # @param ticker_any_of [String, nil] Comma-separated ticker symbols
      # @param ex_dividend_date [String, nil] Filter by ex-dividend date (YYYY-MM-DD)
      # @param ex_dividend_date_gte [String, nil] Ex-dividend date greater than or equal to
      # @param ex_dividend_date_gt [String, nil] Ex-dividend date greater than
      # @param ex_dividend_date_lte [String, nil] Ex-dividend date less than or equal to
      # @param ex_dividend_date_lt [String, nil] Ex-dividend date less than
      # @param frequency [Integer, nil] Annual payout frequency (0=non-recurring, 1=annual, 4=quarterly, 12=monthly)
      # @param distribution_type [String, nil] Filter by type ('recurring', 'special', 'supplemental', 'irregular', 'unknown')
      # @param distribution_type_any_of [String, nil] Comma-separated distribution types
      # @param limit [Integer, nil] Limit number of results (default: 100, max: 5000)
      # @param sort [String, nil] Sort columns with direction (e.g., 'ex_dividend_date.desc')
      # @return [Hash] Dividend records with request_id, status, next_url, and results
      #
      # @example Get all AAPL dividends
      #   Massive::REST::Stocks.dividends(ticker: 'AAPL')
      #
      # @example Get quarterly dividends in a date range
      #   Massive::REST::Stocks.dividends(ticker: 'AAPL', frequency: 4, ex_dividend_date_gte: '2024-01-01')
      def self.dividends(ticker: nil, ticker_any_of: nil, ex_dividend_date: nil, ex_dividend_date_gte: nil, ex_dividend_date_gt: nil, ex_dividend_date_lte: nil, ex_dividend_date_lt: nil, frequency: nil, distribution_type: nil, distribution_type_any_of: nil, limit: nil, sort: nil)
        uri = build_uri(
          "/stocks/v1/dividends",
          ticker: ticker,
          "ticker.any_of": ticker_any_of,
          ex_dividend_date: ex_dividend_date,
          "ex_dividend_date.gte": ex_dividend_date_gte,
          "ex_dividend_date.gt": ex_dividend_date_gt,
          "ex_dividend_date.lte": ex_dividend_date_lte,
          "ex_dividend_date.lt": ex_dividend_date_lt,
          frequency: frequency,
          distribution_type: distribution_type,
          "distribution_type.any_of": distribution_type_any_of,
          limit: limit,
          sort: sort,
        )
        Massive::REST.client.get_json(uri)
      end

      # Build a URI with query parameters, filtering out nil values
      #
      # @param path [String] The base path
      # @param params [Hash] Query parameters
      # @return [String] Full request URI with query string
      # @api private
      def self.build_uri(path, **params)
        # Filter out nil values
        query_params = params.compact

        if query_params.empty?
          path
        else
          # Build query string
          query = URI.encode_www_form(query_params)
          "#{path}?#{query}"
        end
      end
    end
  end
end
