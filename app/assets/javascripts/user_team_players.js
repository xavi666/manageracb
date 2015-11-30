$(document).ready(function(){
  
  $("body").on("change", ".user_team_player", function(e){
    $(this).parents('tr').children('.value').html($(this).select2().find(":selected").data("value"));
    $(this).parents('tr').children('.points').html($(this).select2().find(":selected").data("points"));
    $(this).parents('tr').children('.rebounds').html($(this).select2().find(":selected").data("rebounds"));
    $(this).parents('tr').children('.assists').html($(this).select2().find(":selected").data("assists"));
    $(this).parents('tr').children('.three_pm').html($(this).select2().find(":selected").data("three_pm"));
    $(this).parents('tr').children('.money').html($(this).select2().find(":selected").data("money"));
  });
});