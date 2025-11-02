# frozen_string_literal: true

require_relative '../../test_helper'

describe Massive::REST::Stocks do
	it "has a version number" do
		expect(Massive::REST::Stocks::VERSION).not.to be_nil
	end

	describe ".previous_close" do
		it "builds the correct URI without optional parameters" do
			uri = Massive::REST::Stocks.send(:build_uri, "/v2/aggs/ticker/AAPL/prev")
			expect(uri).to be == "/v2/aggs/ticker/AAPL/prev"
		end

		it "builds the correct URI with adjusted parameter" do
			uri = Massive::REST::Stocks.send(:build_uri, "/v2/aggs/ticker/AAPL/prev", adjusted: false)
			expect(uri).to be == "/v2/aggs/ticker/AAPL/prev?adjusted=false"
		end
	end

	describe ".aggregates" do
		it "builds the correct URI for daily aggregates" do
			path = "/v2/aggs/ticker/AAPL/range/1/day/2023-01-01/2023-01-31"
			uri = Massive::REST::Stocks.send(:build_uri, path)
			expect(uri).to be == path
		end

		it "builds the correct URI with all optional parameters" do
			path = "/v2/aggs/ticker/AAPL/range/5/minute/2023-01-09/2023-01-10"
			uri = Massive::REST::Stocks.send(:build_uri, path, adjusted: true, sort: 'asc', limit: 1000)
			expect(uri).to be == "#{path}?adjusted=true&sort=asc&limit=1000"
		end
	end

	describe ".last_quote" do
		it "builds the correct URI" do
			uri = "/v2/last/nbbo/AAPL"
			expect(uri).to be == "/v2/last/nbbo/AAPL"
		end
	end

	describe ".last_trade" do
		it "builds the correct URI" do
			uri = "/v2/last/trade/AAPL"
			expect(uri).to be == "/v2/last/trade/AAPL"
		end
	end

	describe ".sma" do
		it "builds the correct URI with indicator parameters" do
			path = "/v1/indicators/sma/AAPL"
			uri = Massive::REST::Stocks.send(:build_uri, path, window: 50, timespan: 'day', limit: 100)
			expect(uri).to be == "#{path}?window=50&timespan=day&limit=100"
		end

		it "filters out nil parameters" do
			path = "/v1/indicators/sma/AAPL"
			uri = Massive::REST::Stocks.send(:build_uri, path, window: 50, timespan: nil, limit: 100)
			expect(uri).to be == "#{path}?window=50&limit=100"
		end
	end

	describe ".ema" do
		it "builds the correct URI with window and timespan" do
			path = "/v1/indicators/ema/AAPL"
			uri = Massive::REST::Stocks.send(:build_uri, path, window: 20, timespan: 'day', limit: 50)
			expect(uri).to be == "#{path}?window=20&timespan=day&limit=50"
		end
	end

	describe ".rsi" do
		it "builds the correct URI with typical RSI parameters" do
			path = "/v1/indicators/rsi/AAPL"
			uri = Massive::REST::Stocks.send(:build_uri, path, window: 14, timespan: 'day')
			expect(uri).to be == "#{path}?window=14&timespan=day"
		end
	end

	describe ".macd" do
		it "builds the correct URI with MACD windows" do
			path = "/v1/indicators/macd/AAPL"
			uri = Massive::REST::Stocks.send(:build_uri, path,
				short_window: 12, long_window: 26, signal_window: 9, timespan: 'day')
			expect(uri).to be == "#{path}?short_window=12&long_window=26&signal_window=9&timespan=day"
		end
	end

	describe ".grouped_daily" do
		it "builds the correct URI for a date" do
			path = "/v2/aggs/grouped/locale/us/market/stocks/2023-01-09"
			uri = Massive::REST::Stocks.send(:build_uri, path)
			expect(uri).to be == path
		end

		it "builds the correct URI with adjusted and include_otc" do
			path = "/v2/aggs/grouped/locale/us/market/stocks/2023-01-09"
			uri = Massive::REST::Stocks.send(:build_uri, path, adjusted: true, include_otc: false)
			expect(uri).to be == "#{path}?adjusted=true&include_otc=false"
		end
	end

	describe ".snapshot_all" do
		it "builds the correct URI without parameters" do
			path = "/v2/snapshot/locale/us/markets/stocks/tickers"
			uri = Massive::REST::Stocks.send(:build_uri, path)
			expect(uri).to be == path
		end

		it "builds the correct URI with tickers filter" do
			path = "/v2/snapshot/locale/us/markets/stocks/tickers"
			uri = Massive::REST::Stocks.send(:build_uri, path, tickers: 'AAPL,MSFT,GOOGL')
			expect(uri).to be == "#{path}?tickers=AAPL%2CMSFT%2CGOOGL"
		end
	end

	describe ".snapshot" do
		it "builds the correct URI for a single ticker" do
			uri = "/v2/snapshot/locale/us/markets/stocks/tickers/AAPL"
			expect(uri).to be == "/v2/snapshot/locale/us/markets/stocks/tickers/AAPL"
		end
	end

	describe ".gainers" do
		it "builds the correct URI without parameters" do
			path = "/v2/snapshot/locale/us/markets/stocks/gainers"
			uri = Massive::REST::Stocks.send(:build_uri, path)
			expect(uri).to be == path
		end

		it "builds the correct URI with include_otc" do
			path = "/v2/snapshot/locale/us/markets/stocks/gainers"
			uri = Massive::REST::Stocks.send(:build_uri, path, include_otc: true)
			expect(uri).to be == "#{path}?include_otc=true"
		end
	end

	describe ".losers" do
		it "builds the correct URI without parameters" do
			path = "/v2/snapshot/locale/us/markets/stocks/losers"
			uri = Massive::REST::Stocks.send(:build_uri, path)
			expect(uri).to be == path
		end

		it "builds the correct URI with include_otc" do
			path = "/v2/snapshot/locale/us/markets/stocks/losers"
			uri = Massive::REST::Stocks.send(:build_uri, path, include_otc: true)
			expect(uri).to be == "#{path}?include_otc=true"
		end
	end

	describe ".open_close" do
		it "builds the correct URI for a date" do
			path = "/v1/open-close/AAPL/2023-01-09"
			uri = Massive::REST::Stocks.send(:build_uri, path)
			expect(uri).to be == path
		end

		it "builds the correct URI with adjusted parameter" do
			path = "/v1/open-close/AAPL/2023-01-09"
			uri = Massive::REST::Stocks.send(:build_uri, path, adjusted: false)
			expect(uri).to be == "#{path}?adjusted=false"
		end
	end

	describe ".quotes" do
		it "builds the correct URI with just ticker" do
			path = "/v3/quotes/AAPL"
			uri = Massive::REST::Stocks.send(:build_uri, path)
			expect(uri).to be == path
		end

		it "builds the correct URI with timestamp" do
			path = "/v3/quotes/AAPL"
			uri = Massive::REST::Stocks.send(:build_uri, path, timestamp: '2023-01-09')
			expect(uri).to be == "#{path}?timestamp=2023-01-09"
		end

		it "builds the correct URI with timestamp range parameters" do
			path = "/v3/quotes/AAPL"
			uri = Massive::REST::Stocks.send(:build_uri, path,
				"timestamp.gte": '2023-01-09',
				"timestamp.lt": '2023-01-10',
				order: 'asc',
				limit: 100)
			expect(uri).to be == "#{path}?timestamp.gte=2023-01-09&timestamp.lt=2023-01-10&order=asc&limit=100"
		end
	end

	describe ".trades" do
		it "builds the correct URI with just ticker" do
			path = "/v3/trades/AAPL"
			uri = Massive::REST::Stocks.send(:build_uri, path)
			expect(uri).to be == path
		end

		it "builds the correct URI with timestamp" do
			path = "/v3/trades/AAPL"
			uri = Massive::REST::Stocks.send(:build_uri, path, timestamp: '2023-01-09')
			expect(uri).to be == "#{path}?timestamp=2023-01-09"
		end

		it "builds the correct URI with all parameters" do
			path = "/v3/trades/AAPL"
			uri = Massive::REST::Stocks.send(:build_uri, path,
				"timestamp.gte": '2023-01-09',
				"timestamp.lte": '2023-01-10',
				order: 'desc',
				limit: 50,
				sort: 'timestamp')
			expect(uri).to be == "#{path}?timestamp.gte=2023-01-09&timestamp.lte=2023-01-10&order=desc&limit=50&sort=timestamp"
		end
	end

	describe ".splits" do
		it "builds the correct URI without parameters" do
			uri = Massive::REST::Stocks.send(:build_uri, "/stocks/v1/splits")
			expect(uri).to be == "/stocks/v1/splits"
		end

		it "builds the correct URI with ticker" do
			uri = Massive::REST::Stocks.send(:build_uri, "/stocks/v1/splits", ticker: 'AAPL')
			expect(uri).to be == "/stocks/v1/splits?ticker=AAPL"
		end

		it "builds the correct URI with execution_date range" do
			uri = Massive::REST::Stocks.send(:build_uri, "/stocks/v1/splits",
				ticker: 'AAPL',
				"execution_date.gte": '2020-01-01',
				"execution_date.lte": '2024-12-31')
			expect(uri).to be == "/stocks/v1/splits?ticker=AAPL&execution_date.gte=2020-01-01&execution_date.lte=2024-12-31"
		end

		it "builds the correct URI with adjustment_type" do
			uri = Massive::REST::Stocks.send(:build_uri, "/stocks/v1/splits",
				adjustment_type: 'forward_split')
			expect(uri).to be == "/stocks/v1/splits?adjustment_type=forward_split"
		end

		it "builds the correct URI with all parameters" do
			uri = Massive::REST::Stocks.send(:build_uri, "/stocks/v1/splits",
				ticker: 'AAPL',
				"ticker.any_of": 'AAPL,MSFT',
				execution_date: '2020-08-31',
				"execution_date.gte": '2020-01-01',
				"execution_date.gt": '2019-12-31',
				"execution_date.lte": '2024-12-31',
				"execution_date.lt": '2025-01-01',
				adjustment_type: 'forward_split',
				"adjustment_type.any_of": 'forward_split,reverse_split',
				limit: 100,
				sort: 'execution_date.desc')
			expect(uri).to be == "/stocks/v1/splits?ticker=AAPL&ticker.any_of=AAPL%2CMSFT&execution_date=2020-08-31&execution_date.gte=2020-01-01&execution_date.gt=2019-12-31&execution_date.lte=2024-12-31&execution_date.lt=2025-01-01&adjustment_type=forward_split&adjustment_type.any_of=forward_split%2Creverse_split&limit=100&sort=execution_date.desc"
		end

		it "filters out nil parameters" do
			uri = Massive::REST::Stocks.send(:build_uri, "/stocks/v1/splits",
				ticker: 'AAPL',
				adjustment_type: nil,
				limit: 50)
			expect(uri).to be == "/stocks/v1/splits?ticker=AAPL&limit=50"
		end
	end

	describe ".dividends" do
		it "builds the correct URI without parameters" do
			uri = Massive::REST::Stocks.send(:build_uri, "/stocks/v1/dividends")
			expect(uri).to be == "/stocks/v1/dividends"
		end

		it "builds the correct URI with ticker" do
			uri = Massive::REST::Stocks.send(:build_uri, "/stocks/v1/dividends", ticker: 'AAPL')
			expect(uri).to be == "/stocks/v1/dividends?ticker=AAPL"
		end

		it "builds the correct URI with ex_dividend_date range" do
			uri = Massive::REST::Stocks.send(:build_uri, "/stocks/v1/dividends",
				ticker: 'AAPL',
				"ex_dividend_date.gte": '2024-01-01',
				"ex_dividend_date.lte": '2024-12-31')
			expect(uri).to be == "/stocks/v1/dividends?ticker=AAPL&ex_dividend_date.gte=2024-01-01&ex_dividend_date.lte=2024-12-31"
		end

		it "builds the correct URI with frequency and distribution_type" do
			uri = Massive::REST::Stocks.send(:build_uri, "/stocks/v1/dividends",
				ticker: 'AAPL',
				frequency: 4,
				distribution_type: 'recurring')
			expect(uri).to be == "/stocks/v1/dividends?ticker=AAPL&frequency=4&distribution_type=recurring"
		end

		it "builds the correct URI with all parameters" do
			uri = Massive::REST::Stocks.send(:build_uri, "/stocks/v1/dividends",
				ticker: 'AAPL',
				"ticker.any_of": 'AAPL,MSFT',
				ex_dividend_date: '2024-08-12',
				"ex_dividend_date.gte": '2024-01-01',
				"ex_dividend_date.gt": '2023-12-31',
				"ex_dividend_date.lte": '2024-12-31',
				"ex_dividend_date.lt": '2025-01-01',
				frequency: 4,
				distribution_type: 'recurring',
				"distribution_type.any_of": 'recurring,special',
				limit: 100,
				sort: 'ex_dividend_date.desc')
			expect(uri).to be == "/stocks/v1/dividends?ticker=AAPL&ticker.any_of=AAPL%2CMSFT&ex_dividend_date=2024-08-12&ex_dividend_date.gte=2024-01-01&ex_dividend_date.gt=2023-12-31&ex_dividend_date.lte=2024-12-31&ex_dividend_date.lt=2025-01-01&frequency=4&distribution_type=recurring&distribution_type.any_of=recurring%2Cspecial&limit=100&sort=ex_dividend_date.desc"
		end

		it "filters out nil parameters" do
			uri = Massive::REST::Stocks.send(:build_uri, "/stocks/v1/dividends",
				ticker: 'AAPL',
				frequency: nil,
				distribution_type: nil,
				limit: 50)
			expect(uri).to be == "/stocks/v1/dividends?ticker=AAPL&limit=50"
		end
	end

	describe ".build_uri (private method)" do
		it "builds URI without query params when none provided" do
			uri = Massive::REST::Stocks.send(:build_uri, "/test/path")
			expect(uri).to be == "/test/path"
		end

		it "builds URI with single query param" do
			uri = Massive::REST::Stocks.send(:build_uri, "/test/path", foo: 'bar')
			expect(uri).to be == "/test/path?foo=bar"
		end

		it "builds URI with multiple query params" do
			uri = Massive::REST::Stocks.send(:build_uri, "/test/path", foo: 'bar', baz: 123, qux: true)
			expect(uri).to be == "/test/path?foo=bar&baz=123&qux=true"
		end

		it "filters out nil values from query params" do
			uri = Massive::REST::Stocks.send(:build_uri, "/test/path", foo: 'bar', baz: nil, qux: 123)
			expect(uri).to be == "/test/path?foo=bar&qux=123"
		end

		it "handles no params" do
			uri = Massive::REST::Stocks.send(:build_uri, "/test/path")
			expect(uri).to be == "/test/path"
		end

		it "URL encodes query parameter values" do
			uri = Massive::REST::Stocks.send(:build_uri, "/test/path", tickers: 'AAPL,MSFT')
			expect(uri).to be == "/test/path?tickers=AAPL%2CMSFT"
		end
	end
end
