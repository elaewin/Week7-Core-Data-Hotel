//
//  ViewController.m
//  CoreDataHotelService
//
//  Created by Erica Winberry on 11/28/16.
//  Copyright © 2016 Erica Winberry. All rights reserved.
//

#import "ViewController.h"
#import "AutoLayout.h"
#import "HotelsViewController.h"
#import "Hotel+CoreDataClass.h"
#import "DatePickerViewController.h"
#import "LookupViewController.h"

@interface ViewController ()

@end

@implementation ViewController


-(void)loadView {
    
    [super loadView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationItem setTitle:@"Hotel Manager"];
    [self setupCustomLayout];
    
}

-(void)setupCustomLayout {
    
    CGFloat navAndStatusBarHeight = [self navBarHeight] + [self statusBarHeight];
    
    CGFloat buttonHeight = (self.view.frame.size.height - navAndStatusBarHeight) / 3;
    
    // Buttons
    UIButton *browseButton = [self createButtonWithTitle:@"Browse" andBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:0.76 alpha:1.0]];
    
    UIButton *bookButton = [self createButtonWithTitle:@"Book" andBackgroundColor:[UIColor colorWithRed:1.0 green:0.91 blue:0.76 alpha:1.0]];
    
    UIButton *lookupButton = [self createButtonWithTitle:@"Look Up" andBackgroundColor:[UIColor colorWithRed:0.85 green:1.0 blue:0.76 alpha:1.0]];
    
    NSDictionary *viewDictionary = @{@"browseButton": browseButton, @"bookButton": bookButton, @"lookupButton": lookupButton};
    
    NSDictionary *metricsDictionary = @{@"navHeightPadding": [NSNumber numberWithFloat:navAndStatusBarHeight], @"buttonHeight":  [NSNumber numberWithFloat:buttonHeight]};
    
    [AutoLayout createConstraintsWithVFLFor:viewDictionary
                      withMetricsDictionary:metricsDictionary withFormat:@"V:|-navHeightPadding-[browseButton(==buttonHeight)][bookButton(==browseButton)][lookupButton(==browseButton)]|"];
    
    [AutoLayout createLeadingConstraintFrom:browseButton toView:self.view];
    [AutoLayout createTrailingConstraintFrom:browseButton toView:self.view];
    
    [AutoLayout createLeadingConstraintFrom:bookButton toView:self.view];
    [AutoLayout createTrailingConstraintFrom:bookButton toView:self.view];
    
    [AutoLayout createLeadingConstraintFrom:lookupButton toView:self.view];
    [AutoLayout createTrailingConstraintFrom:lookupButton toView:self.view];
    
    // set up action buttons programmatically
    [browseButton addTarget:self action:@selector(browseButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    [bookButton addTarget:self action:@selector(bookButtonSelected:) forControlEvents:UIControlEventTouchUpInside];

    [lookupButton addTarget:self action:@selector(lookupButtonSelected:) forControlEvents:UIControlEventTouchUpInside];

}

-(void)browseButtonSelected:(UIButton *)sender {
    
    HotelsViewController *hotelsVC = [[HotelsViewController alloc]init];
    
    [self.navigationController pushViewController:hotelsVC animated:YES];
    
    NSLog(@"Browse button pressed.");
    
}

-(void)bookButtonSelected:(UIButton *)sender {
    
    DatePickerViewController *DatePickerVC = [[DatePickerViewController alloc]init];
    
    [self.navigationController pushViewController:DatePickerVC animated:YES];
    
    NSLog(@"Book button pressed.");
}

-(void)lookupButtonSelected:(UIButton *)sender {
    
    LookupViewController *lookupVC = [[LookupViewController alloc]init];
    
    [self.navigationController pushViewController:lookupVC animated:YES];
    
    NSLog(@"Lookup button pressed");
}

// button setup helper method (since we've got several)
-(UIButton *)createButtonWithTitle:(NSString *)title andBackgroundColor:(UIColor *)color {
    
    UIButton *button = [[UIButton alloc]init];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundColor:color];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:button];
    
    return button;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

@end
