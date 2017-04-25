//
//  ViewController.m
//  Vahag's WeatherApp
//
//  Created by Vahagn Gevorgyan on 4/24/17.
//  Copyright © 2017 Vahagn Gevorgyan. All rights reserved.
//

#import "ViewController.h"

#define queryURL @"http://api.openweathermap.org/data/2.5/weather?"
#define forecastURL @"http://api.openweathermap.org/data/2.5/forecast?"
#define imageURL @"https://openweathermap.org/img/w/"
#define apiKEY @"&appid=f2440bae516427dc5284235fcb321e65"

#define unitQuery @"&units="
#define keyboardHeight 220

@interface ViewController ()

@end

@implementation ViewController

@synthesize weatherIcon;

- (void)viewDidLoad {
    [super viewDidLoad];
    
        self.locationTextField.delegate = self;
        self.locationTextField.placeholder = @"write city name here";
        
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager requestWhenInUseAuthorization];
        self.location = self.locationManager.location;
        
        self.unit = @"metric";
    
        [self loadWeatherData];
        [self displayReport:self.weatherData];
        [self displayImage:self.weatherData];
        
        [self displayForecastReport:self.forecastData];
        [self displayForecastImage:self.forecastData];
}

-(void) loadWeatherData {
    self.weatherData = [self cityAPI:self.location]; // current info
    self.forecastData = [self weatherDataAPI:self.location]; // forecast info
}

- (NSDictionary *) cityAPI: (CLLocation *)location {
    
    NSString *theURL = [NSString stringWithFormat:@"%@lat=%f&lon=%f%@%@%@", queryURL, location.coordinate.latitude, location.coordinate.longitude,unitQuery, self.unit, apiKEY];
//    NSLog (@"%@", theURL);
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:theURL] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
//    NSLog (@"%@", jsonData);
    NSError *error = nil;
    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error] : nil;
    
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
//    NSLog(@"%@", results);
    return results;
}

- (NSDictionary *) weatherDataAPI: (CLLocation *)location {
    
    NSString *theURL = [NSString stringWithFormat:@"%@lat=%f&lon=%f%@%@%@", forecastURL, location.coordinate.latitude, location.coordinate.longitude, unitQuery, self.unit, apiKEY];
    
    NSLog (@"%@", theURL);
    
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:theURL] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    NSDictionary *json = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error] : nil;
    
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    
    return json;
}

-(void)displayForecastImage:(NSDictionary*)results{
    
    NSString *condition1 = results[@"list"][0][@"weather"][0][@"icon"];
    NSString *condition2 = results[@"list"][1][@"weather"][0][@"icon"];
    NSString *condition3 = results[@"list"][2][@"weather"][0][@"icon"];
    NSString *condition4 = results[@"list"][3][@"weather"][0][@"icon"];
    NSString *condition5 = results[@"list"][4][@"weather"][0][@"icon"];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("image downloader", NULL);
    dispatch_async(downloadQueue, ^{

        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@%@.png", imageURL, condition1]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *icon = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.weatherIcon1 setImage:icon];
        });
        
        url = [NSURL URLWithString:[NSString stringWithFormat: @"%@%@.png", imageURL, condition2]];
        data = [NSData dataWithContentsOfURL:url];
        icon = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.weatherIcon2 setImage:icon];
        });
        
        url = [NSURL URLWithString:[NSString stringWithFormat: @"%@%@.png", imageURL, condition3]];
        data = [NSData dataWithContentsOfURL:url];
        icon = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.weatherIcon3 setImage:icon];
        });
        
        url = [NSURL URLWithString:[NSString stringWithFormat: @"%@%@.png", imageURL, condition4]];
        data = [NSData dataWithContentsOfURL:url];
        icon = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.weatherIcon4 setImage:icon];
        });
        
        url = [NSURL URLWithString:[NSString stringWithFormat: @"%@%@.png", imageURL, condition5]];
        data = [NSData dataWithContentsOfURL:url];
        icon = [UIImage imageWithData:data];
        
        NSLog(@"%@", url);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.weatherIcon5 setImage:icon];
        });
    });
    
//    dispatch_release(downloadQueue);
    
}


-(void)displayReport:(NSDictionary*)results{

//    NSLog(@"report");
    NSString *temp = [NSString stringWithFormat: @"%g", roundf ([results[@"main"][@"temp"] floatValue])];
    NSString *city = results[@"name"];
    NSString *country = results[@"sys"][@"country"];
    NSString *unit = @"C";
    if ([self.unit isEqual: @"imperial"]){
        unit = @"F";
    }
    
    double unixTimeStamp = [results[@"dt"] doubleValue];
    NSTimeInterval _interval=unixTimeStamp;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"hh:mm a MM.dd.yyyy"];
    NSString *stringDate = [formatter stringFromDate:date];

//    NSLog (@"%@", date);

    self.tempDisplay.text =[NSString stringWithFormat:@"%@°%@",temp, unit];
    self.dateDisplay.text = stringDate;
    self.locationDisplay.text = [NSString stringWithFormat:@"%@, %@",city, country];
    
}

