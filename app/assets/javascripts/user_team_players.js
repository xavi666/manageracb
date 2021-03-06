$(document).ready(function(){
  
  $("body").on("change", ".user_team_player", function(e){
    $(this).parents('tr').children('.team_image').html("<img alt='' class='team' src='/assets/teams/"+$(this).select2().find(":selected").data("team-image")+".jpg'>"); 
    $(this).parents('tr').children('.player_image').html("<img alt='' class='player' src='/assets/players/"+$(this).select2().find(":selected").data("player-image")+"'>"); 
    $(this).parents('tr').children('.value').html($(this).select2().find(":selected").data("value"));
    $(this).parents('tr').children('.points').html($(this).select2().find(":selected").data("points"));
    $(this).parents('tr').children('.rebounds').html($(this).select2().find(":selected").data("rebounds"));
    $(this).parents('tr').children('.assists').html($(this).select2().find(":selected").data("assists"));
    $(this).parents('tr').children('.three_pm').html($(this).select2().find(":selected").data("three-pm"));
    $(this).parents('tr').children('.price').html(addPoints($(this).select2().find(":selected").data("price")));
    calculate_totals();
  });

  function calculate_totals() {
    fields = ["value", "points", "rebounds", "assists", "assists", "three_pm", "price"]
    $.each(fields, function( index, field ) {
      acumulat = 0
      $( ".player ."+field ).each(function( index ) {
        valor = $( this ).text();        
        if (valor == "" || valor == "undefined") {
          valor = 0; 
        } else {
          valor = removePoints(valor);
          valor = parseInt(valor);
        } 
        acumulat += valor;
      });
      $( ".totals ."+field).html(addPoints(acumulat));
    });
  }

});