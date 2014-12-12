var currentGeohash = '';

function drawMap(){
  var chars = "0123456789bcdefghjkmnpqrstuvwxyz".split('');
  var parentCell;

  //$.each(chars, function(idx,gpChar){
  //  $('#grid').append('<div id="gh-'+gpChar+'" class="gh-'+gpChar+'--"></div>');
  //  $.each(chars, function(idx,parentChar){
  //    $('#gh-'+gpChar).append('<div id="gh-'+gpChar+parentChar+'" class="gh-'+parentChar+'-"></div>');
  //    $.each(chars, function(idx,kidChar){
  //      $('#gh-'+gpChar+parentChar).append('<div id="gh-'+gpChar+parentChar+kidChar+'" class="gh black gh-'+kidChar+'"></div>');
  //    });
  //    //$('#map').append('<div class="ocean-gray geohash-'+c+'"></div>');
  //  });
  //});
};

function positionAcquired(position){
  positionUpdated(position);
  setTimeout(function(){
    $('.gh-active')[0].scrollIntoView(true);
  }, 200);
}

function positionUpdated(position){
  var lat = position.coords.latitude,
    lng = position.coords.longitude,
    accuracy = position.coords.accuracy,
    full_geohash = window.geohash.encode(lat, lng),
    sub_geohash = full_geohash.substr(0,8);

  if (currentGeohash == sub_geohash) {
    return;
  };

  currentGeohash = sub_geohash;

  $('#acc').html(accuracy);
  $('#geohash').html(sub_geohash);

  $('#grid .gh-active')
    .removeClass('gh-active ocean')
    .addClass('ocean-gray');

  var displayed_hash = sub_geohash.substr(sub_geohash.length-3);

  var ancestors = '';
  var parentCell;
  $.each(displayed_hash.split(''), function(idx,currentChar){
    parentCell = (ancestors.length == 0) ? $('#grid') : $('#gh-'+ancestors);;
    ancestors += currentChar;

    var domId = 'gh-'+ancestors;
    var dashes = Array(3-idx).join('-'); // lol
    var cssClass = 'gh-'+currentChar+dashes;

    if ($(domId).length == 0) {
      parentCell.append('<div id="'+domId+'" class="'+cssClass+'"></div>');
    }
  });

  $('#gh-'+ancestors)
    .removeClass('black ocean-gray')
    .addClass('gh-active ocean');

  //$(ghid)[0].scrollIntoView(true);
  console.log('accuracy:', accuracy);
  console.log('geohash:', sub_geohash);

  $.post('/scans?geohash='+sub_geohash+'&accuracy='+accuracy);
};

$(function(){
  drawMap();
  navigator.geolocation.getAccurateCurrentPosition(
    positionAcquired,
    function(err){console.log(err);},
    positionUpdated
  );
  navigator.geolocation.watchPosition(
    positionUpdated,
    function(error){
      console.log(error);
    },
    { enableHighAccuracy: true }
  )
});
