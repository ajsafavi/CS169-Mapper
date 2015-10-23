var Mapper = (function () {

  var apiUrl = 'localhost:3000/datasets/1/points?num_points=20000&filter_val=AGE&display_val=EMPLOYMENT'
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
    var currCounty = data.points[0].location;
    var currSum = 0;
    var nextCounty;
    var avg;
    var totalWeight = 0;
    var nextWeight;
    var nextDisplay;
    var newData = []

    for (var i = 0; i < data.points.length; i++) {
      totalWeight += data.points[i].weight * parseInt(data.points[i].display_val);
    }

    for (var i = 0; i < data.points.length; i++) {
      nextCounty = data.points[i].location;
      nextWeight = data.points[i].weight * parseInt(data.points[i].display_val);
      if (currCounty != nextCounty) {
        avg = currSum / totalWeight;
        newData.push({location: currCounty, value: avg})
        currCounty = nextCounty;
        currSum = nextWeight * parseInt(data.points[i].display_val);
      } else {
        currSum += nextWeight;
      }
    }

    return newData
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
        rateById.set(dataPoints[i].location, dataPoints[i].value);
      }

      queue()
          .defer(d3.json, "/scripts/us.json")
          .await(ready);

      function ready(error, us) {
        if (error) throw error;

        svg.append("g")
            .attr("class", "counties")
          .selectAll("path")
            .data(topojson.feature(us, us.objects.counties).features)
          .enter().append("path")
            .attr("class", function(d) { return quantize(rateById.get(d.id)); })
            .attr("d", path);

        svg.append("path")
            .datum(topojson.mesh(us, us.objects.counties, function(a, b) { return a == b || a !== b; }))
            .attr("class", "counties")
            .attr("d", path);

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
    makeGetRequest('/scripts/points.json', onSuccess, onFailure);


  };

  // PUBLIC METHODS
  // any private methods returned in the hash are accessible via Smile.key_name, e.g. Smile.start()
  return {
    start: start
  };
})();

