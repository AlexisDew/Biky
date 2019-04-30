# Scrapper Motoplanet to catch all models
require 'nokogiri'
require 'open-uri'
require 'awesome_print'

puts '---Launching Biky Seeds---'
puts '> Create Fake users? (Y/N)'
response = STDIN.gets.chomp
if response == 'y' || response == 'Y'
  User.destroy_all
  ap User.create!(email: 'alexis.dewerdt@gmail.com', password: 'azerty')
  ap User.create!(email: 'justine.auclair@gmail.com', password: 'azerty')
  ap User.create!(email: 'toto@gmail.com', password: 'azerty')
else
  ap User.all
end


puts '> Catching cities? (Y/N)'
# response = STDIN.gets.chomp
response = 'y'
if response == 'y' || response == 'Y'
  City.destroy_all
  City.create!(name: 'Lyon')
  City.create!(name: 'Mâcon')
else
  ap City.all
end

puts '> Would you like to scrape Bikes models? (Y/N)'
response = STDIN.gets.chomp
if response == 'y' || response == 'Y'
  puts '> From witch year would you like to scrape models? (ex: 2018)'
  start = STDIN.gets.chomp.to_i
  puts 'Ok, scrapping beggins...'
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
    finish = Date.today.year.to_i
    for year in (start..finish)
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
else
  puts 'Ok, scrapping aborted'
  ap Model.all
end

puts '> Would ou like to create fake bikes? (Y/N)'
# response = STDIN.gets.chomp
response = 'y'
if response == 'y' || response == 'Y'
  colors = ['rouge', 'jaune', 'bleu', 'gris', 'blanc']
  User.all.each do |user|
    rand(2..6).times do
      ap Bike.create!(
        model_id: rand(Model.all.first.id..Model.all.last.id),
        owner_id: user.id,
        city_id: rand(City.all.first.id..City.all.last.id),
        color: colors[rand(0..colors.length)]
      )
    end
  end
else
  ap Bike.all
end











