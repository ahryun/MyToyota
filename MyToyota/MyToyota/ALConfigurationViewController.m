
#import "ALConfigurationViewController.h"
#import "ALDefaults.h"
#import <CoreBluetooth/CoreBluetooth.h>

#import <CoreLocation/CoreLocation.h>

@interface ALConfigurationViewController ()

//- (void)turnonBeacon;
//- (void)turnoffBeacon;

@end

@implementation ALConfigurationViewController
{
    CBPeripheralManager *_peripheralManager;
    
    BOOL _enabled;
    NSUUID *_uuid;
    NSNumber *_major;
    NSNumber *_minor;
    NSNumber *_power;
    
    UISwitch *_enabledSwitch;
    
    UITextField *_uuidTextField;
    UIPickerView *_uuidPicker;
    
    NSNumberFormatter *_numberFormatter;
    UITextField *_majorTextField;
    UITextField *_minorTextField;
    UITextField *_powerTextField;
    
    UIBarButtonItem *_doneButton;
    UIBarButtonItem *_saveButton;
}

- (id)init {
    self = [super init];
    if (self) {
        _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        _uuid = [ALDefaults sharedDefaults].defaultProximityUUID;
        _power = [ALDefaults sharedDefaults].defaultPower;
        
        _numberFormatter = [[NSNumberFormatter alloc] init];
        _numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    }
    
    return self;
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    NSLog(@"State changed %ld", peripheral.state);
}

- (void)turnonBeacon
{
    NSLog(@"State is %ld", _peripheralManager.state);
    NSLog(@"Power state is %ld", CBPeripheralManagerStatePoweredOn);
    
    // We must construct a CLBeaconRegion that represents the payload we want the device to beacon.
    NSDictionary *peripheralData = nil;
    if(_uuid && _major && _minor)
    {
        CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:_uuid major:[_major shortValue] minor:[_minor shortValue] identifier:@"Papafish.MyToyota"];
        peripheralData = [region peripheralDataWithMeasuredPower:_power];
    }
    else if(_uuid && _major)
    {
        CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:_uuid major:[_major shortValue] identifier:@"Papafish.MyToyota"];
        peripheralData = [region peripheralDataWithMeasuredPower:_power];
    }
    else if(_uuid)
    {
        CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:_uuid identifier:@"Papafish.MyToyota"];
        peripheralData = [region peripheralDataWithMeasuredPower:_power];
    }
    
    // The region's peripheral data contains the CoreBluetooth-specific data we need to advertise.
    if(peripheralData)
    {
        [_peripheralManager startAdvertising:peripheralData];
        NSLog(@"BT advertising: %i", _peripheralManager.isAdvertising);
    }
}

- (void)turnoffBeacon {
    NSLog(@"BT stopped advertising");
    [_peripheralManager stopAdvertising];
}

@end
