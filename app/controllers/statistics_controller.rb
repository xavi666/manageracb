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


    [1..2].each do |jornada|
      puts "-----------> "
      puts jornada
    end
    index_page = doc = Nokogiri::HTML(open("http://www.acb.com/resulcla.php?codigo=LACB-59&jornada=1&resultados="))

    doc = Nokogiri::HTML(open("http://www.acb.com/fichas/LACB60005.php"))
    #@nodes = doc.search("//table[@class='estadisticasnew']/tr")

    # dades jugadors
    taula_jugadors = doc.css("table.estadisticasnew")[1]

    rows_jugadors = taula_jugadors.search('//tr')
    @jugadors = rows_jugadors.collect do |row|
      detail = {}
      [
        [:dorsal, 'td[1]/text()'],
        [:nom, 'td[2]/a/text()'],
        [:minuts, 'td[3]/text()'],
        [:punts, 'td[4]/text()'],
        [:t2, 'td[5]/text()'],
        [:t2p, 'td[6]/text()'],
        [:t3, 'td[7]/text()'],
        [:t3p, 'td[8]/text()'],
        [:t1, 'td[9]/text()'],
        [:t1p, 'td[10]/text()'],
        [:rebots, 'td[11]/text()'],
        [:rebots_d, 'td[12]/text()'],
        [:rebots_o, 'td[13]/text()'],
        [:assistencies, 'td[14]/text()'],
        [:recuperades, 'td[15]/text()'],
        [:perdues, 'td[16]/text()'],
        [:contratacs, 'td[17]/text()'],
        [:taps_f, 'td[18]/text()'],
        [:taps_r, 'td[19]/text()'],
        [:mates, 'td[20]/text()'],
        [:faltes_f, 'td[21]/text()'],
        [:faltes_r, 'td[22]/text()'],
        [:mes_menys, 'td[23]/text()'],
        [:valoracio, 'td[24]/text()']
      ].each do |name, xpath|
        detail[name] = row.at_xpath(xpath).to_s.strip
      end
      if is_number?(detail[:dorsal])
        detail
      end
    end
    @jugadors.delete_if { |k, v| k.nil? }
    ap @jugadors

    # equips
    taula_equips = doc.css("div.titulopartidonew")[0]
    puts taula_equips
    row_equips = taula_equips.search('tr')
    puts row_equips
    @equips = row_equips.collect do |row|
      detail = {}
      [
        [:local, 'td[1]/text()'],
        [:visitant, 'td[2]/text()']
      ].each do |name, xpath|
        detail[name] = row.at_xpath(xpath).to_s.strip
      end
      if detail[:local] != ''
        detail
      end
    end

    @equips.delete_if { |k, v| k.nil? }
    ap @equips


  end

  def is_number? string
    true if Float(string) rescue false
  end

end