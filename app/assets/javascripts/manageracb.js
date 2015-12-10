$(document).ready(function(){
  $(".select2").select2({width: "100%", allowClear: true});
});

function set_player_select2(id, player_id) {
  $("#"+id).select2('val', player_id);
  $("#"+id).trigger('change');
}