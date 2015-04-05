
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

	var formattedUsername = username;
	if (username.charAt(0) == '@') {
		formattedUsername = formattedUsername.substr(1);
	}

	newItem.set("title", title);
	newItem.set("description", description);
	newItem.set("amount", Number(amount));
	newItem.set("vusername", formattedUsername);
	newItem.set("email", email);
	newItem.set("password", password);

	newItem.save(null, {
		success: function(item) {	
			var itemLink = "http://www.google.com?code=" + item.id; 
			//sendEmail(email, itemLink);
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
	var promises = [];

	var Item = Parse.Object.extend("items");
	var queryItem = new Parse.Query(Item);
	promises.push(queryItem.get(itemId, {
		success: function (item) {
			return item;
		},
		error: function(object, error) {
			return null;
		}
	}));

	var Payments = Parse.Object.extend("payments");
	var queryPayments = new Parse.Query(Payments);
	queryPayments.equalTo("itemId", itemId);
	promises.push(queryPayments.find({
		success: function (payments) {
			return payments;
		},
		error: function(object, error) {
			return null;
		}
	}));

	Parse.Promise.when(promises).then(
		function(itemData, payments) {
			if (!itemData || !payments) {
				response.error("Unable to find item with this id");
			}

			var responseObject = {item: itemData, payments: payments};
			response.success(responseObject);
		}
	)
});

// Helper function
function sendEmail(emailToSendTo, link) {
	var sendgrid = require("sendgrid");

	sendgrid.initialize("sumo2478", "nothing2478");
	sendgrid.sendEmail({
		to:[emailToSendTo],
		from: "collinyen7@gmail.com",
		subject: "Your new QPay!",
		text: "Use the following link to access your QPay Item Page: " + link,
	});
}

