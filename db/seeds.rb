# Scrapper Motoplanet to catch all models
require 'nokogiri'
require 'open-uri'
require 'awesome_print'
models = []
brands = []
puts '1. First destroy all models and brands in the database...'
Model.destroy_all
Brand.destroy_all


puts '2. Then scrapping brands...'
url = "https://www.motoplanete.com/constructeurs/constructeursIndex/index.php" # catching brands + id
html_file = open(url).read
html_doc = Nokogiri::HTML(html_file)

html_doc.search('#listeMoto a').each do |element|
  brand = {
    name: element.text.strip,
    id: element.attribute('href').value.match(/constructeur\/(\d*)\//)[1]
  }
  brands << brand
  brand = Brand.create!(name: brand[:name])
  brand.save
  ap brand
end

puts '3. Then for each brand adding models...'
brands.each do |brand|
  puts "Let's go first with : #{brand[:name]}.."
  for year in (2019..2019)
    puts "Scrapping all #{brand} bikes in #{year}"
    url = "https://www.motoplanete.com/constructeurs/constructeur/#{brand[:id]}/#{year}/#{brand[:name]}.php"
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)

    html_doc.search('.vignette_moto a').each do |element|
      model = {
        name: element.text.strip,
        year: year,
        # brand: brand[:name]
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
          model[:engine_size] = element.text.strip.match(/(.* cc) \(/)[1].to_i if element.text.strip.match(/(.* cc) \(/)
          model[:power] = element.text.strip.match(/(.* ch) à/)[1].to_i if element.text.strip.match(/(.* ch) à/)
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

      model[:brand] = Brand.find_by(name: brand[:name])
      model = Model.create!(model)
      models << model
      ap model
    end
    puts "#{brand[:name]}: All bikes in #{year} scrapped!"
  end
  puts "Done with : #{brand} (each year requested models have been scraped!)"
end








