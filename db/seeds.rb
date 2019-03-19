# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# Scrapper BikeZ.com
# require 'nokogiri'
# require 'open-uri'
# require 'awesome_print'
# @models = []
# @brands = []

# puts '___________Models:___________'

# def make_model_for(year)
#   url = "http://www.bikez.com/year/index.php?year=#{year}"
#   html_file = open(url).read
#   html_doc = Nokogiri::HTML(html_file)

#   i = 1
#   model = {year: year}

#   html_doc.search('.zebra td').each do |element|
#     case i # always 3 td for one bike (but not always on the same row... :( )
#     when 1 # 1st column = model with link
#       if element.search('a').count > 0
#         if element.search('a').last.text == ''
#           i = 0
#         else
#           model[:model] = element.search('a').last.text.strip
#           model[:link] = element.search('a').last.attribute('href').value.gsub('../', 'http://bikez.com/')
#         end
#       else
#         i = 0
#       end
#     when 2 # 2nd column = brand whith link
#       if element.search('a').count > 0
#         model[:brand] = element.search('a').last.text.strip
#         brand = {
#           name: element.search('a').last.text.strip,
#           link: element.search('a').last.attribute('href').value.gsub('../', 'http://bikez.com/')
#         }
#       end
#       @brands << brand
#     when 3 # 3rd column = image / for us saving + reinitialize counter i
#       ap model
#       @models << model
#       i = 0
#     end
#     i += 1
#   end
# end

# for year in (2000..2019) # (1970..2019)
#   scraper_results = make_model_for(year)
# end

# @brands.uniq!
# puts '___________Brands:___________'
# ap @brands


#/////////////////////////////////////////////////////
# Scrapper Motoplanet
require 'nokogiri'
require 'open-uri'
require 'awesome_print'
models = []
brands = [] # used to scrape
# Model.destroy_all
# Brand.destroy_all

url = "https://www.motoplanete.com/constructeurs/constructeursIndex/index.php" # catching brands + id
html_file = open(url).read
html_doc = Nokogiri::HTML(html_file)

html_doc.search('#listeMoto a').each do |element|
  brand = {
    name: element.text.strip,
    id: element.attribute('href').value.match(/constructeur\/(\d*)\//)[1]
  }
  # Brand.new(name: brand[:name])
  brands << brand
end

brands.each do |brand|
  for year in (2009..2019)
    url = "https://www.motoplanete.com/constructeurs/constructeur/#{brand[:id]}/#{year}/#{brand[:name]}.php"
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)

    html_doc.search('.vignette_moto a').each do |element|
      model = {
        name: element.text.strip,
        year: year,
        brand: brand[:name]
        # brand: Brand.where(name: brand[:name])
      }
      url = element.attribute('href').value

      if url.match(/\/contact.html/)

        html_file = open(url).read
        html_doc = Nokogiri::HTML(html_file)

        model[:category] = html_doc.search('.signature')[0].text.strip

        html_doc.search('#blocTech li').each do |element|
          model[:tank_capacity] = element.text.strip.match(/Réservoir : (.*)/)[1] if element.text.strip.match(/Réservoir : (.*)/)
          model[:saddle_height] = element.text.strip.match(/Hauteur de selle : (.*)/)[1] if element.text.strip.match(/Hauteur de selle : (.*)/)
          model[:length] = element.text.strip.match(/Longueur : (.*)/)[1] if element.text.strip.match(/Longueur : (.*)/)
          model[:width] = element.text.strip.match(/Largeur : (.*)/)[1] if element.text.strip.match(/Largeur : (.*)/)
          model[:height] = element.text.strip.match(/Hauteur : (.*)/)[1] if element.text.strip.match(/Hauteur : (.*)/)
          model[:weight] = element.text.strip.match(/Poids à sec : (.*)/)[1] if element.text.strip.match(/Poids à sec : (.*)/)
          model[:full_weight] = element.text.strip.match(/Poids en ordre de marche : (.*)/)[1] if element.text.strip.match(/Poids en ordre de marche : (.*)/)
          model[:cylinder] = element.text.strip.match(/(.* cc) \(/)[1] if element.text.strip.match(/(.* cc) \(/)
          model[:power] = element.text.strip.match(/(.* ch) à/)[1] if element.text.strip.match(/(.* ch) à/)
          model[:power_ratio] = element.text.strip.match(/Rapport poids \/ puissance : (.*)/)[1] if element.text.strip.match(/Rapport poids \/ puissance : (.*)/)
          model[:max_speed] = element.text.strip.match(/Vitesse max : (.*)/)[1] if element.text.strip.match(/Vitesse max : (.*)/)
          model[:acceleration] = element.text.strip.match(/Accélération 0 à 100 : (.*)/)[1] if element.text.strip.match(/Accélération 0 à 100 : (.*)/)
          model[:consumption] = element.text.strip.match(/Consommation moyenne : (.*)/)[1] if element.text.strip.match(/Consommation moyenne : (.*)/)
        end

        html_doc.search('.moteur li').each_with_index do |element, index|
          model[:motor_type] = element.text.strip if index == 1
        end

        html_doc.search('.moteur li').each do |element|
          model[:a2_compatibility] = element.text.strip if element.text.strip.match(/A2/) && (html_doc.search('.moteur li').last == element)
        end
      end
      ap model
      models << model
    end
  end
end








