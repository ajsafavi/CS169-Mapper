var Mapper = (function () {
  // Ratio of Obese (BMI >= 30) in U.S. Adults, CDC 2008
  var valueById = [
     NaN, .187, .198,  NaN, .133, .175, .151,  NaN, .100, .125,
    .171,  NaN, .172, .133,  NaN, .108, .142, .167, .201, .175,
    .159, .169, .177, .141, .163, .117, .182, .153, .195, .189,
    .134, .163, .133, .151, .145, .130, .139, .169, .164, .175,
    .135, .152, .169,  NaN, .132, .167, .139, .184, .159, .140,
    .146, .157,  NaN, .139, .183, .160, .143
  ];

  var path = d3.geo.path();

  var svg = d3.select("body").append("svg")
      .attr("width", 960)
      .attr("height", 500);

  var start = function() {
    
    d3.json("/scripts/us.json", function(error, us) {
    if (error) throw error;

    svg.append("path")
        .datum(topojson.feature(us, us.objects.land))
        .attr("class", "land")
        .attr("d", path);

    svg.selectAll(".state")
        .data(topojson.feature(us, us.objects.states).features)
      .enter().append("path")
        .attr("class", "state")
        .attr("d", path)
        .style("fill", function(d) {
          return '#'+((valueById[d.id])*5*0xFF<<0).toString(16)+ //red
          ((valueById[d.id])*0xFF<<0).toString(16) + //green
          ((valueById[d.id])*0xFF<<0).toString(16); //blue
        });
    });
  };

  // PUBLIC METHODS
  // any private methods returned in the hash are accessible via Smile.key_name, e.g. Smile.start()
  return {
    start: start
  };
})();