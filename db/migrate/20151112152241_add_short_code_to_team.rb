class AddShortCodeToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :short_code, :string    

    Team.all.each do |team|
      short_code = ""
      short_code = "SEV" if team.name == "BALONCESTO SEVILLA"
      short_code = "CAI" if team.name == "CAI ZARAGOZA"
      short_code = "BLB" if team.name == "DOMINION BILBAO BASKET"
      short_code = "JOV" if team.name == "FIATC JOVENTUT"
      short_code = "FCB" if team.name == "FC BARCELONA LASSA"
      short_code = "GCA" if team.name == "HERBALIFE GRAN CANARIA"
      short_code = "MAN" if team.name == "ICL MANRESA"
      short_code = "CAN" if team.name == "IBEROSTAR TENERIFE"
      short_code = "LAB" if team.name == "LABORAL KUTXA BASKONIA"
      short_code = "FUE" if team.name == "MONTAKIT FUENLABRADA"
      short_code = "AND" if team.name == "MORABANC ANDORRA"
      short_code = "EST" if team.name == "MOVISTAR ESTUDIANTES"
      short_code = "MUR" if team.name == "UCAM MURCIA CB"
      short_code = "UNI" if team.name == "UNICAJA"
      short_code = "RMA" if team.name == "REAL MADRID"
      short_code = "GBC" if team.name == "RETABET.ES GBC"
      short_code = "OBR" if team.name == "RIO NATURA MONBUS OBRADOIRO"
      short_code = "VBC" if team.name == "VALENCIA BASKET CLUB"

      team.short_code = short_code
      team.save!
    end
  end
end
