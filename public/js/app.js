var currentGeohash = '';

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
    $('#pings').prepend("<li>"+data+"</li>");
  });

  $.getJSON('/geocells/'+geohash).done(function(data){
    var jsonString = JSON.stringify(data, null, 4);
    $('#locations').prepend("<li><pre>"+jsonString+"</pre></li>");
  });
};

$(function(){
  navigator.geolocation.watchPosition(
    positionUpdated,
    function(error){
      window.alert(error)
    }
  )
});
