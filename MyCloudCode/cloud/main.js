var userInfoURI = "https://api-jp-t-itc.com/GetUserInfo"
var vehicleModelListURI = "https://api-jp-t-itc.com/GetVehicleModelList"
var vehicleSpecURI = "https://api-jp-t-itc.com/GetVehicleSpec"
var vehicleInfoURI = "https://api-jp-t-itc.com/GetVehicleInfo"
var mapMatchingVehicleInfoURI = "https://api-jp-t-itc.com/GetVehicleInfoMM"
var statisticsURI = "https://api-jp-t-itc.com/GetStatisticsInfo"

Parse.Cloud.define("getOdometerReadingInMile", function(request, response) {
  return Parse.Cloud.httpRequest({
        method: 'POST',
        url: 'https://api-jp-t-itc.com/GetVehicleInfo',
        params: {
            developerkey    : '3552b02ecebf',
            responseformat  : 'json',
            vid             : request.vid,
        },
        headers: {
            'Content-Type': 'application/json;charset=utf-8',
        },
        success: function(httpResponse) {
            response.success('Successfully retrieved: ' + httpResponse);
        },
        error: function(error) {
            response.error("Something went wrong in query.... <<<< " + error);
        },
  });
});
