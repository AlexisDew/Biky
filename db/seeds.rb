# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# Scrapper BikeZ.com
require 'nokogiri'
require 'open-uri'
require 'awesome_print'
@models = []
@brands = []

puts '___________Models:___________'

def make_model_for(year)
  url = "http://www.bikez.com/year/index.php?year=#{year}"
  html_file = open(url).read
  html_doc = Nokogiri::HTML(html_file)

  i = 1
  model = {year: year}

  html_doc.search('.zebra td').each do |element|
    case i # always 3 td for one bike (but not always on the same row... :( )
    when 1 # 1st column = model with link
      if element.search('a').count > 0
        if element.search('a').last.text == ''
          i = 0
        else
          model[:model] = element.search('a').last.text.strip
          model[:link] = element.search('a').last.attribute('href').value.gsub('../', 'http://bikez.com/')
        end
      else
        i = 0
      end
    when 2 # 2nd column = brand whith link
      if element.search('a').count > 0
        model[:brand] = element.search('a').last.text.strip
        brand = {
          name: element.search('a').last.text.strip,
          link: element.search('a').last.attribute('href').value.gsub('../', 'http://bikez.com/')
        }
      end
      @brands << brand
    when 3 # 3rd column = image / for us saving + reinitialize counter i
      ap model
      @models << model
      i = 0
    end
    i += 1
  end
end

for year in (2000..2019) # (1970..2019)
  scraper_results = make_model_for(year)
end

@brands.uniq!
puts '___________Brands:___________'
ap @brands


