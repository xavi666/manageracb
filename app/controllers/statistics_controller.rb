class StatisticsController < ApplicationController

  require 'nokogiri'
  require 'open-uri'

  def index
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
            "VALENCIA BASKET CLUB" => 18
          }
    @partits = []

    cod_edicions = ["59"]
    cod_edicions.each_with_index {|cod_edicion, index| 
      #totals partits => 9 * 34 = 306
      (1..2).each do |partit|
        url_jornada = "http://www.acb.com/stspartido.php?cod_competicion=LACB&cod_edicion=59&partido="+partit.to_s
        pagina_partit = Nokogiri::HTML(open(url_jornada))

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
            equip.slice!(0) if name == :visitant
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
            [:drebounds, 'td[12]/text()'],
            [:orebounds, 'td[13]/text()'],
            [:assists, 'td[14]/text()'],
            [:steals, 'td[15]/text()'],
            [:turnovers, 'td[16]/text()'],
            [:fastbreaks, 'td[17]/text()'],
            [:mblocks, 'td[18]/text()'],
            [:rbllocks, 'td[19]/text()'],
            [:slunks, 'td[20]/text()'],
            [:mfaults, 'td[21]/text()'],
            [:rfaults, 'td[22]/text()'],
            [:positive_negatives, 'td[23]/text()'],
            [:value, 'td[24]/text()'],
            [:team, local_visitant]
          ].each do |name, xpath|
            if name == :team
              detail[name] = xpath
            else
              detail[name] = row.at_xpath(xpath).to_s.strip
            end
          end
          
          
          local_visitant = "visitant" if detail[:number] == "E"
          if is_number?(detail[:number])
            detail
          end
        end
        @statistics.delete_if { |k, v| k.nil? }
        #ap @statistics

        puts "statics _ INIT"
        ap @statistics
        puts "statics _ END"
        create_from_list @statistics, @equips
        #ap @equips
      end
    }
  end

  def create_from_list statistics, equips
    puts "------> create_from_list"
    puts statistics.inspect
    statistics.each do |statistic|
      puts "------------entra "
      jugador = Player.find_by_name statistic[:name]
      local = Team.find_by_name equips[0][:local]
      visitant = Team.find_by_name equips[0][:visitant]


      puts local
      puts visitant
      puts jugador

      

      unless local
        local = Team.create!(:name => equips[0][:local])
      end

      unless visitant
        visitant = Team.create!(:name => equips[0][:visitant])
      end

      team = statistic[:team] == "local" ? local : visitant
      puts team.inspect

      unless jugador
        jugador = Player.create!(:name => statistic[:name], :team_id => local.id)
      end



      puts statistic.inspect
      puts "--------"
    end
    puts "---- END "
  end

  def is_number? string
    true if Float(string) rescue false
  end

end