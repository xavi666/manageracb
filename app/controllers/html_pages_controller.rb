class HtmlPagesController < ApplicationController

  include SortableFilterHelper
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
    if params[:search]
      code = params[:search][:code]
      season = params[:search][:season]
      num_games = params[:search][:num_games].to_i
      @count = 0
      #totals partits => 9 * 34 = 306 per a la temporada 2014
      #total partits temporada 2015, 54?
      (1..num_games).each do |partit|
        url_partit = "http://www.acb.com/stspartido.php?cod_competicion=LACB&cod_edicion="+code+"&partido="+partit.to_s
        pagina_partit = Nokogiri::HTML(open(url_partit))
        html_page = HtmlPage.where(code: code, season: season, game_number: partit, html: pagina_partit.inner_html, html_page_type: "statistic").first
        unless html_page
          HtmlPage.create!(code: code, season: season, game_number: partit, html: pagina_partit.inner_html, html_page_type: "statistic")
          @count += 1
        end
      end
    end
  end

  def import_games
    if params[:search]
      code = params[:search][:code]
      season = params[:search][:season]
      num_games = params[:search][:num_games].to_i
      #jornades = 34
      (1..num_games).each do |jornada|
        url_partit = "http://acb.com/resulcla.php?codigo=LACB-"+code+"&jornada="+jornada.to_s
        pagina_jornada = Nokogiri::HTML(open(url_partit))
        game = HtmlPage.where(:code => code, season: season, :game_number => jornada, :html => pagina_jornada.inner_html, :html_page_type => "game").first
        unless game
          HtmlPage.create!(:code => code, season: season, :game_number => jornada, :html => pagina_jornada.inner_html, :html_page_type => "game")
          @count += 1
        end
      end
    end
  end

  private
    def html_page_params
      params.require(:html_page).permit([:game_number])
    end

end
