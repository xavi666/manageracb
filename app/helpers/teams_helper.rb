module TeamsHelper

  def team_image team
    image_tag("teams/"+team.short_code+".jpg", class: "team") if team.short_code
  end
end