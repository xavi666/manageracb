class ImportsController < ApplicationController

  include SortableFilterHelper
  require 'nokogiri'
  require 'open-uri'

  def index
  end

  def statistics
    @partits = []
    html_pages = HtmlPage.all

    html_pages.each do |html_page| 
      pagina_partit = Nokogiri::XML(html_page.html)

      # dades equips
      taula_equips = pagina_partit.css("div.titulopartidonew")[0]
      row_equips = taula_equips.search('tr')
      @equips = row_equips.collect do |row|
        detail = {}
        [
          [:local, 'td[1]/text()'],
          [:visitant, 'td[2]/text()']
        ].each do |name, xpath|
          equip = row.at_xpath(xpath).to_s.strip
          equip.to_s.slice!("&#xA0;") if name == :visitant
          equip = equip[0..-3] if name == :local

          detail[name] = equip
        end
        if detail[:local] != ''
          detail
        end
      end

      @equips.delete_if { |k, v| k.nil? }
      @partits.push(@equips)

      # dades jugadors
      taula_jugadors = pagina_partit.css("table.estadisticasnew")[1]
      rows_jugadors = taula_jugadors.search('//tr')
      local_visitant = "local"
      temporada = Setting.find_by_name("season_data").value
      equips_jornada = 9

      jornada = (html_page.game_number / equips_jornada).round + 1

      @statistics = rows_jugadors.collect do |row|
        detail = {}
        [
          [:number, 'td[1]/text()'],
          [:name, 'td[2]/a/text()'],
          [:seconds, 'td[3]/text()'],
          [:points, 'td[4]/text()'],
          [:two_p, 'td[5]/text()'],
          [:two_pm, 'td[6]/text()'],
          [:three_p, 'td[7]/text()'],
          [:three_pm, 'td[8]/text()'],
          [:one_p, 'td[9]/text()'],
          [:one_pm, 'td[10]/text()'],
          [:rebounds, 'td[11]/text()'],
          [:dorebounds, 'td[12]/text()'],
          [:assists, 'td[13]/text()'],
          [:steals, 'td[14]/text()'],
          [:turnovers, 'td[15]/text()'],
          [:fastbreaks, 'td[16]/text()'],
          [:mblocks, 'td[17]/text()'],
          [:rblocks, 'td[18]/text()'],
          [:slunks, 'td[19]/text()'],
          [:mfaults, 'td[20]/text()'],
          [:rfaults, 'td[21]/text()'],
          [:positive_negative, 'td[22]/text()'],
          [:value, 'td[23]/text()'],
          [:team, local_visitant],
          [:game_number, jornada],
          [:season, temporada]
        ].each do |name, xpath|
          if name == :team || name == :game_number || name == :season
            detail[name] = xpath
          else
            detail[name] = row.at_xpath(xpath).to_s.strip || 0
          end
        end
        local_visitant = "visitant" if detail[:number] == "E"
        if is_number?(detail[:number])
          detail
        end
      end
      @statistics.delete_if { |k, v| k.nil? }

      #ap @statistics

      create_from_list @statistics, @equips
    end
  end

  def create_from_list statistics, equips
    @teams = Rails.application.config.teams
    
    @count_players = 0
    @count_teams = 0
    @count_statistics = 0 

    statistics.each do |statistic|
      jugador = Player.find_by_name statistic[:name]
      local = Team.find(@teams[equips[0][:local]])
      visitant = Team.find(@teams[equips[0][:visitant]])

      unless local
        local = Team.create!(:name => equips[0][:local])
        @count_teams += 1 
      end

      unless visitant
        visitant = Team.create!(:name => equips[0][:visitant])
        @count_teams += 1 
      end

      team = statistic[:team] == "local" ? local : visitant
      team_against = statistic[:team] == "local" ? visitant : local

      unless jugador
        jugador = Player.create!(:name => statistic[:name], :team_id => local.id, :number => statistic[:number])
        @count_players += 1 
      end

      new_statistic = Statistic.where(:player_id => jugador.id, :season => statistic[:season], :game_number => statistic[:game_number], :team_id => team.id, :team_against_id => team_against.id).first?

      unless new_statistic
        new_statistic = Statistic.create!(:player_id => jugador.id, 
                        :team_id => team.id, :team_against_id => team_against.id,
                        :season => statistic[:season], :game_number => statistic[:game_number],
                        :number => jugador.number, 
                        :seconds => get_seconds(statistic[:seconds]), :points => statistic[:points], 
                        :two_p => get_points_tried(statistic[:two_p]), :two_pm => get_points_made(statistic[:two_p]),
                        :three_p => get_points_tried(statistic[:three_p]), :three_pm => get_points_made(statistic[:three_p]),
                        :one_p => get_points_tried(statistic[:one_p]), :one_pm => get_points_made(statistic[:one_p]),
                        :rebounds => statistic[:rebounds], :orebounds => get_o_rebounds(statistic[:dorebounds]),
                        :drebounds => get_d_rebounds(statistic[:dorebounds]), :assists => statistic[:assists],
                        :steals => statistic[:steals], :turnovers => statistic[:turnovers],
                        :turnovers => statistic[:turnovers], :fastbreaks => statistic[:fastbreaks],
                        :mblocks => statistic[:mblocks] , :rblocks => statistic[:rblocks],
                        :mfaults => statistic[:mfaults], :rfaults => statistic[:rfaults],
                        :positive_negative => statistic[:positive_negative], :value => statistic[:value])
        @count_statistics += 1 
      end
    end
  end


  def html_pages
    cod_edicions = ["59"]
    @count = 0
    cod_edicions.each_with_index {|cod_edicion, index| 
      #totals partits => 9 * 34 = 306

      (1..306).each do |partit|
        url_partit = "http://www.acb.com/stspartido.php?cod_competicion=LACB&cod_edicion=59&partido="+partit.to_s
        pagina_partit = Nokogiri::HTML(open(url_partit))
        HtmlPage.create!(:code => cod_edicion, :game_number => partit, :html => pagina_partit.inner_html)
        @count += 1
      end
    }
  end

  private
    def is_number? string
      true if Float(string) rescue false
    end

    def get_seconds minutes_seconds
      return 0 if minutes_seconds.blank? || minutes_seconds == "&#xA0;"
      ms = Time.strptime(minutes_seconds, "%M:%S")
      seconds = ms.min * 60 + ms.sec
    end

    def get_points_made points
      a_points = points.split("/")
      a_points[0]
    end

    def get_points_tried points
      a_points = points.split("/")
      a_points[1]
    end

    def get_tant_per_cent

    end

    def get_d_rebounds rebounds
      a_rebounds = rebounds.split("+")
      a_rebounds[0]
    end

    def get_o_rebounds rebounds
      a_rebounds = rebounds.split("+")
      a_rebounds[1]
    end
   
end