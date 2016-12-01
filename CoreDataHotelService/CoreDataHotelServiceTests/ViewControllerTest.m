//
//  ViewControllerTest.m
//  CoreDataHotelService
//
//  Created by Erica Winberry on 11/30/16.
//  Copyright © 2016 Erica Winberry. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"

@interface ViewControllerTest : XCTestCase

@property(strong, nonatomic)ViewController *testController;
@property(strong, nonatomic)UIView *testView1;

@end

@implementation ViewControllerTest

- (void)setUp {
    [super setUp];
    
    ViewController *testController = [[ViewController alloc]init];
    UIView *testView1 = [[UIView alloc]init];
    
    [self.testController.view addSubview:testView1];
    
}

- (void)tearDown {
    
    self.testController = nil;
    self.testView1 = nil;
    
    [super tearDown];
}

//-(void)testCreateButtonWithTitleCreatesButton {
//    
//    UIButton *button = [self.testController createButtonWithTitle:@"Button" andBackgroundColor:[UIColor blueColor]];
//    
//    XCTAssert([button isMemberOfClass:[UIButton class]], @"Create button does NOT create a button! It creates %@", [button class]);
//}

@end

