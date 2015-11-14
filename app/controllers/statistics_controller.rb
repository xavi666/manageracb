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
    html_pages = HtmlPage.statistic

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
    @statistics = Statistic.game
    respond_to do |format|
      format.html
      format.csv{ render text: to_csv(@statistics) }
    end
  end

  

  def acumulats_jugador
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
            prev_seconds = prev_statistic.seconds / game_number
            prev_points = prev_statistic.points / game_number
            prev_two_p = prev_statistic.two_p / game_number
            prev_two_pm = prev_statistic.two_pm / game_number
            prev_three_p = prev_statistic.three_p / game_number
            prev_three_pm = prev_statistic.three_pm / game_number
            prev_one_p = prev_statistic.one_p / game_number
            prev_one_pm = prev_statistic.one_pm / game_number
            prev_rebounds = prev_statistic.rebounds / game_number
            prev_orebounds = prev_statistic.orebounds / game_number
            prev_drebounds = prev_statistic.drebounds / game_number
            prev_assists = prev_statistic.assists / game_number
            prev_steals = prev_statistic.steals / game_number
            prev_turnovers = prev_statistic.turnovers / game_number
            prev_fastbreaks = prev_statistic.fastbreaks / game_number
            prev_mblocks = prev_statistic.mblocks / game_number
            prev_rblocks = prev_statistic.rblocks / game_number
            prev_mfaults = prev_statistic.mfaults / game_number
            prev_rfaults = prev_statistic.rfaults / game_number
            prev_positive_negative = prev_statistic.positive_negative / game_number
            prev_value = prev_statistic.value / game_number
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
            seconds = statistic.seconds / game_number
            points = statistic.points / game_number
            two_p = statistic.two_p / game_number
            two_pm = statistic.two_pm / game_number
            three_p = statistic.three_p / game_number
            three_pm = statistic.three_pm / game_number
            one_p = statistic.one_p / game_number
            one_pm = statistic.one_pm / game_number
            rebounds = statistic.rebounds / game_number
            orebounds = statistic.orebounds / game_number
            drebounds = statistic.drebounds / game_number
            assists = statistic.assists / game_number
            steals = statistic.steals / game_number
            turnovers = statistic.turnovers / game_number
            fastbreaks = statistic.fastbreaks / game_number
            mblocks = statistic.mblocks / game_number
            rblocks = statistic.rblocks / game_number
            mfaults = statistic.mfaults / game_number
            rfaults = statistic.rfaults / game_number
            positive_negative = statistic.positive_negative / game_number
            value = statistic.value / game_number
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
            seconds = (seconds + statistic.seconds) / game_number
            points = (statistic.points) / game_number
            two_p = (statistic.two_p) / game_number
            two_pm = (statistic.two_pm) / game_number
            three_p = (statistic.three_p) / game_number
            three_pm = (statistic.three_pm) / game_number
            one_p = (statistic.one_p) / game_number
            one_pm = (statistic.one_pm) / game_number
            rebounds = (statistic.rebounds) / game_number
            orebounds = (statistic.orebounds) / game_number
            drebounds = (statistic.drebounds) / game_number
            assists = (statistic.assists) / game_number
            steals = (statistic.steals) / game_number
            turnovers = (statistic.turnovers) / game_number
            fastbreaks = (statistic.fastbreaks) / game_number
            mblocks = (statistic.mblocks) / game_number
            rblocks = (statistic.rblocks) / game_number
            mfaults = (statistic.mfaults) / game_number
            rfaults = (statistic.rfaults) / game_number
            positive_negative = (statistic.positive_negative) / game_number
            value = (value + statistic.value) / game_number
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
        column_names = %w(PlayerId TeamAgainstId GameNumber PlayerSeconds PlayerPoints Player2P Player2PM Player3P Player3PM Player1P Player1PM PlayerRebounds PlayerORebounds PlayerDRebounds PlayerAssists PlayerSteals PlayerTurnovers PlayerFastbreak PlayerBlocksM PlayerBlockR PlayerFaultsM PlayerFaulsR PlayerPN PlayerValue 
          TeamPoints Team2P Team2PM Team3P Team3PM Team1P Team1PM TeamRebounds TeamORebounds TeamDRebounds TeamAssists TeamSteals TeamTurnovers TeamFastbreak TeamBlocksM TeamBlockR TeamFaultsM TeamFaultsR TeamPN TeamValue GameValue GamePoints GameRebounds GameAssists)
        csv << column_names
        statistics.each do |statistic|
          if statistic.seconds > 0
            player_statistic = Statistic.player.where(player_id: statistic.player_id, game_number: statistic.game_number).first
            team_statistic = Statistic.team.where(team_id: statistic.team_against_id, game_number: statistic.game_number).first
            csv << [player_statistic.player_id, team_statistic.team_id, statistic.game_number,
                    player_statistic.seconds, player_statistic.points, player_statistic.two_p, player_statistic.two_pm, player_statistic.three_p, player_statistic.three_pm, player_statistic.one_p, player_statistic.one_pm, player_statistic.rebounds, player_statistic.orebounds, player_statistic.drebounds, player_statistic.assists, player_statistic.steals, player_statistic.turnovers, player_statistic.fastbreaks, player_statistic.mblocks, player_statistic.rblocks, player_statistic.mfaults, player_statistic.rfaults, player_statistic.positive_negative, player_statistic.value,
                    team_statistic.points, team_statistic.two_p, team_statistic.two_pm, team_statistic.three_p, team_statistic.three_pm, team_statistic.one_p, team_statistic.one_pm, team_statistic.rebounds, team_statistic.orebounds, team_statistic.drebounds, team_statistic.assists, team_statistic.steals, team_statistic.turnovers, team_statistic.fastbreaks, team_statistic.mblocks, team_statistic.rblocks, team_statistic.mfaults, team_statistic.rfaults, team_statistic.positive_negative, team_statistic.value,
                    statistic.value, statistic.points, statistic.rebounds, statistic.assists]
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