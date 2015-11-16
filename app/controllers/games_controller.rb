class GamesController < ApplicationController

  def index
    @games = Game.all
  end

  def create_from_html
    @teams = Rails.application.config.teams
    
    @partits = []
    html_pages = HtmlPage.game

    html_pages.each do |html_page| 
      pagina_jornada = Nokogiri::HTML(html_page.html)


      count = 0
      local = 0
      pagina_jornada.css("table td.naranjaclaro").each do |link|
        equip = link.content.upcase
        equip.slice! " |"
        if count % 2 == 1
          game = Game.where(game_number: html_page.game_number, season: Setting.find_by_name("season").value, local_team_id: @teams[local], visitant_team_id: @teams[equip]).first
          unless game
            game = Game.create!(game_number: html_page.game_number, season: Setting.find_by_name("season").value, local_team_id: @teams[local], visitant_team_id: @teams[equip])
          end
        else
          local = equip
        end
        count += 1
      end
    end
  end

  def update
    @game.update_attributes game_params
  end

  def destroy
    @game.destroy
  end

  private
    def game_params
      params.require(:game).permit([:name])
    end
end