QUnit.test( "hello test", function( assert ) {
  assert.ok( 1 == "1", "Passed!" );
});
QUnit.test( "processed test", function( assert ) {
  var sampleData = {"points":[{"location":"44007","display_val":"1","filter_val":"23","weight":2349}],
	  "num_points":1,
	  "location_type":"COUNTYFIPS"};
  var correctData = [{"location": "44007", "value":1}];
  var processed = Mapper.processPoints(sampleData);
  assert.equal(processed, correctData , "passed");

});