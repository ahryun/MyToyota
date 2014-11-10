var ToyotaAPI = require('cloud/ToyotaAPI.js');
var Utils = require('cloud/utils.js');
var Trip  = require('cloud/trip.js');

Parse.Cloud.define('getUpdatedCarInfo', function(request, response) {
    var vid = request.params.vid;
    ToyotaAPI.getCarFromVID(vid).then(function(car) {
        console.log('Success in getUpdatedCarInfo.');
        console.log('Got car: ' + car.get('vid') + ' -- ' + car.get('currentMiles') + ' mi.');
        response.success(car);
    },
    function(error) {
        console.log('Error in getUpdatedCarInfo.');
        response.error(Utils.logError(error));
    });
});

Parse.Cloud.define('getTripRecords', function(request, response) {
    var vid = request.params.vid;
    Trip.getTripRecords(vid).then(function(records) {
        response.success(records);
    }, function(error) {
        response.error('Something went wrong while trying to fetch trip records.');
    });
});

Parse.Cloud.define('invitePassenger', function(request, response) {
    var vid = request.params.vid;
});

Parse.Cloud.define('joinRide', function(request, response) {
    var vid = request.params.vid;
    var uid = request.params.uid;
});

Parse.Cloud.job('updateAllCars', function(request, status) {
    Parse.Cloud.useMasterKey();
    ToyotaAPI.updateCars().then(function(success) {
        status.success('Finished updating cars.');
    },
    function(obj, error) {
        status.error('There was a problem while trying to update cars.');
    });
});