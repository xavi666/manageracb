class HtmlPagesController < ApplicationController

  require 'nokogiri'
  require 'open-uri'

  def index
    @html_pages = HtmlPage.all
  end

  def create
    @html_page = HtmlPage.create(html_page_params)
  end

  def update
    @html_page.update_attributes html_pages_params
  end

  def destroy
    @html_page.destroy
  end

  def import_statistics
    cod_edicions = ["59"]
    @count = 0
    cod_edicions.each_with_index {|cod_edicion, index| 
      #totals partits => 9 * 34 = 306
      (1..306).each do |partit|
        url_partit = "http://www.acb.com/stspartido.php?cod_competicion=LACB&"+cod_edicion.to_s+"=59&partido="+partit.to_s
        pagina_partit = Nokogiri::HTML(open(url_partit))
        game = HtmlPage.where(:code => cod_edicion, :game_number => partit, :html => pagina_partit.inner_html, :html_page_type => "statistic").first
        unless game
          HtmlPage.create!(:code => cod_edicion, :game_number => partit, :html => pagina_partit.inner_html, :html_page_type => "statistic")
          @count += 1
        end
      end
    }
  end

  def import_games
    cod_edicions = ["60"]
    @count = 0
    cod_edicions.each_with_index {|cod_edicion, index| 
      #jornades = 34
      (1..34).each do |jornada|
        url_partit = "http://acb.com/resulcla.php?codigo=LACB-"+cod_edicion.to_s+"&jornada="+jornada.to_s
        pagina_jornada = Nokogiri::HTML(open(url_partit))
        game = HtmlPage.where(:code => cod_edicion, :game_number => jornada, :html => pagina_jornada.inner_html, :html_page_type => "game").first
        unless game
          HtmlPage.create!(:code => cod_edicion, :game_number => jornada, :html => pagina_jornada.inner_html, :html_page_type => "game")
          @count += 1
        end
      end
    }
  end

  private
    def html_page_params
      params.require(:html_page).permit([:game_number])
    end

end
