//
//  BookViewController.m
//  CoreDataHotelService
//
//  Created by Erica Winberry on 11/29/16.
//  Copyright © 2016 Erica Winberry. All rights reserved.
//

#import "BookViewController.h"

#import "AppDelegate.h"
#import "AutoLayout.h"
#import "ReservationService.h"

#import "Hotel+CoreDataClass.h"
#import "Reservation+CoreDataClass.h"
#import "Guest+CoreDataClass.h"

@interface BookViewController ()

@property(strong, nonatomic) UITextField *firstNameField;
@property(strong, nonatomic) UITextField *lastNameField;
@property(strong, nonatomic) UITextField *emailField;

@end

@implementation BookViewController

-(void)loadView {
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setupMessageLabel];
    [self setupTextFields];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonPressed:)]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)setupMessageLabel {
    UILabel *messageLabel = [[UILabel alloc]init];
    
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.numberOfLines = 0; //so label can grow dynamically.
    
    [messageLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:messageLabel];
    
    CGFloat textFieldPadding = 20.0;
    
    NSLayoutConstraint *leading = [AutoLayout createLeadingConstraintFrom:messageLabel toView:self.view];
    leading.constant = textFieldPadding;
    
    NSLayoutConstraint *trailing = [AutoLayout createTrailingConstraintFrom:messageLabel toView:self.view];
    trailing.constant = -textFieldPadding;
    
    [AutoLayout createGenericConstraintFrom:messageLabel toView:self.view withAttribute:NSLayoutAttributeCenterY];
    
    messageLabel.text = [NSString stringWithFormat:@"Reservation At: %@\nRoom: %i (%i beds)\nCost Per Night: $%.2f\nBegins: %@\nEnds: %@",
                         self.room.hotel.name,
                         self.room.roomNumber,
                         self.room.beds,
                         self.room.rate.floatValue,
                         [self getReadableDatefor:self.startDate withFormat:NSDateFormatterLongStyle],
                         [self getReadableDatefor:self.endDate withFormat:NSDateFormatterLongStyle]
                         ];
}

-(void)setupTextFields {
    
    CGFloat textFieldPadding = 20.0;
    CGFloat navAndStatusBarHeight = [self navBarHeight] + [self statusBarHeight];
    
    self.firstNameField = [self createTextFieldWithPlaceholder:@"Please enter your first name."];
    self.lastNameField = [self createTextFieldWithPlaceholder:@"Please enter your last name."];
    self.emailField = [self createTextFieldWithPlaceholder:@"Please enter your email address."];
    
    NSDictionary *viewDictionary = @{@"firstNameField": self.firstNameField, @"lastNameField": self.lastNameField, @"emailField": self.emailField};

    NSDictionary *metricsDictionary = @{
                                        @"textFieldPadding": [NSNumber numberWithFloat: textFieldPadding],
                                        @"navAndStatusBarHeight": [NSNumber numberWithFloat: navAndStatusBarHeight],
                                        @"topPadding": [NSNumber numberWithFloat:(navAndStatusBarHeight + textFieldPadding)]};
    
    [AutoLayout createConstraintsWithVFLFor:viewDictionary withMetricsDictionary:metricsDictionary withFormat:@"V:|-topPadding-[firstNameField]-textFieldPadding-[lastNameField]-textFieldPadding-[emailField]"];
    
    // setting constraints one way
    NSLayoutConstraint *leading = [AutoLayout createLeadingConstraintFrom:self.firstNameField toView:self.view];
    leading.constant = textFieldPadding;
    
    NSLayoutConstraint *trailing = [AutoLayout createTrailingConstraintFrom:self.firstNameField toView:self.view];
    trailing.constant = -textFieldPadding;
    
    // setting constraints another way
    [AutoLayout createConstraintsWithVFLFor:viewDictionary withMetricsDictionary:metricsDictionary withFormat:@"H:|-textFieldPadding-[lastNameField]-textFieldPadding-|"];
    
    [AutoLayout createConstraintsWithVFLFor:viewDictionary withMetricsDictionary:metricsDictionary withFormat:@"H:|-textFieldPadding-[emailField]-textFieldPadding-|"];
    
    [self.firstNameField becomeFirstResponder];
    
}

-(UITextField *)createTextFieldWithPlaceholder:(NSString *)placeholder {
    
    UITextField *textField = [[UITextField alloc]init];
    
    textField.placeholder = placeholder;
    
    [textField setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:textField];
    
    return textField;
}

// move implementation of booking a room to ReservationService
-(void)saveButtonPressed: (UIBarButtonItem *)sender {
    
    // handle instances where textfield is empty (send alert that can't make a reservation without a name).
    if ([self.firstNameField.text isEqual: @""] && [self.lastNameField.text isEqual: @""] && [self.emailField.text isEqual: @""]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops..." message:@"Please make sure that you have filled out all the fields before saving your reservation." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }

    if ([ReservationService bookAReservationFor:self.startDate through:self.endDate atHotel:self.room.hotel inRoom:self.room withFirstName:self.firstNameField.text andLastName:self.lastNameField.text atEmail:self.emailField.text]) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        // let the user know it didn't work.
    }
    
}

@end










