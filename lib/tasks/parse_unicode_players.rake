# encoding: utf-8 
task :parse_unicode_players => :environment do
  Player.all.each do |player|
    name = player.name
    name = name.gsub('&#xE0;', 'à')
    name = name.gsub('&#xE1;', 'á')
    
    name = name.gsub('&#xE9;', 'é')
    name = name.gsub(/&#xD3;/, 'Ó')
    name = name.gsub(/&#xED;/, 'í')
    name = name.gsub(/&#xFA;/, 'ú')
    name = name.gsub(/&#xF3;/, 'ó') 
    name = name.gsub(/&#xFC;/, 'ú')
    name = name.gsub(/&#xC1;/, 'Á')
    name = name.gsub(/&#xDA;/, 'Ú') 

    player.name = name
    player.save!
  end
end

