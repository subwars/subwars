var currentGeohash = '';
var mapInterval;
var displayedLength = 2;
var refreshSeconds = 5;

function drawMap(){
  if ('' == currentGeohash) return;

  var chars = "0123456789bcdefghjkmnpqrstuvwxyz".split('');

  //$('.gh-cell').removeClass('ocean-gray ocean');

  $.get('/map?geohash='+currentGeohash, function(data){
    var changes = [];
    $.each(data, function(idx, cell){
      var geohash = cell[0];
      var bgClass = cell[1];
      var icons = cell[2];
      displayGeohash(geohash, bgClass);
      $.each(icons, function(idx, icon){
        var displayedHash = geohash.substr(geohash.length-displayedLength);
        var domID = '#gh-'+displayedHash;
        changes.push([domID, icon]);
      });
    });

    $('.gh-cell div').remove();
    $.each(changes, function(idx, change){
      $(change[0]).append('<div class="'+change[1]+'"></div>');
    });
  })
};

function scrollToPosition() {
  $('.gh-active')[0].scrollIntoView(true);
}

function positionAcquired(position){
  positionUpdated(position);
  setTimeout(scrollToPosition, 200);
}

function displayGeohash(subGeohash, cssClass, removeClass) {
  var displayedHash = subGeohash.substr(subGeohash.length-displayedLength);
  var parentCell;

  var ancestors = '';

  var domId;
  //var domId = 'gh-'+displayedHash;
  //if ($('#'+domId).length == 0) {
  //  $('#grid').append('<div id="'+domId+'" class="'+domId+'"></div>');
  //}

  $.each(displayedHash.split(''), function(idx,currentChar){
    parentCell = (ancestors.length == 0) ? $('#grid') : $('#gh-'+ancestors);;
    ancestors += currentChar;

    domId = 'gh-'+ancestors;
    var dashes = Array(displayedLength-idx).join('-'); // lol
    var cssClass = 'gh-'+currentChar+dashes;

    if (dashes.length == 0) {
      cssClass = 'gh-cell ' + cssClass;
    }

    if ($('#'+domId).length == 0) {
      parentCell.append('<div id="'+domId+'" class="'+cssClass+'" data-geohash="'+subGeohash+'"></div>');
    }
  });

  if (typeof removeClass != 'undefined') {
    $('#'+domId).removeClass(removeClass);
  }
  $('#'+domId).addClass(cssClass);
}

function positionUpdated(position){
  var lat = position.coords.latitude,
    lng = position.coords.longitude,
    accuracy = position.coords.accuracy,
    full_geohash = window.geohash.encode(lat, lng),
    sub_geohash = full_geohash.substr(0,9);

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


  var displayed_hash = sub_geohash.substr(sub_geohash.length-displayedLength);

  displayGeohash(sub_geohash, 'gh-active ocean', 'black ocean-gray');

  //$('#grid .gh-active').append('<div class="submarine-self"></div>');

  console.log('accuracy:', accuracy);
  console.log('geohash:', sub_geohash);

  $.post('/scans?geohash='+sub_geohash+'&accuracy='+accuracy);

  drawMap();
};

$(function(){
  mapInterval = setInterval(drawMap, refreshSeconds * 1000);

  $('#grid').on('click', '.gh-cell', function(){
    $.post('/move?geohash='+$(this).data('geohash'));
  });

  $('#grid').click(function(){
    scrollToPosition();
  });
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
