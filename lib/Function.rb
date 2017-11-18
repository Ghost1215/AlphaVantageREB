module Alphavantage
  class Function
    include HelperFunctions

    def initialize function:, symbol:, interval: "1min", time_period: "60",
      series_type: "close", fastlimit: "0.01", slowlimit: "0.01",
      fastperiod: "12", slowperiod: "26", signalperiod: "9",
      fastmatype: "0", slowmatype: "0", signalmatype: "0",
      fastkperiod: "5", slowkperiod: "3", slowdperiod: "3",
      slowkmatype: "0", slowdmatype: "0", fastdperiod: "3",
      fastdmatype: "0", matype: "0", timeperiod1: "7", timeperiod2: "14",
      timeperiod3: "28", nbdevup: "2", nbdevdn: "2", acceleration: "0.01",
      maximum: "0.20", key:, verbose: false
      check_argument([true, false], verbose, "verbose")
      @client = return_client(key, verbose)
      check_argument(["SMA", "EMA", "WMA", "DEMA", "TEMA", "TRIMA", "KAMA", "T3",
        "RSI","MAMA", "MACD", "MACDEXT", "STOCH", "STOCHF", "STOCHRSI", "WILLR",
        "ADX", "ADXR", "APO", "PPO", "MOM", "BOP", "CCI", "CMO", "ROC", "ROCR",
        "AROON", "AROONOSC", "MFI", "TRIX", "ULTOSC", "DX", "MINUS_DI",
        "PLUS_DI", "MINUS_DM", "PLUS_DM", "BBANDS", "MIDPOINT", "MIDPRICE",
        "SAR", "TRANGE", "ATR", "NATR", "AD", "ADOSC", "OBV", "HT_SINE",
        "HT_TRENDLINE", "HT_TRENDMODE", "HT_DCPERIOD", "HT_DCPHASE",
        "HT_PHASOR"], function)
      url = "function=#{function}&symbol=#{symbol}"

      if ["SMA", "EMA", "WMA", "DEMA", "TEMA", "TRIMA", "KAMA", "T3", "RSI",
        "MAMA", "MACD", "MACDEXT", "STOCH", "STOCHF", "STOCHRSI", "WILLR",
        "ADX", "ADXR", "APO", "PPO", "MOM", "BOP", "CCI", "CMO", "ROC", "ROCR",
        "AROON", "AROONOSC", "MFI", "TRIX", "ULTOSC", "DX", "MINUS_DI",
        "PLUS_DI", "MINUS_DM", "PLUS_DM", "BBANDS", "MIDPOINT", "MIDPRICE",
        "SAR", "TRANGE", "ATR", "NATR", "AD", "ADOSC", "OBV", "HT_SINE",
        "HT_TRENDLINE", "HT_TRENDMODE", "HT_DCPERIOD", "HT_DCPHASE",
        "HT_PHASOR"].include? function
        check_argument(["1min", "5min", "15min", "30min", "60min", "daily", "weekly", "monthly"], interval)
        url += "&interval=#{interval}"
      end
      if ["SMA", "EMA", "WMA", "DEMA", "TEMA", "TRIMA", "KAMA", "T3", "RSI",
        "STOCHRSI", "WILLR", "ADX", "ADXR", "MOM", "CCI", "CMO", "ROC", "ROCR",
        "AROON", "AROONOSC", "MFI", "TRIX", "DX", "MINUS_DI", "PLUS_DI",
        "MINUS_DM", "PLUS_DM", "BBANDS", "MIDPOINT", "MIDPRICE", "ATR",
        "NATR"].include? function
        check_value(time_period, "time_period", "integer")
        url += "&time_period=#{time_period}"
      end
      if ["SMA", "EMA", "WMA", "DEMA", "TEMA", "TRIMA", "KAMA", "T3", "RSI",
        "MAMA", "MACD", "MACDEXT", "STOCHRSI", "APO", "PPO", "MOM", "ROC",
        "ROCR", "TRIX", "BBANDS", "MIDPOINT", "HT_SINE", "HT_TRENDLINE",
        "HT_TRENDMODE", "HT_DCPERIOD", "HT_DCPHASE", "HT_PHASOR"].include? function
        check_argument(["close", "open", "high", "low"], series_type)
        url += "&series_type=#{series_type}"
      end
      if ["MAMA"].include? function
        url += return_numval(fastlimit, "fastlimit", "float")
        url += return_numval(slowlimit, "slowlimit", "float")
      end
      if ["MACD", "MACDEXT", "APO", "PPO", "ADOSC"].include? function
        url += return_numval(fastperiod, "fastperiod", "integer")
        url += return_numval(slowperiod, "slowperiod", "integer")
      end
      if ["MACD", "MACDEXT"].include? function
        url += return_numval(signalperiod, "signalperiod", "integer")
      end
      if ["MACDEXT"].include? function
        url += return_matype(fastmatype, "fastmatype")
        url += return_matype(slowmatype, "slowmatype")
        url += return_matype(signalmatype, "signalmatype")
      end
      if ["STOCH", "STOCHRSI"].include? function
        url += return_numval(fastkperiod, "fastkperiod", "integer")
        url += return_numval(fastdperiod, "fastdperiod", "integer")
      end
      if ["STOCH"].include? function
        url += return_numval(slowkperiod, "slowkperiod", "integer")
        url += return_numval(signaklperiod, "signalkperiod", "integer")
        url += return_matype(slowkmatype, "slowkmatype")
        url += return_matype(slowdmatype, "slowdmatype")
      end
      if ["STOCH", "STOCHRSI"].include? function
        url += return_matype(fastdmatype, "fastdmatype")
      end
      if ["APO", "PPO", "BBANDS"].include? function
        url += return_matype(matype, "matype")
      end
      if ["ULTOSC"].include? function
        url += return_numval(timeperiod1, "timeperiod1", "integer")
        url += return_numval(timeperiod2, "timeperiod2", "integer")
        url += return_numval(timeperiod3, "timeperiod3", "integer")
      end
      if ["BBANDS"].include? function
        url += return_numval(nbdevup, "nbdevup", "integer")
        url += return_numval(nbdevdn, "nbdevdn", "integer")
      end
      if ["SAR"].include? function
        url += return_numval(acceleration, "acceleration", "float")
        url += return_numval(maximum, "maximum", "float")
      end

      @hash = @client.request(url)
      metadata = @hash.dig("Meta Data") || {}
      metadata.each do |key, val|
        key_sym = key.downcase.gsub(/[0-9.]/, "").lstrip.gsub(" ", "_").to_sym
        define_singleton_method(key_sym) do
          return val
        end
      end

      begin
        time_series = @hash.find{|key, val| key.include?("Technical Analysis")}[1]
      rescue Exception => e
        raise Alphavantage::Error.new message: "No Time Series found: #{e.message}",
          data: @hash
      end

      series = {}
      convert_key = {}
      time_series.values[0].keys.each do |key|
        key_sym = key.downcase.gsub(/[0-9.]/, "").lstrip.gsub(" ", "_").to_sym
        series[key_sym] = []
        convert_key[key] = key_sym
      end
      time_series.each do |time, ts_hash|
        ts_hash.each do |key, value|
          series[convert_key[key]] << [time, value]
        end
      end
      series.keys.each do |key_sym|
        define_singleton_method(key_sym) do |*args|
          args ||= []
          return return_series(series[key_sym], args[0])
        end
      end
    end

    attr_reader :hash
  end
end
