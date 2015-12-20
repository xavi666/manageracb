$(document).ready(function(){
  $(".select2").select2({
    theme: "bootstrap",
    width: "100%", 
    allowClear: true});
});

function set_player_select2(id, player_id) {
  $("#"+id).select2().closest(".player").removeClass( "changed" );    
  if($("#"+id).select2().val().toString() != player_id.toString()){
    $("#"+id).select2().closest(".player").addClass( "changed" );    
  }
  $("#"+id).select2('val', player_id);
  $("#"+id).trigger('change');
}