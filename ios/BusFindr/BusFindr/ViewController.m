//
//  ViewController.m
//  BusFindr
//
//  Created by Saitejaswi Kondapalli on 8/2/15.
//  Copyright (c) 2015 Teja Kondapalli. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *disp_lon;
@property (strong, nonatomic) IBOutlet UILabel *disp_lat;
@property (strong, nonatomic) IBOutlet UILabel *at_stop;
@end

@implementation ViewController{
    CLLocationManager *locationManager;
    CLLocation *curr_location;
    CLLocationCoordinate2D currAnnotationCoord;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Set default location
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
    
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    

    
    curr_location = locationManager.location;

    self.disp_lat.text = [NSString stringWithFormat:@"%f", curr_location.coordinate.latitude];
    self.disp_lon.text = [NSString stringWithFormat:@"%f", curr_location.coordinate.longitude];

    NSArray *stop_locs = @[
                           [NSDictionary dictionaryWithObjectsAndKeys:@"Ross YMCA", @"name", @"37.428448", @"lat", @"-122.116555", @"lon", nil],
                           [NSDictionary dictionaryWithObjectsAndKeys:@"Philz Coffee", @"name", @"37.429582",  @"lat", @"-122.122659", @"lon", nil],
                           [NSDictionary dictionaryWithObjectsAndKeys:@"Palo Verde Elementary", @"name", @"37.431092", @"lat", @"-122.113976", @"lon", nil],
                           [NSDictionary dictionaryWithObjectsAndKeys:@"Kondapalli Home", @"name", @"37.431248", @"lat", @"-122.115322", @"lon", nil],
                           [NSDictionary dictionaryWithObjectsAndKeys:@"Adi Home", @"name", @"37.347327", @"lat", @"-121.991502", @"lon", nil],
                           [NSDictionary dictionaryWithObjectsAndKeys:@"DMV Santa Clara", @"name", @"37.350082", @"lat", @"-121.993984", @"lon", nil],
                           [NSDictionary dictionaryWithObjectsAndKeys:@"Starbucks Flora Vista", @"name", @"37.352989", @"lat", @"-121.997273", @"lon", nil],
                           [NSDictionary dictionaryWithObjectsAndKeys:@"Paris Baguette Flora Vista", @"name", @"37.353713", @"lat", @"-121.994364", @"lon", nil]
                          ];
    
    
    NSString * calc_stop = @"--";
    
    for(int i=0; i<[stop_locs count]; i++){
        NSDictionary * this_stop = (NSDictionary*)[stop_locs objectAtIndex:i];
        
        NSString * this_stop_name = (NSString *)[this_stop objectForKey:@"name"];
        float this_stop_lat = [[this_stop objectForKey:@"lat"] floatValue];
        float this_stop_lon = [[this_stop objectForKey:@"lon"] floatValue];
        
        CLLocation *thisLoc = [[CLLocation alloc] initWithLatitude:this_stop_lat longitude:this_stop_lon];
        CLLocationDistance dist = [thisLoc distanceFromLocation:curr_location];
 
        if(dist < 50){
            calc_stop = this_stop_name;
            //NSLog(@"curr: %@ %f", this_stop_name, dist);
        }
        
    }

    self.at_stop.text = calc_stop;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
