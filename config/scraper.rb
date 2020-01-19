require "nokogiri"
require "open-uri"
require_relative 'assets.rb'
require_relative "stock.rb"
require'colorize'
class Scraper
  def self.doc
    url = open(Url.main+"0")
    @doc = Nokogiri::HTML(url)
  end
  def self.counters
    doc
    @page_counter = 0
    @stocks_per_page = @doc.css("tbody tr").size.to_f
    @total_stocks = @doc.css(".pager div")[0].text.split(" ")[-2].to_f #Extracted a total count of all stocks to float format
    @final_page = (@total_stocks/@stocks_per_page).round
    @stocks = []
  end
  def self.max_page
    counters
    @final_page
  end

  def self.import(pages=1)
    counters
    stock_counter = 1
    while @page_counter <= pages#Goes through each page on the site
      k =pages.to_i
      k+=1
      k*=25
      current_page = open(Url.main+"#{@page_counter}") #changes the url on each iteration to up the site page count
      parsed = Nokogiri::HTML(current_page)
      parsed.css("tbody tr").each do |stock| # Assigns the attribute for each listing on the page in a hash. Each pass of this
        print `clear`
        puts "************************".colorize(:blue)
        puts "\t#{stock_counter}/#{k}".colorize(:blue)
        puts "-#{'-'*((stock_counter.to_f/k.to_f)*22.5)}".colorize(:blue)
        puts "\t#{((stock_counter.to_f/k.to_f)*100).to_i}%".colorize(:blue)
        puts "************************".colorize(:blue)
        stock_att = {                      #will create one complete stock hash which will be added to the stocks array
          symbol: stock.css("td a")[0].text,
          company: stock.css(" a")[1].text,
          price: stock.css("td")[2].text,
          volume: stock.css("td")[5].text,
          percent_change: stock.css("td")[4].text,
          news: Url.news+stock.css("a")[3].attribute("href").value
          }
          begin
            Nokogiri::HTML(open('https://finviz.com/quote.ashx?t='+"#{stock_att[:symbol]}")) do
            stock_att[:bio] = Nokogiri::HTML(open('https://finviz.com/quote.ashx?t='+"#{stock_att[:symbol]}")).css("td.fullview-profile").text.gsub(". ", ".\n")
          end
        rescue OpenURI::HTTPError => e
          if e.message == '404 Not Found'
            stock_att[:bio] = "Couldnt scrape a bio"
          else
            raise e
          end
        end
          # stk = Nokogiri::HTML(open('https://finviz.com/search.ashx?p=AEYE'))
          # stock_att[:bio] = Nokogiri::HTML(open('https://finviz.com/quote.ashx?t='+"#{stock_att[:symbol]}")).css("td.fullview-profile").text.gsub(". ", ".\n")
          @stocks << stock_att
          stock_counter+=1
        end
      @page_counter+=1
    end
    puts "Scraping completed"
    sleep 2
    puts "\n"
    @stocks
  end
end
