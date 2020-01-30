

class RunScrape
  def initialize
    welcome
    pages
    stocks(@pages_to_scrape)
    main_loop
    exit_screen
  end

  def main_loop
    input = ''
    while input != 'exit'
      puts Url.main_menu.colorize(String.colors[rand(16)])
      puts "**************************************\n".colorize(:blue)+"Below is a list of available commands \n"+"***************************************\n".colorize(:blue)
      puts "1- List of Companies\n2. Search\n3. Sort\n4. View Random Stock\nType 'exit' to quit program"
      input = gets.chomp
      case input
      when '1'
        list_stocks
      when '2'
        find_stock_by_ticker
      when '3'
        sort
      when '4'
        rand_stock
      end
    end
    
  end

  def find_stock_by_ticker(ticker="")
    puts `clear`
    puts "This options searches from list of already scraped stocks"
    puts "Please enter the ticker :"
    ticker = gets.chomp
    match = Stock.all.detect { |stock|stock.symbol == ticker.upcase  }
    if match
      print `clear`
      puts "Company   "+match.company, "Ticker   "+match.symbol, "Price   "+match.price, "Volume   "+match.volume, "Percent Change   "+match.percent_change, "News  "+match.news, "Bio "+match.bio
    else
      puts "Sorry, that stock was not found in the database"
    end
    input = nil
  end

  def welcome
    print `clear`
    puts Url.logo.colorize(String.colors[rand(16)])
    sleep 3
    puts"Welcome to my Scraper!\nIt scrapes stock data and provides access to the latest news"
    intro_timer
  end

  def stocks(pages_to_scrape)
    Stock.import(Scraper.import(pages_to_scrape))
    @stock = Stock.all
  end


  def intro_timer(timer = 12)
    s = "▓"
    timer.downto(0) do |i|
      colors = String.colors
      print s
      s+="▓".colorize(colors[rand(16)])
      sleep 0.2
    end
  end

  def exit_screen
    puts Url.logo.colorize(:blue)
    puts "Thanks for checking out my work.\nI welcome your feedback!"
    intro_timer(12)
    puts "\n"
  end

  def pages
    response = 0
    while response != '1'
      print`clear`
      puts "There are currently #{Scraper.max_page} pages to scrape.\nHow many pages would you like scrape?"
      @pages_to_scrape = gets.chomp
      @seconds_to_scrape = @pages_to_scrape.to_i*21
      while @pages_to_scrape.match(/\D/) || @pages_to_scrape.to_i > Scraper.max_page || @pages_to_scrape.to_i< 0
        puts "Please enter a number between 1 and #{Scraper.max_page}"
        @pages_to_scrape = gets.chomp
      end
      if @seconds_to_scrape >= 3600
        puts "This will take #{@seconds_to_scrape/3600}H : #{@seconds_to_scrape%3600/60 }M : #{@seconds_to_scrape%3600%60}s to scrape. Would like to continue?\n1. Yes\n2. No"
      elsif @seconds_to_scrape < 60
        puts "This will take #{00}H : #{00}M : #{@seconds_to_scrape}s to scrape. Would like to continue?\n1. Yes\n2. No"
      else
        puts "This will take #{00}H : #{@seconds_to_scrape/60}M : #{@seconds_to_scrape%60}s to scrape. Would like to continue?\n1. Yes\n2. No"
      end
      response = gets.chomp
    end
    @pages_to_scrape= @pages_to_scrape.to_i
    @pages_to_scrape-=1
    @pages_to_scrape
  end

  def sort
    sort_option = nil
    puts `clear`
    while not ['1','2','3','4'].any?(sort_option)
      puts "1. Sort by Name\n2. Sort by price\n3. Sort by symbol\n4. Main menu"
      sort_option =gets.chomp
      case sort_option
      when '1'
        Stock.all.sort_by {|obj| obj.company}.each { |e| puts "Company: #{e.company} - Price: $#{e.price}" }
      when '2'
        Stock.all.sort_by {|obj| obj.price.to_f}.each { |e| puts "Company: #{e.company} - Price: $#{e.price}"  }
      when '3'
        Stock.all.sort_by {|obj| obj.symbol}.each { |e| puts "Company: #{e.company} - Price: $#{e.price}"  }
      when '4'
        break
      else
        puts "Please enter a valid option."
      end
    end
  end

  def rand_stock
    puts `clear`
    match = Stock.all[rand(Stock.all.size)]
    puts "Company =>   "+match.company, "Ticker =>   "+match.symbol, "Price =>   "+match.price, "Volume =>   "+match.volume, "Percent Change =>   "+match.percent_change, "News =>  "+match.news, "Bio:\n "+match.bio
  end

  def list_stocks
    Stock.all.each_with_index {|s, i| puts"#{i+1}. #{s.company}"}
    nil
  end

end
