//
//  DatePickerViewController.m
//  CoreDataHotelService
//
//  Created by Erica Winberry on 11/29/16.
//  Copyright © 2016 Erica Winberry. All rights reserved.
//

#import "DatePickerViewController.h"
#import "AvailabilityViewController.h"
#import "AutoLayout.h"

@interface DatePickerViewController ()

@property(strong, nonatomic) UIDatePicker *startPicker;
@property(strong, nonatomic) UIDatePicker *endPicker;
@property(strong, nonatomic) UILabel *startLabel;
@property(strong, nonatomic) UILabel *endLabel;

@end

@implementation DatePickerViewController

-(void)loadView {
    [super loadView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setupCustomLayout];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
 
    [self.navigationItem setRightBarButtonItem:doneButton];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Create Reservation"];
    // Do any additional setup after loading the view.
}

-(void)setupCustomLayout {
    
    CGFloat betweenPickersPadding = 20;
    CGFloat navAndStatusBarHeight = [self navBarHeight] + [self statusBarHeight];
    
    self.startPicker = [self createDatePicker];
    self.endPicker = [self createDatePicker];

    self.startPicker.minimumDate = [NSDate date];
    self.endPicker.minimumDate = [NSDate date];
    
    self.startLabel = [self setupLabelWithText:@"Start Date:"];
    self.endLabel = [self setupLabelWithText:@"End Date:"];

    [AutoLayout createTrailingConstraintFrom:self.startPicker toView:self.view];
    [AutoLayout createLeadingConstraintFrom:self.startPicker toView:self.view];
    
    [AutoLayout createTrailingConstraintFrom:self.endPicker toView:self.view];
    [AutoLayout createLeadingConstraintFrom:self.endPicker toView:self.view];
    
    [AutoLayout createTrailingConstraintFrom:self.startLabel toView:self.view];
    [AutoLayout createLeadingConstraintFrom:self.startLabel toView:self.view];
    
    [AutoLayout createTrailingConstraintFrom:self.endLabel toView:self.view];
    [AutoLayout createLeadingConstraintFrom:self.endLabel toView:self.view];
    
    NSDictionary *viewDictionary = @{
                                     @"startPicker": self.startPicker,
                                     @"endPicker": self.endPicker,
                                     @"startLabel": self.startLabel,
                                     @"endLabel": self.endLabel
                                     };
    
    NSDictionary *metricsDictionary = @{
                                        @"betweenPickersPadding": [NSNumber numberWithFloat:betweenPickersPadding],
                                        @"topPadding": [NSNumber numberWithFloat:(navAndStatusBarHeight + betweenPickersPadding)]
                                        };
    
    [AutoLayout createConstraintsWithVFLFor:viewDictionary withMetricsDictionary:metricsDictionary withFormat:@"V:|-topPadding-[startLabel][startPicker]-betweenPickersPadding-[endLabel][endPicker]"];
}

-(UILabel *)setupLabelWithText:(NSString *)labelText {
    
    UILabel *label = [[UILabel alloc]init];
    
    label.textAlignment = NSTextAlignmentCenter;
    
    label.font = [UIFont systemFontOfSize:22.0 weight:UIFontWeightSemibold];

    label.text = labelText;
    
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:label];
    
    return label;
}

-(UIDatePicker *)createDatePicker {
    
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    [datePicker setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:datePicker];
    
    return datePicker;
}

-(void)doneButtonPressed:(UIBarButtonItem *)sender {
    
    NSDate *startDate = self.startPicker.date;
    NSDate *endDate = self.endPicker.date;
    
    // handle end dates before start dates in pickers
    if([startDate  timeIntervalSinceReferenceDate] >= [endDate timeIntervalSinceReferenceDate]) {
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Oops...!"
                                              message:@"Please make sure that the end date of your reservation is after the start date."
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * _Nonnull action) {
            
            self.endPicker.date = self.startPicker.date;
            
        }];
        
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    // handle equal end and start dates - must have at least a one night stay
    
    if([self getReadableDatefor:self.startPicker.date withFormat:NSDateFormatterShortStyle] == [self getReadableDatefor:self.endPicker.date withFormat:NSDateFormatterShortStyle]) {
        
        NSDateComponents *components = [[NSDateComponents alloc]init];
        components.day = 1;
        NSDate *datePlusOne = [[NSCalendar currentCalendar] dateByAddingComponents: components toDate:self.endPicker.date options: NSCalendarMatchNextTime];
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Same-day Reservations Not Allowed"
                                              message:@"You can only make reservations for one night or more."
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * _Nonnull action) {
                                       
                                       self.endPicker.date = datePlusOne;
                                       
                                   }];
        
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    AvailabilityViewController *availabilityVC = [[AvailabilityViewController alloc]init];
    availabilityVC.startDate = self.startPicker.date;
    availabilityVC.endDate = self.endPicker.date;
    
    [self.navigationController pushViewController:availabilityVC animated:YES];
    
}

@end







