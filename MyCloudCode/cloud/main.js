var userInfoURI = "https://api-jp-t-itc.com/GetUserInfo"
var vehicleModelListURI = "https://api-jp-t-itc.com/GetVehicleModelList"
var vehicleSpecURI = "https://api-jp-t-itc.com/GetVehicleSpec"
var vehicleInfoURI = "https://api-jp-t-itc.com/GetVehicleInfo"
var mapMatchingVehicleInfoURI = "https://api-jp-t-itc.com/GetVehicleInfoMM"
var statisticsURI = "https://api-jp-t-itc.com/GetStatisticsInfo"

Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});
