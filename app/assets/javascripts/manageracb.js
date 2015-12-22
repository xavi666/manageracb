$(document).ready(function(){
  $(".select2").select2({
    theme: "bootstrap",
    width: "100%", 
    allowClear: true});
});

function set_player_select2(id, player_id) {
  $("#"+id).select2('val', player_id);
  $("#"+id).trigger('change');
}

function addPoints(nStr) {
  if(nStr){
    nStr += '';
    var x = nStr.split(',');
    var x1 = x[0];
    var x2 = x.length > 1 ? ',' + x[1] : '';
    var rgx = /(\d+)(\d{3})/;
    while (rgx.test(x1)) {
        x1 = x1.replace(rgx, '$1' + '.' + '$2');
    }
    return x1 + x2;
  }else{
    return 0;
  }
}

function removePoints(nStr) {
  no_points = nStr.replace('.' ,'').replace('.' ,'').replace(',' ,'');
  return parseInt(no_points);
}