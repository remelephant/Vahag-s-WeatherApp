//
//  ViewController.h
//  Vahag's WeatherApp
//
//  Created by Vahagn Gevorgyan on 4/24/17.
//  Copyright © 2017 Vahagn Gevorgyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate> {
    
}

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon;
- (IBAction)userLocation:(id)sender;

@property (strong, nonatomic) NSDictionary* weatherData;
@property (strong, nonatomic) NSDictionary* forecastData;

@property (weak, nonatomic) IBOutlet UITextField *locationTextField;

@property (weak, nonatomic) IBOutlet UILabel *tempDisplay;

@property (weak, nonatomic) IBOutlet UILabel *dateDisplay;
@property (weak, nonatomic) IBOutlet UILabel *locationDisplay;

- (IBAction)locationEditingBegin:(id)sender;
@property (strong, nonatomic) NSString* unit;
@property (strong, nonatomic) CLLocation* location;

@property (weak, nonatomic) IBOutlet UILabel *data1;
@property (weak, nonatomic) IBOutlet UILabel *data2;
@property (weak, nonatomic) IBOutlet UILabel *data3;
@property (weak, nonatomic) IBOutlet UILabel *data4;
@property (weak, nonatomic) IBOutlet UILabel *data5;

@property (weak, nonatomic) IBOutlet UILabel *temperature1;
@property (weak, nonatomic) IBOutlet UILabel *temperature2;
@property (weak, nonatomic) IBOutlet UILabel *temperature3;
@property (weak, nonatomic) IBOutlet UILabel *temperature4;
@property (weak, nonatomic) IBOutlet UILabel *Temperature5;

@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon1;
@property (weak, nonatomic) IBOutlet UIImageView * weatherIcon2;
@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon3;
@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon4;
@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon5;

@end

