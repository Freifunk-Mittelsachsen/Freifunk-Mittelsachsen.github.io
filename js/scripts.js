
// target blank für externe links
$.expr[':'].external = function(obj){
    return !obj.href.match(/^mailto\:/)
           && (obj.hostname != location.hostname)
           && !obj.href.match(/^javascript\:/)
           && !obj.href.match(/^$/)
};

$('a:external').attr('target', '_blank');

function freifunkUser() {
  $.getJSON("http://karte.freifunk-mittelsachsen.de/meshviewer/nodes.json", function(data) {
    var clients = 0;
    $.each(data['nodes'],function(node) {
      clients = clients + this['statistics']['clients'];
    });
    $('#clientcount').empty().text(clients);
  });
}

$(document).ready(function(){
  freifunkUser();
});
