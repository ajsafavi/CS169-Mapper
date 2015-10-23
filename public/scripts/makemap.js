var Mapper = (function () {

  var apiUrl = 'localhost:3000/datasets/1/points?num_points=20000';
  var url = window.location.href;//tony use this to get the local url

  var varList = ["Employment","Income","Labor Participation","Sex","Age"];

  var displayval;
  var filterval;


  
  /**
    * HTTP GET request 
    * @param  {string}   url       URL path, e.g. "/api/smiles"
    * @param  {function} onSuccess   callback method to execute upon request success (200 status)
    * @param  {function} onFailure   callback method to execute upon request failure (non-200 status)
    * @return {None}
    */
  var makeGetRequest = function(url, onSuccess, onFailure) {
    $.ajax({
      type: 'GET',
      url: url,
      dataType: "json",
      success: onSuccess,
      error: onFailure
    });
  };

  var processPoints = function(data) {
    var points = data.points; //data points
    var avgs = []; //associative arry of averages. keys are location codes and values is weighted sum of each location
    var totalWeights = []; //associative array of total weights. keys are location codes and values are total weight of each location

    for (var i=0;i<points.length;i++) { //iterate through data points
      var point = points[i]; //the i-th point
      var loc = point.location; //location code of point
      if (avgs[loc] == undefined) { //if we haven't seen this location yet, add it to our arrays
        avgs[loc] = 0;
        totalWeights[loc] = 0;
      }
      avgs[loc] += point.weight * point.display_val; //increment this location's weighted sum
      totalWeights[loc] += point.weight; //increment this location's total weight
    }

    newData = [];
    for (loc in avgs) { //for each location encountered, add {location, weighted average} to newData
      newData.push({location: loc, value: avgs[loc]/totalWeights[loc]});
    }

    return newData
  }

  var startAutocomplete = function() {
    $("#idvar").autocomplete({source: varList});
    $("#idfilteringvar").autocomplete({source: varList});
  }

  var submitClickHandler = function() {
      $( "body" ).on( "click", "#idsubmit", function() {
        displayval = $("#idvar").val();
        filterval = $("#idfilteringvar").val();
        apiUrl += '&filter_val='+filterval + '&display_val='+displayval;
        
        $("div#canvas").html('');
        $("div#secondContainer").removeClass('hidden');
        $("div#firstContainer").addClass('hidden');

        $("div#idnavcontainer").append($( "#idvar" ));
        $("div#idnavcontainer").append($( "#idfilteringvar" ));
        $("div#idnavcontainer").append($( "#idrange" ));
        $("div#idnavcontainer").append($( "#idgeo" ));
        $("div#idnavcontainer").append($( "#idsubmit" ));

        $( "#idvar" ).removeClass('col-xs-offset-4 col-xs-4 firstDisplay');
        $( "#idfilteringvar" ).removeClass('col-xs-offset-4 col-xs-4 firstDisplay');
        $( "#idrange" ).removeClass('col-xs-offset-4 col-xs-4 firstDisplay').css({
            display: "inline",
            width: "15%"
        });

        $( "#idgeo" ).removeClass('col-xs-offset-4 col-xs-4 firstDisplay');
        $( "#idsubmit" ).removeClass('col-xs-offset-4 col-xs-4 firstDisplay');
        start();

    });
  }

  var start = function() {
    
    var onSuccess = function(data) {
      var dataPoints = processPoints(data);

      var width = 870,
          height = 505;

      var rateById = d3.map();

      var quantize = d3.scale.quantize()
          .domain([0, Math.max.apply(Math,dataPoints.map(function(o) {return o.value;}))])
          .range(d3.range(9).map(function(i) { return "q" + i + "-9"; }));

      var projection = d3.geo.albersUsa()
          .scale(900)
          .translate([width / 2, height / 2]);

      var path = d3.geo.path()
          .projection(projection);

      var svg = d3.select("#canvas").append("svg")
          .attr("width", width)
          .attr("height", height);

      for (var i = 0; i < dataPoints.length; i++) {
        var location = parseInt(dataPoints[i].location) / 1000
        rateById.set(location, dataPoints[i].value);
      }

      queue()
          .defer(d3.json, "/scripts/us.json")
          .await(ready);

      function ready(error, us) {
        if (error) throw error;

        svg.append("g")
            .attr("class", "states")
          .selectAll("path")
            .data(topojson.feature(us, us.objects.states).features)
          .enter().append("path")
            .attr("class", function(d) { return quantize(rateById.get(d.id)); })
            .attr("d", path);

        // svg.append("path")
        //     .datum(topojson.mesh(us, us.objects.counties, function(a, b) { return a == b || a !== b; }))
        //     .attr("class", "counties")
        //     .attr("d", path);

        svg.append("path")
            .datum(topojson.mesh(us, us.objects.states, function(a, b) { return a == b || a !== b; }))
            .attr("class", "states")
            .attr("d", path);
      }

      d3.select(self.frameElement).style("height", height + "px");
    };
    var onFailure = function() { 
      console.error('fail'); 
    }
    makeGetRequest('/scripts/points2.json', onSuccess, onFailure);


  };

  // PUBLIC METHODS
  // any private methods returned in the hash are accessible via Smile.key_name, e.g. Smile.start()
  return {
    start: start,
    processPoints: processPoints,
    submitClickHandler: submitClickHandler,
    startAutocomplete: startAutocomplete
  };
})();

