namespace :export do
  # rake export:seeds_format_live_data > db/seeds_live.rb
  desc "Exports data for using in a seeds.rb."
  task :seeds_format_live_data => :environment do
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

  # rake export:seeds_format_all_data > db/seeds_all.rb
  task :seeds_format_all_data => :environment do
    Player.all.each do |player|
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
    Game.all.each do |game|
      puts "Game.create(#{game.serializable_hash.
            delete_if {|key, value| ['created_at','updated_at'].
            include?(key)}.to_s.gsub(/[{}]/,'')})"
    end
    
    puts ""
    User.all.each do |user|
      puts "User.create(#{user.serializable_hash.
            delete_if {|key, value| ['created_at','updated_at'].
            include?(key)}.to_s.gsub(/[{}]/,'')})"
    end
    puts ""
    UserTeam.all.each do |user_team|
      puts "UserTeam.create(#{user_team.serializable_hash.
            delete_if {|key, value| ['created_at','updated_at'].
            include?(key)}.to_s.gsub(/[{}]/,'')})"
    end
    puts ""
    UserTeamPlayer.all.each do |user_team_player|
      puts "UserTeamPlayer.create(#{user_team_player.serializable_hash.
            delete_if {|key, value| ['created_at','updated_at'].
            include?(key)}.to_s.gsub(/[{}]/,'')})"
    end
    puts ""
    Statistic.all.each do |statistic|
      puts "Statistic.create(#{statistic.serializable_hash.
            delete_if {|key, value| ['created_at','updated_at'].
            include?(key)}.to_s.gsub(/[{}]/,'')})"
    end
    puts ""
    Price.all.each do |price|
      puts "Price.create(#{price.serializable_hash.
            delete_if {|key, value| ['created_at','updated_at'].
            include?(key)}.to_s.gsub(/[{}]/,'')})"
    end
    puts ""

  end
end