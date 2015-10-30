QUnit.test( "hello test", function( assert ) {
  assert.ok( 1 == "1", "Passed!" );
});
QUnit.test( "processed test", function( assert ) {
  var sampleData = {"points":[{"location":"44007","display_val":"1","filter_val":"23","weight":2349}],
	  "num_points":1,
	  "location_type":"COUNTYFIPS"};
  var correctData = [{"location": "44007", "value":1}];
  var processed = Mapper.processPoints(sampleData);
  //console.log(processed);
  assert.deepEqual(processed, correctData , "Make sure process points puts out the correct amount of points");

});
QUnit.test( "2 location codes", function( assert ) {
  var sampleData = {"points":[{"location":"44007","display_val":"1","filter_val":"23","weight":2349},
  	  {"location":"44008","display_val":"1","filter_val":"18","weight":9150}],
	  "num_points":2,
	  "location_type":"COUNTYFIPS"};
  
  var processed = Mapper.processPoints(sampleData);
  //console.log(processed);
  assert.deepEqual(processed.length, 2, "Test with 2 counties different locations");

});
QUnit.test( "2 location codes", function( assert ) {
  
  var env = Mapper.getEnvironment();
  //console.log(processed);
  assert.equal(env, "development", "determine environment");

});