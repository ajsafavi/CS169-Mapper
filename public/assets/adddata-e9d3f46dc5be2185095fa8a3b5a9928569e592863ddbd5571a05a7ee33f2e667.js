var AddData = (function () {

  //wait for change and determine if valid file
  $(".fileSelect").onchange = function(e) 
  { 
    var path = $(".fileSelect").value;

  };
  

  var validFile = function(path) 
  {
    if (path.split('.').pop() != 'csv')
    {
      return false;
    }
    return true;
  }

  //location column always 1 (for now)
  //weight column always 2 (for now)
  var createDataSet = function(path)
  {
    $.ajax({
        type: "POST",
        url: "/datasets",
        owner: 1, //how do I get the owner in javascript?
        name: $(".datasetname").value,
        datafile: $(".fileSelect").value,
        location_column: 1, //hardcoded i'll change it
        weight_column: 2,
        success: function(data) {dataSetCreated(data);}
     });
  }

  //return the json that is submitted to the backend to create a dataset
  var uploadCSV = function(path)
  {
    var lines = [];
    $.ajax({
        type: "GET",
        url: path,
        dataType: "text",
        success: function(data) {processData(data);}
     });

    function processData(allText) 
    {
      var record_num = 5;  // or however many elements there are in each row
      var allTextLines = allText.split(/\r\n|\n/);
      var entries = allTextLines[0].split(',');
      //var lines = [];

      var headings = entries.splice(0,record_num);
      while (entries.length>0) {
          var tarr = [];
          for (var j=0; j<record_num; j++) {
              tarr.push(headings[j]+":"+entries.shift());
          }
          lines.push(tarr);
      }
    }
    return lines;
    // PUBLIC METHODS
    // any private methods returned in the hash are accessible via Smile.key_name, e.g. Smile.start()
  return {
    validFile:validFile
    createJSON:createJSON

  };
})();

