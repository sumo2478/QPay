# QPay

Request for creating item:
Endpoint: https://api.parse.com/1/functions/create
Params: 
title - The title of the item
description - The description of the item
amount[int] - The price of the item
username - The venmo username for the money to be sent to
email - The email to which the qr code will be sent to
password - The password for viewing the page

curl -X POST   -H "X-Parse-Application-Id: X8Un7SuZ4L9O23ouSltZGMyldLlzRQxqxtbZVVLc"   -H "X-Parse-REST-API-Key: xcWVe8K7Q9fpiybqkK52uOiYJ24SlwedCgyTPJsN"   -H "Content-Type: application/json"   -d '{"title":"The Matrix", "description":"this is the description", "amount":32, "username":"sumo", "email":"collinyen7@gmail.com", "password": "pass"}'   https://api.parse.com/1/functions/create

Request for retrieving item:
Endpoint: https://api.parse.com/1/functions/retrieve
Params:
id: The item id

curl -X POST   -H "X-Parse-Application-Id: X8Un7SuZ4L9O23ouSltZGMyldLlzRQxqxtbZVVLc"   -H "X-Parse-REST-API-Key: xcWVe8K7Q9fpiybqkK52uOiYJ24SlwedCgyTPJsN"   -H "Content-Type: application/json"   -d '{"id": "C2PJBIlwdf"}'   https://api.parse.com/1/functions/retrieve
