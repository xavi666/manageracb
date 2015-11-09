  class StatisticsController < ApplicationController

  def index
    @statistics = Statistic.game
  end

  def create
    @statistic = Statistic.create(statistic_params)
  end

  def update
    @statistic.update_attributes statistic_params
  end

  def destroy
    @statistic.destroy
  end

  def import
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
            "BILBAO BASKET" => 3
          }

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
          equip.slice!("#xA0;")
          equip.slice!(0) if name == :visitant
          equip = equip[0..-3] if name == :local

          detail[name] = equip
        end
        if detail[:local] != '' || detail[:visitant] != ''
          if @teams[detail[:local]] || @teams[detail[:visitant]]
            detail
          end
        end
      end

      @equips.delete_if { |k, v| k.nil? }
      @partits.push(@equips)

      # dades jugadors
      taula_jugadors = pagina_partit.css("table.estadisticasnew")[1]
      rows_jugadors = taula_jugadors.search('//tr')
      local_visitant = "local"
      temporada = "2014"
      equips_jornada = 9

      jornada = (html_page.game_number / equips_jornada).round
      jornada += 1 if html_page.game_number % equips_jornada > 0

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
          [:seasson, temporada]
        ].each do |name, xpath|
          if name == :team || name == :game_number || name == :seasson
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

      create_from_list @statistics, @equips, @teams
    end
  end

  def export
    #column_names = %w(seconds points assists rebounds value)
    @statistics = Statistic.game
    respond_to do |format|
      format.html
      format.csv{ render text: to_csv(@statistics) }
    end
  end

  def create_from_list statistics, equips, teams    
    statistics.each do |statistic|
      if teams[equips[0][:local]] != "" and teams[equips[0][:visitant]] != ""
        unless local = Team.find(teams[equips[0][:local]])
          local = Team.create!(:name => equips[0][:local])
        end

        unless visitant = Team.find(teams[equips[0][:visitant]])
          visitant = Team.create!(:name => equips[0][:visitant])
        end

        team = statistic[:team] == "local" ? local : visitant
        team_against = statistic[:team] == "local" ? visitant : local

        unless jugador = Player.find_by_name(statistic[:name])
          jugador = Player.create!(:name => statistic[:name], :team_id => team.id, :number => statistic[:number])
        end

        new_statistic = Statistic.where(:player_id => jugador.id, :seasson => statistic[:seasson], :game_number => statistic[:game_number], :team_id => team.id, :team_against_id => team_against.id).exists?

        unless new_statistic
          new_statistic = Statistic.create!(:player_id => jugador.id, 
                          :team_id => team.id, :team_against_id => team_against.id,
                          :seasson => statistic[:seasson], :game_number => statistic[:game_number],
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
                          :positive_negative => statistic[:positive_negative], :value => statistic[:value],
                          :type_statistic => 'game')
        end
      end
    end
  end

  def acumulats
    seasson = "2014"
    teams = Team.all

    teams.each do |team|
      team.players.each do |player|
        (1..34).each do |game_number|

          unless Statistic.where(:player_id => player.id, :seasson => seasson, :game_number => game_number - 1, :type_statistic => "player").exists?
            prev_seconds = 0
            prev_points = 0
            prev_two_p = 0
            prev_two_pm = 0
            prev_three_p = 0
            prev_three_pm = 0
            prev_one_p = 0
            prev_one_pm = 0
            prev_rebounds = 0
            prev_orebounds = 0
            prev_drebounds = 0
            prev_assists = 0
            prev_steals = 0
            prev_turnovers = 0
            prev_fastbreaks = 0
            prev_mblocks = 0
            prev_rblocks = 0
            prev_mfaults = 0
            prev_rfaults = 0
            prev_positive_negative = 0
            prev_value = 0
          else
            prev_statistic = Statistic.where(:player_id => player.id, :seasson => seasson, :game_number => game_number - 1, :type_statistic => "player").first
            prev_seconds = prev_statistic.seconds
            prev_points = prev_statistic.points
            prev_two_p = prev_statistic.two_p
            prev_two_pm = prev_statistic.two_pm
            prev_three_p = prev_statistic.three_p
            prev_three_pm = prev_statistic.three_pm
            prev_one_p = prev_statistic.one_p
            prev_one_pm = prev_statistic.one_pm
            prev_rebounds = prev_statistic.rebounds
            prev_orebounds = prev_statistic.orebounds
            prev_drebounds = prev_statistic.drebounds
            prev_assists = prev_statistic.assists
            prev_steals = prev_statistic.steals
            prev_turnovers = prev_statistic.turnovers
            prev_fastbreaks = prev_statistic.fastbreaks
            prev_mblocks = prev_statistic.mblocks
            prev_rblocks = prev_statistic.rblocks
            prev_mfaults = prev_statistic.mfaults
            prev_rfaults = prev_statistic.rfaults
            prev_positive_negative = prev_statistic.positive_negative
            prev_value = prev_statistic.value
          end

          unless Statistic.where(:player_id => player.id, :seasson => seasson, :game_number => game_number, :type_statistic => "game").exists?
            seconds = 0
            points = 0
            two_p = 0
            two_pm = 0
            three_p = 0
            three_pm = 0
            one_p = 0
            one_pm = 0
            rebounds = 0
            orebounds = 0
            drebounds = 0
            assists = 0
            steals = 0
            turnovers = 0
            fastbreaks = 0
            mblocks = 0
            rblocks = 0
            mfaults = 0
            rfaults = 0
            positive_negative = 0
            value = 0
          else
            statistic = Statistic.where(:player_id => player.id, :seasson => seasson, :game_number => game_number, :type_statistic => "game").first
            seconds = statistic.seconds
            points = statistic.points
            two_p = statistic.two_p
            two_pm = statistic.two_pm
            three_p = statistic.three_p
            three_pm = statistic.three_pm
            one_p = statistic.one_p
            one_pm = statistic.one_pm
            rebounds = statistic.rebounds
            orebounds = statistic.orebounds
            drebounds = statistic.drebounds
            assists = statistic.assists
            steals = statistic.steals
            turnovers = statistic.turnovers
            fastbreaks = statistic.fastbreaks
            mblocks = statistic.mblocks
            rblocks = statistic.rblocks
            mfaults = statistic.mfaults
            rfaults = statistic.rfaults
            positive_negative = statistic.positive_negative
            value = statistic.value
          end

          new_statistic = Statistic.where(:player_id => player.id, 
                          :team_id => team.id,
                          :seasson => seasson, :game_number => game_number,
                          :type_statistic => "player").first_or_create

          new_statistic.update_attributes(:seconds => prev_seconds + seconds, :points => prev_points + points, 
                          :two_p => prev_two_p + two_p, :two_pm => prev_two_pm + two_pm,
                          :three_p => prev_three_p + three_p, :three_pm => prev_three_pm + three_pm,
                          :one_p => prev_one_p + one_p, :one_pm => prev_one_pm + one_pm,
                          :rebounds => prev_rebounds + rebounds, :orebounds => prev_orebounds + orebounds,
                          :drebounds => prev_drebounds + drebounds, :assists => prev_assists + assists,
                          :steals => prev_steals + steals, :turnovers => prev_turnovers + turnovers,
                          :turnovers => prev_turnovers + turnovers, :fastbreaks => prev_fastbreaks + fastbreaks,
                          :mblocks => prev_mblocks + mblocks , :rblocks => prev_rblocks + rblocks,
                          :mfaults => prev_mfaults + mfaults, :rfaults => prev_rfaults + rfaults,
                          :positive_negative => prev_positive_negative + positive_negative, :value => prev_value + value)
          new_statistic.save!
        end
      end
    end
  end

  def acumulats_equip
    seasson = "2014"
    teams = Team.all

    teams.each do |team|
      (1..34).each do |game_number|
        seconds = 0
        points = 0
        two_p = 0
        two_pm = 0
        three_p = 0
        three_pm = 0
        one_p = 0
        one_pm = 0
        rebounds = 0
        orebounds = 0
        drebounds = 0
        assists = 0
        steals = 0
        turnovers = 0
        fastbreaks = 0
        mblocks = 0
        rblocks = 0
        mfaults = 0
        rfaults = 0
        positive_negative = 0
        value = 0
        team.players.each do |player|
          if Statistic.where(:player_id => player.id, :seasson => seasson, :game_number => game_number, :type_statistic => "player").exists?
            statistic = Statistic.where(:player_id => player.id, :seasson => seasson, :game_number => game_number, :type_statistic => "player").first
            seconds += statistic.seconds
            points += statistic.points
            two_p += statistic.two_p
            two_pm += statistic.two_pm
            three_p += statistic.three_p
            three_pm += statistic.three_pm
            one_p += statistic.one_p
            one_pm += statistic.one_pm
            rebounds += statistic.rebounds
            orebounds += statistic.orebounds
            drebounds += statistic.drebounds
            assists += statistic.assists
            steals += statistic.steals
            turnovers += statistic.turnovers
            fastbreaks += statistic.fastbreaks
            mblocks += statistic.mblocks
            rblocks += statistic.rblocks
            mfaults += statistic.mfaults
            rfaults += statistic.rfaults
            positive_negative += statistic.positive_negative
            value += statistic.value
          end   
        end

        new_statistic = Statistic.where( 
                          :team_id => team.id,
                          :seasson => seasson, :game_number => game_number,
                          :type_statistic => "team").first_or_create

        new_statistic.update_attributes(:seconds =>  seconds, :points => points, 
                        :two_p => two_p, :two_pm => two_pm,
                        :three_p => three_p, :three_pm => three_pm,
                        :one_p => one_p, :one_pm => one_pm,
                        :rebounds => rebounds, :orebounds => orebounds,
                        :drebounds => drebounds, :assists => assists,
                        :steals => steals, :turnovers => turnovers,
                        :turnovers => turnovers, :fastbreaks => fastbreaks,
                        :mblocks => mblocks , :rblocks => rblocks,
                        :mfaults => mfaults, :rfaults => rfaults,
                        :positive_negative => positive_negative, :value => value)
        new_statistic.save!
      end
    end
  end

  private
    def to_csv statistics
    CSV.generate do |csv|
      column_names = %w(seconds points assists rebounds value)
      csv << column_names
      statistics.each do |statistic|
        if statistic.seconds > 0
          player_statistic = Statistic.player.where(player_id: statistic.player_id, game_number: statistic.game_number).first
          team_statistic = Statistic.team.where(team_id: statistic.team_against_id, game_number: statistic.game_number).first
          csv << [player_statistic.seconds, player_statistic.value, player_statistic.points, team_statistic.value, team_statistic.points]
        end
      end
    end
  end

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

    def statistic_params
      params.require(:statistic).permit([:name])
    end

end