-(void)displayForecastReport:(NSDictionary*)results{
    
    NSString *unit = @"C";
    if ([self.unit isEqual: @"imperial"]){
        unit = @"F";
    }
    
    NSString *high1 = [NSString stringWithFormat: @"%g", roundf ([results[@"list"][0][@"main"][@"temp_max"] floatValue])];
    NSString *high2 = [NSString stringWithFormat: @"%g", roundf ([results[@"list"][1][@"main"][@"temp_max"] floatValue])];
    NSString *high3 = [NSString stringWithFormat: @"%g", roundf ([results[@"list"][2][@"main"][@"temp_max"] floatValue])];
    NSString *high4 = [NSString stringWithFormat: @"%g", roundf ([results[@"list"][3][@"main"][@"temp_max"] floatValue])];
    NSString *high5 = [NSString stringWithFormat: @"%g", roundf ([results[@"list"][4][@"main"][@"temp_max"] floatValue])];
//    NSString *low5 = [NSString stringWithFormat: @"%g", roundf ([results[@"list"][4][@"main"][@"temp_min"] floatValue])];
    
    double unixTimeStamp = [results[@"list"][0][@"dt"] doubleValue];
    NSTimeInterval _interval=unixTimeStamp;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"ha M/d"];
    NSString *stringDate1 = [formatter stringFromDate:date];
    stringDate1 = [stringDate1 substringToIndex:[stringDate1 length] -5];
    
    unixTimeStamp = [results[@"list"][1][@"dt"] doubleValue];
    _interval=unixTimeStamp;
    date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSString *stringDate2 = [formatter stringFromDate:date];
    stringDate2 = [stringDate2 substringToIndex:[stringDate2 length] -5];
    NSLog(@"%@", stringDate2);
    
    unixTimeStamp = [results[@"list"][2][@"dt"] doubleValue];
    _interval=unixTimeStamp;
    date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSString *stringDate3 = [formatter stringFromDate:date];
    stringDate3 = [stringDate3 substringToIndex:[stringDate3 length] -5];
    
    unixTimeStamp = [results[@"list"][3][@"dt"] doubleValue];
    _interval=unixTimeStamp;
    date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSString *stringDate4 = [formatter stringFromDate:date];
    stringDate4 = [stringDate4 substringToIndex:[stringDate4 length] -5];
    
    unixTimeStamp = [results[@"list"][4][@"dt"] doubleValue];
    _interval=unixTimeStamp;
    date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSString *stringDate5 = [formatter stringFromDate:date];
    stringDate5 = [stringDate5 substringToIndex:[stringDate5 length] -5];
//    NSLog(@"%@", stringDate5);
    
    self.data1.text = stringDate1;
    self.temperature1.text = [NSString stringWithFormat:@"%@°%@",high1, unit];
    self.data2.text = stringDate2;
    self.temperature2.text = [NSString stringWithFormat:@"%@°%@",high2, unit];
    self.data3.text = stringDate3;
    self.temperature3.text = [NSString stringWithFormat:@"%@°%@",high3, unit];
    self.data4.text = stringDate4;
    self.temperature4.text = [NSString stringWithFormat:@"%@°%@",high4, unit];
    self.data5.text = stringDate5;
    self.Temperature5.text = [NSString stringWithFormat:@"%@°%@",high5, unit];
}


-(void)displayImage:(NSDictionary*)results{
    NSString *condition = results[@"weather"][0][@"icon"];
//    NSLog(@"condition code: %@", condition);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@%@.png", imageURL, condition]];
//    NSLog(@"%@", url);
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *icon = [UIImage imageWithData:data];
    [self.weatherIcon setImage:icon];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)userLocation:(id)sender {
    [self.locationManager requestWhenInUseAuthorization];
    self.location = self.locationManager.location;
    
    [self loadWeatherData];
//    [NSThread sleepForTimeInterval:5.0f];
    [self displayReport:self.weatherData];
    [self displayImage:self.weatherData];
    [self displayForecastReport:self.forecastData];
    [self displayForecastImage:self.forecastData];
}

- (IBAction)locationEditingBegin:(id)sender {
    [self.locationTextField becomeFirstResponder];
    
    if (self.view.frame.origin.y >= 0){
        NSLog(@"%f", self.view.frame.origin.y);
        [self setViewMovedUp:YES];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.locationTextField resignFirstResponder];
    if (self.view.frame.origin.y < 0){
        [self setViewMovedUp:NO];
    }
}

-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        rect.origin.y -= keyboardHeight;
    }
    else
    {
        rect.origin.y += keyboardHeight;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

-(BOOL) textFieldShouldReturn:(UITextField *)locationTextField {
    [self searchFrom:self.locationTextField.text];
    [self.locationTextField resignFirstResponder];
    if (self.view.frame.origin.y < 0){
        [self setViewMovedUp:NO];
    }
    
    return YES;
}

-(void) searchFrom:(NSString*) address {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError * error) {
        if (placemarks.count > 0){
            CLPlacemark *placemark = [placemarks firstObject];
            self.location = placemark.location;
            
            [self loadWeatherData];
            [self displayReport:self.weatherData];
            [self displayImage:self.weatherData];
            [self displayForecastReport:self.forecastData];
            [self displayForecastImage:self.forecastData];
        }
        if (error != NULL) {
            NSLog(@"Error");
            self.locationTextField.text = @"Unable to find or error";
        }
    }];
}

@end
