var url = "http://localhost:3000/users/1"

function callback (status, data) {
	console.log(status)
	console.log(data)
}

$.ajax({
   url: url,
   success: callback,
   xhrFields: {
      withCredentials: true
   }
});
