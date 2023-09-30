<div class="form-group {!! !$errors->has($label) ?: 'has-error' !!}">

    <label for="{{$id}}" class="col-sm-2 control-label">Coordinates</label>

    <div class="{{$viewClass['field']}}">

          <div class="col-sm-12 input-group" style="margin-bottom: 15px">
              <input id="coordinates" class="form-control" type="text" name="coordinates" value="{{$value}}"/>
          </div>
        <div class="col-sm-12 input-group" style="height: 400px;">
 <input id="pac-input" class="form-control rounded" style="height: 3em;width:fit-content;" title="search_your_location_here" type="text" placeholder="search_here"/>
            <div id="map-canvas" style="height: 400px; margin:0px; padding: 0px;"></div>
        </div>

    </div>
</div>

<script>
    (function() {
        var lastpolygon = null;
        var polygons = [];

        function resetMap(controlDiv) {
            // Set CSS for the control border.
            const controlUI = document.createElement("div");
            controlUI.style.backgroundColor = "#fff";
            controlUI.style.border = "2px solid #fff";
            controlUI.style.borderRadius = "3px";
            controlUI.style.boxShadow = "0 2px 6px rgba(0,0,0,.3)";
            controlUI.style.cursor = "pointer";
            controlUI.style.marginTop = "8px";
            controlUI.style.marginBottom = "22px";
            controlUI.style.textAlign = "center";
            controlUI.title = "Reset map";
            controlDiv.appendChild(controlUI);
            // Set CSS for the control interior.
            const controlText = document.createElement("div");
            controlText.style.color = "rgb(25,25,25)";
            controlText.style.fontFamily = "Roboto,Arial,sans-serif";
            controlText.style.fontSize = "10px";
            controlText.style.lineHeight = "16px";
            controlText.style.paddingLeft = "2px";
            controlText.style.paddingRight = "2px";
            controlText.innerHTML = "X";
            controlUI.appendChild(controlText);
            // Setup the click event listeners: simply set the map to Chicago.
            controlUI.addEventListener("click", () => {
                lastpolygon.setMap(null);
                $('#coordinates').val('');

            });
        }
        function init() {
            var LatLng = new google.maps.LatLng(39.78079303056475, 115.76750330761728);
            var options = {
                zoom: 13,
                center: LatLng,
                panControl: false,
                zoomControl: true,
                scaleControl: true,
                mapTypeId: google.maps.MapTypeId.ROADMAP
        }

            var container = document.getElementById("map-canvas");
            var map = new google.maps.Map(container, options);
            var drawingManager = new google.maps.drawing.DrawingManager({
                drawingMode: google.maps.drawing.OverlayType.POLYGON,
                drawingControl: true,
                drawingControlOptions: {
                    position: google.maps.ControlPosition.TOP_CENTER,
                    drawingModes: [google.maps.drawing.OverlayType.POLYGON]
                },
                polygonOptions: {
                    editable: true
                }
            });
            drawingManager.setMap(map);

            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(function(position) {
                    // var pos = {
                    //     lat: position.coords.latitude,
                    //     lng: position.coords.longitude
                    // };
                    // map.setCenter(pos);
                    // marker.setPosition(pos);

                }, function() {

                });
            }

            google.maps.event.addListener(drawingManager, "overlaycomplete", function(event) {

                $('#coordinates').val(event.overlay.getPath().getArray());
             //   lastpolygon = event.overlay;
              //  console.log(event)
                if(lastpolygon)
                {
                    lastpolygon.setMap(null);
                }
                lastpolygon = event.overlay;

            });

            const resetDiv = document.createElement("div");
            resetMap(resetDiv, lastpolygon);
            map.controls[google.maps.ControlPosition.TOP_CENTER].push(resetDiv);

            var marker = new google.maps.Marker({
                position: LatLng,
                map: map,
                title: 'Drag Me!',
                draggable: true
            });

            google.maps.event.addListener(marker, "position_changed", function(event) {
                var position = marker.getPosition();
            });

            google.maps.event.addListener(map, 'click', function(event) {
                marker.setPosition(event.latLng);
            });

            var autocomplete = new google.maps.places.Autocomplete(
              //  document.getElementById("search-{$id['lat']}{$id['lng']}")
            );
            autocomplete.bindTo('bounds', map);

            google.maps.event.addListener(autocomplete, 'place_changed', function() {
                var place = autocomplete.getPlace();
                var location = place.geometry.location;

                if (place.geometry.viewport) {
                    map.fitBounds(place.geometry.viewport);
                } else {
                    map.setCenter(location);
                    map.setZoom(18);
                }

                marker.setPosition(location);

            });

           var coordinates_path = $('#coordinates').val();
           if(coordinates_path){

           coordinates_path = coordinates_path.split('\)\,\(');
        // coordinates_path = "["+coordinates_path+"]";
           console.log(coordinates_path);
            var path = [];
            for (var i in coordinates_path) {
                var strpath = coordinates_path[i].replace('(', '');
                 strpath = strpath.replace(')', '');
                 var arrpath = strpath.split(',');
                path[i]= new google.maps.LatLng(arrpath[0],arrpath[1]);
                if(i==0){
                    // var pos = {
                    //     lat: position.coords.latitude,
                    //     lng: position.coords.longitude
                    // };
                    map.setCenter(new google.maps.LatLng(arrpath[0],arrpath[1]));
                    marker.setPosition(new google.maps.LatLng(arrpath[0],arrpath[1]));
                }

             //   console.log(strpath);
            }
            console.log(path);
            var polygonOptions = {
                paths:  path,
                strokeColor: "#FF0000",
                strokeOpacity: 0.8,
                strokeWeight: 2,
                fillColor: "#FF0000",
                fillOpacity: 0.1,
            };
            lastpolygon = new google.maps.Polygon(polygonOptions);
            lastpolygon.setMap(map);

           }
// Create the search box and link it to the UI element.
            const input = document.getElementById("pac-input");
            const searchBox = new google.maps.places.SearchBox(input);
            map.controls[google.maps.ControlPosition.TOP_CENTER].push(input);
            // Bias the SearchBox results towards current map's viewport.
            map.addListener("bounds_changed", () => {
                searchBox.setBounds(map.getBounds());
            });
            let markers = [];
            // Listen for the event fired when the user selects a prediction and retrieve
            // more details for that place.
            searchBox.addListener("places_changed", () => {
                const places = searchBox.getPlaces();

                if (places.length == 0) {
                    return;
                }
                // Clear out the old markers.
                markers.forEach((marker) => {
                    marker.setMap(null);
                });
                markers = [];
                // For each place, get the icon, name and location.
                const bounds = new google.maps.LatLngBounds();
                places.forEach((place) => {
                    if (!place.geometry || !place.geometry.location) {
                        console.log("Returned place contains no geometry");
                        return;
                    }
                    const icon = {
                        url: place.icon,
                        size: new google.maps.Size(71, 71),
                        origin: new google.maps.Point(0, 0),
                        anchor: new google.maps.Point(17, 34),
                        scaledSize: new google.maps.Size(25, 25),
                    };
                    // Create a marker for each place.
                    markers.push(
                        new google.maps.Marker({
                            map,
                            icon,
                            title: place.name,
                            position: place.geometry.location,
                        })
                    );

                    if (place.geometry.viewport) {
                        // Only geocodes have viewport.
                        bounds.union(place.geometry.viewport);
                    } else {
                        bounds.extend(place.geometry.location);
                    }
                });
                map.fitBounds(bounds);
            });



        }



        init();

    })();

  $(document).keydown(function(event){
        switch(event.keyCode){
            case 13:return false;
        }
    });
</script>
