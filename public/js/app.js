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
    full_geohash = window.geohash.encode(lat, lng),
    sub_geohash = '';

  $('#map div').removeClass('ocean').addClass('ocean-gray');

  if (accuracy < 20) {
    sub_geohash = full_geohash.substr(0,8);
    $('#map').addClass('vertical');
  } else {
    sub_geohash = full_geohash.substr(0,7);
    $('#map').removeClass('vertical');
  }

  $('#map .geohash-'+sub_geohash[sub_geohash.length-1]).removeClass('ocean-gray').addClass('ocean');

  //console.log('latitude:', lat);
  //console.log('longitude:', lng);
  console.log('accuracy:', accuracy);
  console.log('geohash:', sub_geohash);

  //$('#lat').html(lat);
  //$('#lng').html(lng);
  //$('#acc').html(accuracy);
  //$('#geohash').html(geohash);

  $.get('/scan/'+sub_geohash).done(function(data){
    console.log(data);
    //$('#map div').removeClass('ocean').addClass('ocean-gray');
    //$('#map .geohash-'+geohash[7]).removeClass('ocean-gray').addClass('ocean');
    //$('#pings').prepend("<li>"+data+"</li>");
  });

  //$.getJSON('/geocells/'+geohash).done(function(data){
  //  var jsonString = JSON.stringify(data, null, 4);
  //  $('#locations').prepend("<li><pre>"+jsonString+"</pre></li>");
  //});
};

$(function(){
  drawMap();
  navigator.geolocation.getAccurateCurrentPosition(
    positionUpdated,
    function(err){console.log(err);},
    positionUpdated
  );
  navigator.geolocation.watchPosition(
    positionUpdated,
    function(error){
      console.log(error);
    },
    { maximimAge: 0, enableHighAccuracy: true }
  )
});
