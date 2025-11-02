# Massive::REST::Stocks

A Ruby client for accessing stock market data from Massive.com's REST API. This gem provides convenient module methods for retrieving aggregates, quotes, trades, technical indicators, and market snapshots.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'massive-rest-stocks'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install massive-rest-stocks
```

## Prerequisites

This gem depends on `massive-rest` which handles authentication and rate limiting. You'll need:

1. A Massive.com account with API access
2. Valid API credentials configured (see [massive-rest documentation](https://github.com/vadrigar/massive-rest))

## Usage

All methods are module methods on `Massive::REST::Stocks`:

### Market Data

Get previous day's OHLC data:
```ruby
Massive::REST::Stocks.previous_close('AAPL')
# => { "ticker" => "AAPL", "results" => [{ "o" => 115.55, "h" => 117.59, ... }], ... }
```

Get aggregate bars over a date range:
```ruby
# Daily bars for a month
Massive::REST::Stocks.aggregates('AAPL', 1, 'day', '2023-01-01', '2023-01-31')

# 5-minute bars
Massive::REST::Stocks.aggregates('AAPL', 5, 'minute', '2023-01-09', '2023-01-10',
  sort: 'asc', limit: 1000)
```

Get grouped daily bars for all stocks:
```ruby
Massive::REST::Stocks.grouped_daily('2023-01-09', adjusted: true)
```

Get open and close prices for a specific date:
```ruby
Massive::REST::Stocks.open_close('AAPL', '2023-01-09')
```

### Real-time Data

Get the most recent quote (NBBO):
```ruby
Massive::REST::Stocks.last_quote('AAPL')
```

Get the most recent trade:
```ruby
Massive::REST::Stocks.last_trade('AAPL')
```

### Market Snapshots

Get snapshot of a single ticker:
```ruby
Massive::REST::Stocks.snapshot('AAPL')
```

Get snapshot of multiple tickers:
```ruby
Massive::REST::Stocks.snapshot_all(tickers: 'AAPL,MSFT,GOOGL')
```

Get snapshot of all tickers:
```ruby
Massive::REST::Stocks.snapshot_all
```

### Technical Indicators

Simple Moving Average (SMA):
```ruby
Massive::REST::Stocks.sma('AAPL', window: 50, timespan: 'day', limit: 100)
```

Exponential Moving Average (EMA):
```ruby
Massive::REST::Stocks.ema('AAPL', window: 20, timespan: 'day', limit: 50)
```

Relative Strength Index (RSI):
```ruby
Massive::REST::Stocks.rsi('AAPL', window: 14, timespan: 'day')
```

Moving Average Convergence Divergence (MACD):
```ruby
Massive::REST::Stocks.macd('AAPL',
  short_window: 12,
  long_window: 26,
  signal_window: 9,
  timespan: 'day')
```

## Method Reference

### Market Data Methods

- `previous_close(ticker, adjusted: nil)` - Previous day's OHLC for a ticker
- `aggregates(ticker, multiplier, timespan, from, to, adjusted: nil, sort: nil, limit: nil)` - Aggregate bars over a date range
- `grouped_daily(date, adjusted: nil, include_otc: nil)` - All stocks' daily bars for a date
- `open_close(ticker, date, adjusted: nil)` - Open and close prices for a specific date

### Real-time Methods

- `last_quote(ticker)` - Most recent NBBO quote
- `last_trade(ticker)` - Most recent trade

### Snapshot Methods

- `snapshot(ticker)` - Current snapshot of a single ticker
- `snapshot_all(tickers: nil, include_otc: nil)` - Current snapshot of all or specified tickers

### Technical Indicator Methods

- `sma(ticker, ...)` - Simple Moving Average
- `ema(ticker, ...)` - Exponential Moving Average
- `rsi(ticker, ...)` - Relative Strength Index
- `macd(ticker, ...)` - Moving Average Convergence Divergence

All technical indicator methods accept these optional parameters:
- `timestamp` - Query by timestamp (YYYY-MM-DD or millisecond timestamp)
- `timespan` - Size of time window ('day', 'week', 'month', etc.)
- `adjusted` - Whether results are adjusted for splits
- `window` - Window size for calculation
- `series_type` - Price type ('close', 'open', 'high', 'low')
- `expand_underlying` - Include underlying aggregates
- `order` - Sort order ('asc' or 'desc')
- `limit` - Limit number of results

## Development

After checking out the repo, run `bake` to see available development tasks.

Run tests with:
```bash
bundle exec sus
```

This project uses:
- [sus](https://github.com/ioquatix/sus) for testing
- [bake](https://github.com/ioquatix/bake) for task automation
- [async](https://github.com/socketry/async) framework (inherited from massive-rest)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/vadrigar/massive-rest-stocks.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
