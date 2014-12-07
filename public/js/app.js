document.querySelector('x-geolocation').addEventListener('positionchange', function (e) {
  var lat = e.detail.latitude,
      lng = e.detail.longitude,
      geohash = encodeGeoHash(lat, lng);

  console.log('latitude:', lat);
  console.log('longitude:', lng);
  console.log('geohash:', geohash);

  $('#lat').html(lat);
  $('#lng').html(lng);
  $('#geohash').html(geohash);

  $.get('/ping/'+geohash).done(function(data){
    console.log(data);
    $('#pings').prepend("<li>"+data+"</li>");
  });

  $.getJSON('/geocells/'+geohash).done(function(data){
    var jsonString = JSON.stringify(data, null, 4);

    $('#locations').prepend("<li><pre>"+jsonString+"</pre></li>");
  });
});
