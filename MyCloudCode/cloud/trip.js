// returns a lists of trips (including users)
// that are currently active for the vid
exports.getTripRecords = function(vid) {
    // get car from vid
    var promise = new Parse.Promise();
    var query = new Parse.Query('Car');
    query.equalTo('vid', vid);
    query.first({
        success: function(car) {
            return car;
        },
        error: function(obj, error) {
            promise.reject(error);
        }
    }).then(function(car) {
        var tripQuery = new Parse.Query('Trip');
        /* query for trip records that have 
            vid for car &
            are missing an end mile &
            isDriver != true
        */
        tripQuery.equalTo('car', car);
        tripQuery.equalTo('endMile', null);
        tripQuery.equalTo('isDriver', false);
        tripQuery.notEqualTo('user', null);
        tripQuery.include('user');
        tripQuery.find({
            success: function(tripRecords) {
                promise.resolve(tripRecords);
            },
            error: function(obj, error) {
                promise.reject(error);
            }
        });
    }, function(error) {
        promise.reject(error);
    });
    return promise;
}