class StatisticsController < ApplicationController

  require 'nokogiri'
  require 'open-uri'

  def index
    @teams{
            "BALONCESTO SEVILLA", 
            "CAI ZARAGOZA", 
            "DOMINION BILBAO BASKET", 
            "FIATC JOVENTUT", 
            "FC BARCELONA LASSA", 
            "HERBALIFE GRAN CANARIA", 
            "ICL MANRESA", 
            "IBEROSTAR TENERIFE", 
            "LABORAL KUTXA BASKONIA", 
            "MONTAKIT FUENLABRADA", 
            "MORABANC ANDORRA",
            "MOVISTAR ESTUDIANTES", 
            "UCAM MURCIA", 
            "UNICAJA", 
            "REAL MADRID",
            "RETABET.ES GBC", 
            "RIO NATURA MONBUS OBRADOIRO", 
            "VALENCIA BASKET CLUB"
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

    ap @equips

    # resultat
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

    ap @equips

  end

  def is_number? string
    true if Float(string) rescue false
  end

end