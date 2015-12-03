class StatisticsController < ApplicationController

  include SortableFilterHelper

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
    if params[:search]
      code = params[:search][:code]
      season = params[:search][:season]

      @teams = Rails.application.config.teams
      @partits = []
      html_pages = HtmlPage.statistic.where(code: code, season: season)

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
            [:season, season]
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
        create_from_list @statistics, @equips, @teams
      end
    end
  end

  def export
    #training data
    file_name = "export.csv"
    @statistics = Statistic.game.where(season: "2014")
    f = open(file_name, "w+")
    f.close()
    CSV.open(file_name, "wb") do |csv|
      statistics_array = statistic_to_csv(@statistics)
      statistics_array.each do |statistic|
        csv << statistic
      end
    end

    # predictions
    file_name = "predictions.csv"

    @games = Game.where(season: Setting.find_by_name(:season).value, game_number: Setting.find_by_name(:game_number).value)

    f = open(file_name, "w+")
    f.close()
    CSV.open(file_name, "wb") do |csv|
      statistics_array = data_to_csv(@games)
      statistics_array.each do |statistic|
        csv << statistic
      end
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
          statistic[:season] == "2015" ? active = true : active = false
          jugador = Player.create!(:name => statistic[:name], :team_id => team.id, :number => statistic[:number], :active => active)
        end

        new_statistic = Statistic.where(:player_id => jugador.id, :season => statistic[:season], :game_number => statistic[:game_number], :team_id => team.id, :team_against_id => team_against.id).first

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
                          :positive_negative => statistic[:positive_negative], :value => statistic[:value],
                          :type_statistic => 'game')
        end
      end
    end
  end

  def acumulats_jugador
    if params[:search]
      season = params[:search][:season]
      teams = Team.all
      teams.each do |team|
        team.players.each do |player|
          (1..34).each do |game_number|
            prev_statistic = Statistic.where(:player_id => player.id, :season => season, :game_number => game_number - 1, :type_statistic => "player").first
            unless prev_statistic
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

            statistic = Statistic.where(:player_id => player.id, :season => season, :game_number => game_number, :type_statistic => "game").first
            unless statistic
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

            game = Game.where("local_team_id = ? OR visitant_team_id = ?", team.id, team.id).where(:season => season, :game_number => game_number).first
            if game
              team_against_id = game.visitant_team_id if team.id == game.local_team_id 
              team_against_id = game.local_team_id if team.id == game.visitant_team_id
            end

            new_statistic = Statistic.where(:player_id => player.id, 
                            :team_id => team.id, :team_against_id => team_against_id,
                            :season => season, :game_number => game_number,
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
  end

  def acumulats_equip
    if params[:search]
      season = params[:search][:season]
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
            # Local Team
            statistic = Statistic.where(:player_id => player.id, :season => season, :game_number => game_number, :type_statistic => "player").first
            if statistic
              seconds = (seconds + statistic.seconds)
              points = (points + statistic.points)
              two_p = (two_p + statistic.two_p)
              two_pm = (two_pm + statistic.two_pm)
              three_p = (three_pm + statistic.three_p)
              three_pm = ( three_pm + statistic.three_pm)
              one_p = (one_p + statistic.one_p)
              one_pm = (one_pm + statistic.one_pm)
              rebounds = (rebounds + statistic.rebounds)
              orebounds = (orebounds + statistic.orebounds)
              drebounds = (drebounds + statistic.drebounds)
              assists = (assists + statistic.assists)
              steals = (steals + statistic.steals)
              turnovers = (turnovers + statistic.turnovers)
              fastbreaks = (fastbreaks + statistic.fastbreaks)
              mblocks = (mblocks + statistic.mblocks)
              rblocks = (rblocks + statistic.rblocks)
              mfaults = (mfaults + statistic.mfaults)
              rfaults = (rfaults + statistic.rfaults)
              positive_negative = (positive_negative + statistic.positive_negative)
              value = (value + statistic.value)
            end   
          end

          #Rival Team
          game = Game.where("local_team_id = ? OR visitant_team_id = ?", team.id, team.id).where(:season => season, :game_number => game_number).first
          if game
            team_against_id = game.visitant_team_id if team.id == game.local_team_id 
            team_against_id = game.local_team_id if team.id == game.visitant_team_id
          end
          #Rival Team

          new_statistic = Statistic.where( 
                            :team_id => team.id,
                            :team_against_id => team_against_id,
                            :season => season, :game_number => game_number,
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
  end

  def acumulats_equip_received
    if params[:search]
      season = params[:search][:season]
      @acumulats_equip = Statistic.where(:season => season, :type_statistic => "team").order(:team_id)
      teams = Team.all

      #received
      @partits_received = []
      teams.each do |team|
        @partits_received[team.id] ||= {}
        (0..34).each do |game_number|
          @partits_received[team.id][game_number] = {"value_received" => 0}
        end
      end

      id_anterior = 0
      acumulat_anterior = {"value_received" => 0, "points_received" => 0, "assists_received" => 0, "rebounds_received" => 0, "three_pm_received" => 0}
      @acumulats_equip.each do |acumulat_equip|
        #Rival Team
        game = Game.where("local_team_id = ? OR visitant_team_id = ?", acumulat_equip.team_id, acumulat_equip.team_id).where(:season => acumulat_equip.season, :game_number => acumulat_equip.game_number).first
        if game
          team_against_id = game.visitant_team_id if acumulat_equip.team_id == game.local_team_id 
          team_against_id = game.local_team_id if acumulat_equip.team_id == game.visitant_team_id
        end
        #Rival Team
        acumulat_anterior = {"value_received" => 0, "points_received" => 0, "assists_received" => 0, "rebounds_received" => 0, "three_pm_received" => 0} if id_anterior != acumulat_equip.team_id
        @partits_received[team_against_id][acumulat_equip.game_number]["value_received"] = acumulat_equip.value - acumulat_anterior["value_received"]
        @partits_received[team_against_id][acumulat_equip.game_number]["points_received"] = acumulat_equip.points - acumulat_anterior["points_received"]
        @partits_received[team_against_id][acumulat_equip.game_number]["assists_received"] = acumulat_equip.assists - acumulat_anterior["assists_received"]
        @partits_received[team_against_id][acumulat_equip.game_number]["rebounds_received"] = acumulat_equip.rebounds - acumulat_anterior["rebounds_received"]
        @partits_received[team_against_id][acumulat_equip.game_number]["three_pm_received"] = acumulat_equip.three_pm - acumulat_anterior["three_pm_received"]

        acumulat_anterior["value_received"] =  acumulat_equip.value
        acumulat_anterior["points_received"] =  acumulat_equip.points
        acumulat_anterior["assists_received"] =  acumulat_equip.assists
        acumulat_anterior["rebounds_received"] =  acumulat_equip.rebounds
        acumulat_anterior["three_pm_received"] =  acumulat_equip.three_pm
        id_anterior = acumulat_equip.team_id
      end      
    
      # acumulats received
      @acumulats_received = []
      teams.each do |team|
        @acumulats_received[team.id] ||= {}
        (0..34).each do |game_number|
          @acumulats_received[team.id][game_number] = {"value_received" => 0, "points_received" => 0, "assists_received" => 0, "rebounds_received" => 0, "three_pm_received" => 0}
        end
      end
      teams.each do |team|
        (0..34).each do |game_number|
          if game_number > 0     
            @acumulats_received[team.id][game_number]["value_received"] = @partits_received[team.id][game_number]["value_received"] + @acumulats_received[team.id][game_number-1]["value_received"]
            @acumulats_received[team.id][game_number]["points_received"] = @partits_received[team.id][game_number]["points_received"] + @acumulats_received[team.id][game_number-1]["points_received"]
            @acumulats_received[team.id][game_number]["assists_received"] = @partits_received[team.id][game_number]["assists_received"] + @acumulats_received[team.id][game_number-1]["assists_received"]
            @acumulats_received[team.id][game_number]["rebounds_received"] = @partits_received[team.id][game_number]["rebounds_received"] + @acumulats_received[team.id][game_number-1]["value_received"]
            @acumulats_received[team.id][game_number]["three_pm_received"] = @partits_received[team.id][game_number]["three_pm_received"] + @acumulats_received[team.id][game_number-1]["three_pm_received"]

            statistic = Statistic.team.where(season: season, team_id: team.id, game_number: game_number).first
            statistic.value_received = @acumulats_received[team.id][game_number]["value_received"]
            statistic.points_received = @acumulats_received[team.id][game_number]["points_received"]
            statistic.assists_received = @acumulats_received[team.id][game_number]["assists_received"]
            statistic.rebounds_received = @acumulats_received[team.id][game_number]["rebounds_received"]
            statistic.three_pm_received = @acumulats_received[team.id][game_number]["three_pm_received"]
            statistic.save!
          end
        end
      end
    end
  end

  private
    def statistic_to_csv statistics
      csv = []
      column_names = %w(PlayerId TeamAgainstId GameNumber PlayerSeconds PlayerPoints Player2P Player2PM Player3P Player3PM Player1P Player1PM PlayerRebounds PlayerORebounds PlayerDRebounds PlayerAssists PlayerSteals PlayerTurnovers PlayerFastbreak PlayerBlocksM PlayerBlockR PlayerFaultsM PlayerFaulsR PlayerPN PlayerValue 
        TeamPoints Team2P Team2PM Team3P Team3PM Team1P Team1PM TeamRebounds TeamORebounds TeamDRebounds TeamAssists TeamSteals TeamTurnovers TeamFastbreak TeamBlocksM TeamBlockR TeamFaultsM TeamFaultsR TeamPN TeamValue GameValue GamePoints GameRebounds GameAssists)
      csv << column_names
      statistics.each do |statistic|
        if statistic.seconds > 0
          game_number = statistic.game_number
          player_statistic = Statistic.player.where(player_id: statistic.player_id, game_number: game_number, season: "2014").first
          team_statistic = Statistic.team.where(team_id: statistic.team_against_id, game_number: game_number, season: "2014").first
          if player_statistic and team_statistic
            csv << [player_statistic.player_id, team_statistic.team_id, statistic.game_number,
                  player_statistic.seconds / game_number, player_statistic.points / game_number, player_statistic.two_p / game_number, player_statistic.two_pm / game_number, player_statistic.three_p / game_number, player_statistic.three_pm / game_number, player_statistic.one_p / game_number, player_statistic.one_pm / game_number, player_statistic.rebounds / game_number, player_statistic.orebounds / game_number, player_statistic.drebounds / game_number, player_statistic.assists / game_number, player_statistic.steals / game_number, player_statistic.turnovers / game_number, player_statistic.fastbreaks / game_number, player_statistic.mblocks / game_number, player_statistic.rblocks / game_number, player_statistic.mfaults / game_number, player_statistic.rfaults / game_number, player_statistic.positive_negative / game_number, player_statistic.value / game_number,
                  team_statistic.points / game_number, team_statistic.two_p / game_number, team_statistic.two_pm / game_number, team_statistic.three_p / game_number, team_statistic.three_pm / game_number, team_statistic.one_p / game_number, team_statistic.one_pm / game_number, team_statistic.rebounds / game_number, team_statistic.orebounds / game_number, team_statistic.drebounds / game_number, team_statistic.assists / game_number, team_statistic.steals / game_number, team_statistic.turnovers / game_number, team_statistic.fastbreaks / game_number, team_statistic.mblocks / game_number, team_statistic.rblocks / game_number, team_statistic.mfaults / game_number, team_statistic.rfaults / game_number, team_statistic.positive_negative / game_number, team_statistic.value / game_number,
                  statistic.value, statistic.points, statistic.rebounds, statistic.assists]
          end
        end
      end
      csv
    end

    def data_to_csv games
      csv = []
      column_names = %w(PlayerId TeamAgainstId GameNumber PlayerSeconds PlayerPoints Player2P Player2PM Player3P Player3PM Player1P Player1PM PlayerRebounds PlayerORebounds PlayerDRebounds PlayerAssists PlayerSteals PlayerTurnovers PlayerFastbreak PlayerBlocksM PlayerBlockR PlayerFaultsM PlayerFaulsR PlayerPN PlayerValue 
        TeamPoints Team2P Team2PM Team3P Team3PM Team1P Team1PM TeamRebounds TeamORebounds TeamDRebounds TeamAssists TeamSteals TeamTurnovers TeamFastbreak TeamBlocksM TeamBlockR TeamFaultsM TeamFaultsR TeamPN TeamValue)
      csv << column_names
      game_number = Setting.find_by_name("game_number").value.to_i
      season = Setting.find_by_name("season").value
      games.each do |game|
        local_team_statistic = Statistic.team.where(team_id: game.local_team_id, game_number: game_number, season: season).first
        visitant_team_statistic = Statistic.team.where(team_id: game.visitant_team_id, game_number: game_number, season: season).first
        game.local_team.players.active.each do |player|
          player_statistic = Statistic.player.where(player_id: player.id, game_number: game_number, season: season).first
          if player_statistic and visitant_team_statistic
            csv << [player_statistic.player_id, visitant_team_statistic.team_id, game_number,
                  player_statistic.seconds / game_number, player_statistic.points / game_number, player_statistic.two_p / game_number, player_statistic.two_pm / game_number, player_statistic.three_p / game_number, player_statistic.three_pm / game_number, player_statistic.one_p / game_number, player_statistic.one_pm / game_number, player_statistic.rebounds / game_number, player_statistic.orebounds / game_number, player_statistic.drebounds / game_number, player_statistic.assists / game_number, player_statistic.steals / game_number, player_statistic.turnovers / game_number, player_statistic.fastbreaks / game_number, player_statistic.mblocks / game_number, player_statistic.rblocks / game_number, player_statistic.mfaults / game_number, player_statistic.rfaults / game_number, player_statistic.positive_negative / game_number, player_statistic.value / game_number,
                  visitant_team_statistic.points / game_number, visitant_team_statistic.two_p / game_number, visitant_team_statistic.two_pm / game_number, visitant_team_statistic.three_p / game_number, visitant_team_statistic.three_pm / game_number, visitant_team_statistic.one_p / game_number, visitant_team_statistic.one_pm / game_number, visitant_team_statistic.rebounds / game_number, visitant_team_statistic.orebounds / game_number, visitant_team_statistic.drebounds / game_number, visitant_team_statistic.assists / game_number, visitant_team_statistic.steals / game_number, visitant_team_statistic.turnovers / game_number, visitant_team_statistic.fastbreaks / game_number, visitant_team_statistic.mblocks / game_number, visitant_team_statistic.rblocks / game_number, visitant_team_statistic.mfaults / game_number, visitant_team_statistic.rfaults / game_number, visitant_team_statistic.positive_negative / game_number, visitant_team_statistic.value / game_number]
          end
        end
        game.visitant_team.players.active.each do |player|
          player_statistic = Statistic.player.where(player_id: player.id, game_number: game_number, season: season).first
          if player_statistic and local_team_statistic
            csv << [player_statistic.player_id, local_team_statistic.team_id, game_number,
                  player_statistic.seconds / game_number, player_statistic.points / game_number, player_statistic.two_p / game_number, player_statistic.two_pm / game_number, player_statistic.three_p / game_number, player_statistic.three_pm / game_number, player_statistic.one_p / game_number, player_statistic.one_pm / game_number, player_statistic.rebounds / game_number, player_statistic.orebounds / game_number, player_statistic.drebounds / game_number, player_statistic.assists / game_number, player_statistic.steals / game_number, player_statistic.turnovers / game_number, player_statistic.fastbreaks / game_number, player_statistic.mblocks / game_number, player_statistic.rblocks / game_number, player_statistic.mfaults / game_number, player_statistic.rfaults / game_number, player_statistic.positive_negative / game_number, player_statistic.value / game_number,
                  local_team_statistic.points / game_number, local_team_statistic.two_p / game_number, local_team_statistic.two_pm / game_number, local_team_statistic.three_p / game_number, local_team_statistic.three_pm / game_number, local_team_statistic.one_p / game_number, local_team_statistic.one_pm / game_number, local_team_statistic.rebounds / game_number, local_team_statistic.orebounds / game_number, local_team_statistic.drebounds / game_number, local_team_statistic.assists / game_number, local_team_statistic.steals / game_number, local_team_statistic.turnovers / game_number, local_team_statistic.fastbreaks / game_number, local_team_statistic.mblocks / game_number, local_team_statistic.rblocks / game_number, local_team_statistic.mfaults / game_number, local_team_statistic.rfaults / game_number, local_team_statistic.positive_negative / game_number, local_team_statistic.value / game_number]
          end
        end
      end
      csv
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