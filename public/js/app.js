var currentGeohash = '';

function drawMap(){
  var chars = "0123456789bcdefghjkmnpqrstuvwxyz".split('');
  $.each(chars, function(idx,c){
    $('#map').append('<div class="ocean-gray geohash-'+c+'"></div>');
  });
};

function positionUpdated(position){
  var lat = position.coords.latitude,
    lng = position.coords.longitude,
    accuracy = position.coords.accuracy,
    full_geohash = encodeGeoHash(lat, lng),
    geohash = full_geohash.substr(0,8);

  if (currentGeohash == geohash) {
    return;
  };

  currentGeohash = geohash;

  console.log('latitude:', lat);
  console.log('longitude:', lng);
  console.log('accuracy:', lng);
  console.log('geohash:', geohash);

  $('#lat').html(lat);
  $('#lng').html(lng);
  $('#acc').html(accuracy);
  $('#geohash').html(geohash);

  $.get('/ping/'+geohash).done(function(data){
    console.log(data);
    console.log('#map .geohash-'+geohash[7]);
    $('#map .geohash-'+geohash[7]).removeClass('ocean-gray').addClass('ocean');
    $('#pings').prepend("<li>"+data+"</li>");
  });

  $.getJSON('/geocells/'+geohash).done(function(data){
    var jsonString = JSON.stringify(data, null, 4);
    $('#locations').prepend("<li><pre>"+jsonString+"</pre></li>");
  });
};

$(function(){
  drawMap();
  navigator.geolocation.watchPosition(
    positionUpdated,
    function(error){
      window.alert(error)
    }
  )
});
