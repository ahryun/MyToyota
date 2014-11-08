var userInfoURI = "https://api-jp-t-itc.com/GetUserInfo";
var vehicleModelListURI = "https://api-jp-t-itc.com/GetVehicleModelList";
var vehicleSpecURI = "https://api-jp-t-itc.com/GetVehicleSpec";
var vehicleInfoURI = "https://api-jp-t-itc.com/GetVehicleInfo";
var mapMatchingVehicleInfoURI = "https://api-jp-t-itc.com/GetVehicleInfoMM";
var statisticsURI = "https://api-jp-t-itc.com/GetStatisticsInfo";
var developerKey = '3552b02ecebf';

Parse.Cloud.define("startJourney", function(request, response) {
  return Parse.Cloud.httpRequest({
        method: 'POST',
        url: vehicleInfoURI,
        params: {
            developerkey    : developerKey,
            responseformat  : 'json',
            vid             : request.vid,
        },
        headers: {
            'Content-Type': 'application/json;charset=utf-8',
        },
        success: function(httpResponse) {
            var query = new Parse.Query(Parse.User);
            query.get(request.uid, {
                success: function(user) {
                    // The object was retrieved successfully.
                    var Trip = Parse.Object.extend("Trip");
                    var trip = new Trip();
                    trip.set();
                    user.set();
                },
                error: function(object, error) {
                    // The object was not retrieved successfully.
                    // error is a Parse.Error with an error code and message.
                }
            });
            response.success('Successfully retrieved: ' + httpResponse);
        },
        error: function(error) {
            response.error("Something went wrong in query.... <<<< " + error);
        },
  });
});
