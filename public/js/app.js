var currentGeohash = '';

function drawMap(){
  var chars = "0123456789bcdefghjkmnpqrstuvwxyz".split('');
  var parentCell;

  $.each(chars, function(idx,parentChar){
    $('#grid').append('<div id="gh-'+parentChar+'" class="gh-'+parentChar+'-"></div>');
    $.each(chars, function(idx,kidChar){
      $('#gh-'+parentChar).append('<div id="gh-'+parentChar+kidChar+'" class="gh black gh-'+kidChar+'"></div>');
    });
    //$('#map').append('<div class="ocean-gray geohash-'+c+'"></div>');
  });
};

function positionUpdated(position){
  var lat = position.coords.latitude,
    lng = position.coords.longitude,
    accuracy = position.coords.accuracy,
    full_geohash = window.geohash.encode(lat, lng),
    sub_geohash = '';

  if (true || accuracy < 20) {
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

  $('#grid .ocean').removeClass('ocean').addClass('ocean-gray');

  $('#gh-'+sub_geohash.substr(sub_geohash.length-2))
    .removeClass('black')
    .removeClass('ocean-gray')
    .addClass('ocean');

  console.log('accuracy:', accuracy);
  console.log('geohash:', sub_geohash);

  $.post('/scans?geohash='+sub_geohash+'&accuracy='+accuracy);
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
