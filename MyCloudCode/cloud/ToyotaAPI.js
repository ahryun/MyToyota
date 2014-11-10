var Utils = require('cloud/utils.js');

var kmToMilesConstant = 0.621371;

var userInfoURI = "https://api-jp-t-itc.com/GetUserInfo";
var vehicleModelListURI = "https://api-jp-t-itc.com/GetVehicleModelList";
var vehicleSpecURI = "https://api-jp-t-itc.com/GetVehicleSpec";
var vehicleInfoURI = "https://api-jp-t-itc.com/GetVehicleInfo";
var mapMatchingVehicleInfoURI = "https://api-jp-t-itc.com/GetVehicleInfoMM";
var statisticsURI = "https://api-jp-t-itc.com/GetStatisticsInfo";
var developerKey = '3552b02ecebf';

var allCarParams = '[Posn,Spd,ALat,ALgt,YawRate,AccrPedlRat,BrkIndcr,SteerAg,TrsmGearPosn,EngN,OdoDst,DrvgMod,EcoDrvgSts,PrkgBrk,SysPwrSts,RestFu,CnsFu,EngT,OutdT,HdLampLtgIndcn,WiprSts,DoorSts,DoorLockPosn,PwrWinActtn]';

var makeHttpRequest = function(endpoint, kvpairs) {
    kvpairs['developerkey'] = developerKey;
    kvpairs['responseformat'] = 'json';
    Parse.Cloud.httpRequest({
        method: "POST",
        url: endpoint,
        body: kvpairs
    });
}

/*
    Car Object:
    Car {
        vehicleinfo {
            0 {
                data {
                    0 {
                        ALat: -0.5
                        ALgt: 0.5
                        AccrPedlRat: 37
                        BrkIndcr: 0
                        CnsFu: 1.3
                        DoorLockPosn: "000"
                        DoorSts: "00000"
                        DrvgMod: 1
                        EcoDrvgSts: 3
                        EngN: 1525
                        EngT: 84
                        HdLampLtgIndcn: 0
                        OdoDst: 6852
                        OutdT: 28
                        Posn {
                            MapMtchg: 1
                            lat: 37.373906
                            lon: -122.056236
                        }
                        PrkgBrk: 0
                        PwrWinActtn: "2222"
                        RestFu: 9
                        Spd: 23.73
                        SteerAg: 5
                        SysPwrSts: 2
                        TrsmGearPosn: "D"
                        WiprSts: 0
                        YawRate: 0.7
                    }
                }
                userid: "ITCUS_USERID_052"
                vid: "ITCUS_VID_052"
            }
        }
    }
*/


function getCarFromVID(vehicleID) {
    var promise = new Parse.Promise();
    var params = {
        developerkey: developerKey,
        responseformat: 'json',
        vid: vehicleID,
        infoids: allCarParams
    }
    
    Parse.Cloud.httpRequest({
        method: 'POST',
        url: vehicleInfoURI,
        headers: {'Content-Type': 'multipart/form-data'},
        params: params,
        success: function(httpResponse) {
            var toyotaCarObject = JSON.parse(httpResponse.text);
            var flattenedCarObject = flattenToyotaCarObject(toyotaCarObject);
            createOrUpdateCar(flattenedCarObject).then(function(car) {
                promise.resolve(car);
            })
        },
        error: function(httpResponse) {
            console.log('In getCarInfoFromVID with httpRequest Error: ' + JSON.stringify(httpResponse));
            console.log('HttpResponse.status: ' + httpResponse.status);
            promise.reject(httpResponse.status);
        }
    });    
    return promise;
}
exports.getCarFromVID = getCarFromVID;

var flattenToyotaCarObject = function(carObject) {
    var userID = carObject.vehicleinfo[0].userid;
    var vid = carObject.vehicleinfo[0].vid;
    var p = carObject.vehicleinfo[0].data[0];
    var miles = p.OdoDst; //Math.round(p.OdoDst * kmToMilesConstant);
    var mph   = p.Spd; //Math.round(p.Spd * kmToMilesConstant);
    var point = new Parse.GeoPoint(p.Posn.lat, p.Posn.lon);

    return {
        owner: userID,
        vid: vid,
        currentMiles: miles,
        year: 2014,
        location: point,
        ALat: p.ALat,
        ALgt: p.Lgt,
        acceleratorPedalPercentage: p.AccrPedlRat,
        BrkIndcr: p.BrkIndcr,
        CnsFu: p.CnsFu,
        DoorLockPosn: p.DoorLockPosn,
        DoorSts: p.DoorSts,
        drivingMode: p.DrvgMod,
        EcoDrvgSts: p.EcoDrvgSts,
        EngN: p.EngN,
        EngT: p.EngT,
        HdLampLtgIndcn: p.HdLampLtgIndcn,
        OutdT: p.OutdT,
        PrkgBrk: p.PrkgBrk,
        PwrWinActtn: p.PwrWinActtn,
        RestFu: p.RestFu,
        speed: mph,
        SteerAg: p.SteerAg,
        powerStatus: p.SysPwrSts,
        TrsmGearPosn: p.TrsmGearPosn,
        WiprSts: p.WiprSts,
        YawRate: p.YawRate
    };
}

var createOrUpdateCar = function(flattenedCar) {
    var promise = new Parse.Promise();
    // query to see if vid exists
    var query = new Parse.Query('Car');
    query.equalTo('vid', flattenedCar.vid);
    query.find({
        success: function(results) {
            // results is an array of Parse.Object.
            if (results.length > 0) {
                updateCar(results[0], flattenedCar).then(function(msg) {
                   promise.resolve(results[0]); 
                });
            } else {
                // else create a new one
                _createCar(flattenedCar).then(function(msg) {
                    promise.resolve(msg);
                });
            }
        },
        error: function(error) {
            // error is an instance of Parse.Error.
            promise.reject(error);
        }
    });    
    return promise;
}

var _createCar = function(flattenedCar) {
    // only add static attributes, call updateCar to add dynamic attributes
    var Car = Parse.Object.extend('Car');
    var car = new Car();
    var user = null;
    car.set('owner', user);
    car.set('make', 'Toyota');
    car.set('model', 'Prius');
    car.set('year', 2014);
    car.set('vid', flattenedCar.vid);
    return updateCar(car, flattenedCar);
}

var updateCar = function(car, flattenedCar) {
    var promise = new Parse.Promise();
    car.set('location', flattenedCar.location);
    car.set('currentMiles', flattenedCar.currentMiles);
    car.set('powerStatus', flattenedCar.powerStatus);
    car.set('speed', flattenedCar.speed);
    car.set('acceleratorPedalPercentage', flattenedCar.acceleratorPedalPercentage);
    car.save().then(function(c) {
        promise.resolve('Car ' + c.vid + ' location was updated.');
    });
    return promise;
}

exports.updateCars = function() {
    //
    var carNums = [52,54,56,58,60,62,64,66,68,70,72,74,76,78,80,82,84,86,88,90,92,94,96,98,100];
    var d = new Date();
    var m = d.getMinutes();
    var i = m % carNums.length;
    
    var promise = new Parse.Promise();
    getCarFromVID('ITCUS_VID_' + Utils.pad(carNums[i], 3)).then(function(car) {
        promise.resolve('Updated car: ' + car.vid);
    });
    return promise;
}