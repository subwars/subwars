var currentGeohash = '';

function drawMap(){
  var chars = "0123456789bcdefghjkmnpqrstuvwxyz".split('');
  var parentCell;

  $.get('/map', function(data){$.each(data, function(idx, cell){
    var geohash = cell[0];
    var icons = cell[1];
    displayGeohash(geohash, 'ocean-gray');
    $.each(icons, function(idx, icon){
      var domID = '#gh-'+geohash.substr(4);
      $(domID).append('<div class="'+icon+'-normal"></div>');
    });
  })})
};

function scrollToPosition() {
  $('.gh-active')[0].scrollIntoView(true);
}

function positionAcquired(position){
  positionUpdated(position);
  setTimeout(scrollToPosition, 200);
}

function displayGeohash(sub_geohash, cssClass, removeClass) {
  var displayed_hash = sub_geohash.substr(sub_geohash.length-4);

  var ancestors = '';
  var parentCell;
  $.each(displayed_hash.split(''), function(idx,currentChar){
    parentCell = (ancestors.length == 0) ? $('#grid') : $('#gh-'+ancestors);;
    ancestors += currentChar;

    var domId = 'gh-'+ancestors;
    var dashes = Array(4-idx).join('-'); // lol
    var cssClass = 'gh-'+currentChar+dashes;

    if ($('#'+domId).length == 0) {
      parentCell.append('<div id="'+domId+'" class="'+cssClass+'"></div>');
    }
  });

  if (typeof removeClass != 'undefined') {
    $('#gh-'+ancestors).removeClass(removeClass);
  }
  $('#gh-'+ancestors).addClass(cssClass);
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

  $('#grid .gh-active .submarine-self').remove();

  $('#grid .gh-active')
    .removeClass('gh-active ocean')
    .addClass('ocean-gray');


  var displayed_hash = sub_geohash.substr(sub_geohash.length-4);

  displayGeohash(sub_geohash, 'gh-active ocean', 'black ocean-gray');

  $('#grid .gh-active').append('<div class="submarine-self"></div>');

  console.log('accuracy:', accuracy);
  console.log('geohash:', sub_geohash);

  $.post('/scans?geohash='+sub_geohash+'&accuracy='+accuracy);
};

$(function(){
  $('#grid').click(function(){
    scrollToPosition();
  });
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
