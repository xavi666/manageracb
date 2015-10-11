class StatisticsController < ApplicationController

  require 'nokogiri'
  require 'open-uri'

  def index
    puts "------index statistcs"
    doc = Nokogiri::HTML(open("http://www.acb.com/fichas/LACB60005.php"))
    @nodes = doc.search("//table[@class='estadisticasnew']/tr")
    @partit = doc.css("table.estadisticasnew")[0]
    @jugadors = doc.css("table.estadisticasnew")[1]

    rows = @jugadors.search('//tr')
    @details = rows.collect do |row|
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
    @details.delete_if { |k, v| k.nil? }
    puts @details.inspect
  end

  def is_number? string
    true if Float(string) rescue false
  end

end