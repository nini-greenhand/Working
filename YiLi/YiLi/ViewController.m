//
//  ViewController.m
//  YiLi
//
//  Created by uplooking on 15/11/5.
//  Copyright (c) 2015年 STu. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController ()<CBCentralManagerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1建立中心角色
    CBCentralManager *manager;
    manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    //2扫描外设（discover）uuid指定
    NSArray *uuidArray = [NSArray arrayWithObjects:[CBUUID UUIDWithString:@"1800"],[CBUUID UUIDWithString:@"180A"],
                          [CBUUID UUIDWithString:@"1CB2D155-33A0-EC21-6011-CD4B50710777"],[CBUUID UUIDWithString:@"6765D311-DD4C-9C14-74E1-A431BBFD0652"],nil];
    //固定写法
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    [manager scanForPeripheralsWithServices:uuidArray options:options];
    
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}
//3连接外设(connect)

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    
//    if(![_dicoveredPeripherals containsObject:peripheral])
//        [_dicoveredPeripherals addObject:peripheral];
   NSLog(@"dicoveredPeripherals:"  );
}


/*
 Invoked whenever the central manager's state is updated.
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSString * state = nil;
    
    switch ([central state])
    {
        case CBCentralManagerStateUnsupported:
            state = @"The platform/hardware doesn't support Bluetooth Low Energy.";
            break;
        case CBCentralManagerStateUnauthorized:
            state = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
        case CBCentralManagerStatePoweredOff:
            state = @"Bluetooth is currently powered off.";
            break;
        case CBCentralManagerStatePoweredOn:
            state = @"work";
            break;
        case CBCentralManagerStateUnknown:
        default:
            ;
    }
    
    NSLog(@"Central manager state: %@", state);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
