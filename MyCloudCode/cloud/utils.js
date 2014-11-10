// Global Imports
var MD5 = require('cloud/MD5.js');

exports.generatePassword = function(phoneNumber) {
    // Salted password setting
    var pass = MD5.hash(phoneNumber + 'SOgUM'); // DO NOT CHANGE OR THE SKY WILL FALL DOWN
    if (phoneNumber) {
        return pass;
    } else {
        return null;
    }
};

exports.truncate = function(str, n) {
    // extra -3 for '...' characters
    return str.length > n ? str.substr(0, n-1-3) + '...' : str;
};

function pad(str, max) {
    str = str.toString();
    return str.length < max ? pad("0" + str, max) : str;
}
exports.pad = pad;

exports.logError = function(error) {
    return 'Error ' + error.code + ': ' + error.message;
}

/* compareUsersByAttribute
    A generic function that is used by other exported functions to help compare
    User objects by a certain attribute.
    params: a - the first object to compare
            b - the second object to compare
            attributeName
    return: -1, 1, or 0

    NOTE: the object's attribute must be a type that is comparable, or this
          function will fail. This function cannot be used in conjunction with
          array.sort() directly and must be first passed a helper function which
          specifies the attribute.

          example:
          var compareFooByBar = function(a, b) {
              var STATIC_ATTR = 'bar'; // where 'bar' is attribute of objects type Foo
              return Utils.compareObjectsByAttribute(a, b, STATIC_ATTR);
          }
*/
var compareObjectsByAttribute = function(a, b, attributeName) {
    if (a[attributeName] < b[attributeName]) return -1;
    if (a[attributeName] > b[attributeName]) return 1;
    return 0;
}
exports.compareObjectsByAttribute = compareObjectsByAttribute;

/* Timer
    A basic class which can be used to get the rough estimation of execution time
    of cloud code functions.

    Use:
    var T = Timer;
    console.log(T.startTimer()); // starts the time
    {...} // some synchronous code to run
    console.log(T.endTimers()); // stops the timer (also returns a delta string)
*/
exports.Timer = new function() {
    this.startTime = null;
    this.endTime   = null;
    this.delta     = null;
    this.startTimer = function () {
        this.startTime = new Date();
        return 'Time started at: ' + this.startTime;
    };
    this.endTimer = function() {
        this.endTime = new Date();
        this.delta = (this.endTime.getTime() - this.startTime.getTime()) / 1000; // time in seconds
        return this.delta + ' seconds';
    };
}

var JSONcompare = function(a, b) {
    if (a.length != b.length) {
        return false;
    }
    // sort both lists
    a.sort(compareObjsByPhoneNumber);
    b.sort(compareObjsByPhoneNumber);
    for (var i = 0; i < a.length; i++) {
        if (!compareObjs) return false;
    }
    return true;
}
exports.JSONcompare = JSONcompare;

var compareObjs = function(a, b) {
    var aKeys = Object.keys(a);
    var bKeys = Object.keys(b);
    if (aKeys.length != bKeys.length) {
        return false;
    }
    aKeys.forEach(function(key, index, array) {
        if (compareObjectsByAttribute(a, b, key) != 0) return false;
    });
    return true;
}

var compareObjsByPhoneNumber = function(a, b) {
    return compareObjectsByAttribute(a, b, 'phoneNumber');
}

exports.getOrCreateTestPhoneVerification = function(TEST_NUM, TEST_PIN) {
    var promise = new Parse.Promise();
    var query = new Parse.Query('PhoneVerification');
    query.equalTo('phoneNumber', TEST_NUM);
    query.first({
        success: function(pv) {
            // update updatedAt time to now by send off to save
            if (pv == null) {
                // could not find test number phoneVerification, so create one
                pv = new Parse.Object('PhoneVerification');
                pv.set('phoneNumber', TEST_NUM);
                pv.set('pinCode', TEST_PIN);
            }
            pv.save(null, {
                success: function(phoneVerification) {
                    promise.resolve(phoneVerification);
                },
                error: function(obj, error) {
                    promise.reject(error);
                }
            });
        },
        error: function(obj, error) {
            promise.reject(error);
        }
    });
    return promise;
}