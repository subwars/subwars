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

  if (accuracy < 20) {
    sub_geohash = full_geohash.substr(0,8);
    $('#map').addClass('vertical');
  } else {
    sub_geohash = full_geohash.substr(0,7);
    $('#map').removeClass('vertical');
  }

  if (currentGeohash == sub_geohash) {
    return;
  };

  currentGeohash = sub_geohash;

  $('#acc').html(accuracy);
  $('#geohash').html(sub_geohash);

  $('#map div').removeClass('ocean').addClass('ocean-gray');
  $('#map .geohash-'+sub_geohash[sub_geohash.length-1]).removeClass('ocean-gray').addClass('ocean');

  console.log('accuracy:', accuracy);
  console.log('geohash:', sub_geohash);

  $.get('/scan/'+sub_geohash)
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
