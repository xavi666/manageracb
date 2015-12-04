namespace :export do
  # rake export:seeds_format > db/seeds.rb
  desc "Exports data for using in a seeds.rb."
  task :seeds_format => :environment do
    Player.where(active: true).each do |player|
      puts "Player.create(#{player.serializable_hash.
            delete_if {|key, value| ['created_at','updated_at'].
            include?(key)}.to_s.gsub(/[{}]/,'')})"
    end
    puts ""
    Team.all.each do |team|
      puts "Team.create(#{team.serializable_hash.
            delete_if {|key, value| ['created_at','updated_at'].
            include?(key)}.to_s.gsub(/[{}]/,'')})"
    end
    puts ""
    Prediction.all.each do |prediction|
      puts "Prediction.create(#{prediction.serializable_hash.
            delete_if {|key, value| ['created_at','updated_at'].
            include?(key)}.to_s.gsub(/[{}]/,'')})"
    end
    puts ""
    Setting.all.each do |setting|
      puts "Setting.create(#{setting.serializable_hash.
            delete_if {|key, value| ['created_at','updated_at'].
            include?(key)}.to_s.gsub(/[{}]/,'')})"
    end
    puts ""
    Game.where(season: "2015").each do |game|
      puts "Game.create(#{game.serializable_hash.
            delete_if {|key, value| ['created_at','updated_at'].
            include?(key)}.to_s.gsub(/[{}]/,'')})"
    end
    puts ""
  end
end