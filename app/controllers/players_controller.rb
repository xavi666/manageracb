class PlayersController < ApplicationController
  require 'open-uri'  

  def index
    @players = Player.all
  end

  def create
    @player = Player.create(player_params)
  end

  def update
    @player.update_attributes player_params
  end

  def destroy
    @player.destroy
  end

  def show
    @player = Player.find(params[:id])
  end

  def money
    doc = Nokogiri::HTML(open("#{Rails.root}/mercado_201506.html"))
    game_number = Setting.find_by_name("game_number").value
    season = Setting.find_by_name("season").value

    doc.css("table#posicion1 tbody tr").each do |player_row|
      create_player(player_row, "base", season, game_number)
    end
    doc.css("table#posicion3 tbody tr").each do |player_row|
      create_player(player_row, "alero", season, game_number)
    end
    doc.css("table#posicion5 tbody tr").each do |player_row|
      create_player(player_row, "pivot", season, game_number)
    end
    redirect_to action: "index"
  end

  private
    def player_params
      params.require(:player).permit([:name])
    end

    def create_player player_row, position, season, game_number
      if player_row.css(".iconos img").to_s.include? "espanol" 
        nacionality = "espanol"
      else
        nacionality = "extracomunitario"
      end
      image = player_row.css(".foto img")[0]['src'].split('/')[2]
      team = player_row.css(".equipo img")[0]['title'].upcase
      teams = Rails.application.config.teams
      team_id = teams[team]
      name = player_row.css(".jugador").text
      price_cents = player_row.css(".precio").text.to_f*100

      player = Player.find_by_name(name)
      unless player
        player = Player.create!(name: name, team_id: team_id, active: true, position: position, image: image, price_cents: price_cents, nacionality: nacionality, active: true)
      else
        player.position = position
        player.active = true
        player.image = image
        player.nacionality = nacionality
        player.price_cents = price_cents
        player.save!
      end

      price = Price.where(player_id: player.id, season: season, game_number: game_number).first
      unless price
        price = Price.create!(player_id: player.id, season: season, game_number: game_number, price_cents: price_cents)
      else
        price.price_cents = price_cents
        price.save!
      end

    end
end
