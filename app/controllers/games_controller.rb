class GamesController < ApplicationController

  def index
    @games = Game.all
  end

  def create_from_html
    @teams = {
            "BALONCESTO SEVILLA" => 1,
            "CAI ZARAGOZA" => 2, 
            "DOMINION BILBAO BASKET" => 3, 
            "FIATC JOVENTUT" => 4, 
            "FC BARCELONA LASSA" => 5, 
            "HERBALIFE GRAN CANARIA" => 6, 
            "ICL MANRESA" => 7, 
            "IBEROSTAR TENERIFE" => 8, 
            "LABORAL KUTXA BASKONIA" => 9, 
            "MONTAKIT FUENLABRADA" => 10, 
            "MORABANC ANDORRA" => 11,
            "MOVISTAR ESTUDIANTES" => 12, 
            "UCAM MURCIA" => 13, 
            "UNICAJA" => 14, 
            "REAL MADRID" => 15,
            "RETABET.ES GBC" => 16, 
            "RIO NATURA MONBUS OBRADOIRO" => 17, 
            "VALENCIA BASKET CLUB" => 18,
            "UCAM MURCIA CB" => 13,
            "GIPUZKOA BASKET" => 16,
            "LA BRUIXA D'OR MANRESA" => 7,
            "FC BARCELONA" => 5,
            "DOMINION BILBAO" => 3,
            "TUENTI MóVIL ESTUDIANTES" => 12,
            "TUENTI M&#xF3;VIL ESTUDIANTES" => 12,
            "BILBAO BASKET" => 3,
            "DOMINION BILBAO BASKET" => 3,
            "FC BARCELONA LASSA" => 5,
            "ICL MANRESA" => 7
          }

    @partits = []
    html_pages = HtmlPage.game

    html_pages.each do |html_page| 
      pagina_jornada = Nokogiri::XML(html_page.html)

      # dades equips
      taula_partits = pagina_jornada.css("td.naranjaclaro")[0]
      rows_partits = taula_partits.search('//a')
      count = 0
      @partits = rows_partits.collect do |row|
        detail = {}
        [
          [:equipo, 'text()'],
        ].each do |name, xpath|
          if count > 0
            unless detail[:equipo] == "" and detail[:equipo].nil? and detail[:equipo].blank?
              detail[name] = row.at_xpath(xpath).to_s.strip
            end
          end
          count += 1
        end
        detail
      end

      count = 0
      local = ""
      @partits.each do |partit|
        if count < 19 and partit[:equipo] and @teams[partit[:equipo].to_s.upcase]
          if count % 2 == 1
            game = Game.where(game_number: html_page.game_number, seasson: "2015", local_team_id: @teams[local], visitant_team_id: @teams[partit[:equipo].to_s.upcase]).first
            unless game
              game = Game.create!(game_number: html_page.game_number, seasson: "2015", local_team_id: @teams[local], visitant_team_id: @teams[partit[:equipo].to_s.upcase])
            end
          else
            local = partit[:equipo].to_s.upcase
          end
          count += 1
        end
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