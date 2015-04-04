
/* Create Item Function */
Parse.Cloud.define("create", function(request, response) {
	var title = request.params.title;
	var description = request.params.description;
	var amount = request.params.amount;
	var username = request.params.username;	
	var email = request.params.email;
	var password = request.params.password;

	var Item = Parse.Object.extend("items");
	var newItem = new Item();

	newItem.set("title", title);
	newItem.set("description", description);
	newItem.set("amount", Number(amount));
	newItem.set("vusername", username);
	newItem.set("email", email);
	newItem.set("password", password);

	newItem.save(null, {
		success: function(item) {
			response.success(item.id);
		},
		error: function(item, error) {
			response.error("Failed to create new item with error: " + error.message);
		}
	});
});

/* Display Item Function */
Parse.Cloud.define("retrieve", function(request, response) {
	var itemId = request.params.id;

	var Item = Parse.Object.extend("items");
	var query = new Parse.Query(Item);
	query.get(itemId, {
		success: function(item) {
			// The object was retrieved successfully
			var responseObject = {item: item};
			/*var urlBase = "https://chart.googleapis.com/chart?";
			var qrCodeUrl = encodeURIComponent("cht=qr&chs=400x400&chl=" + itemId);
			responseObject['qr'] = urlBase + qrCodeUrl;*/
			response.success(responseObject);
		},
		error: function(object, error) {
			// The object failed to retrieve
			response.error("Unable to retrieve item with this id");
		}
	});
});

