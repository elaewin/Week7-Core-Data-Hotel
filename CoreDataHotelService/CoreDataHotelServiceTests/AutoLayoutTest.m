//
//  AutoLayoutTest.m
//  CoreDataHotelService
//
//  Created by Erica Winberry on 11/30/16.
//  Copyright © 2016 Erica Winberry. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AutoLayout.h"

@interface AutoLayoutTest : XCTestCase

@property(strong, nonatomic)UIViewController *testController;

@property(strong, nonatomic)UIView *testView1;
@property(strong, nonatomic)UIView *testView2;

@end

@implementation AutoLayoutTest

- (void)setUp {
    [super setUp];
    
    self.testController = [[UIViewController alloc]init];
    self.testView1 = [[UIView alloc]init];
    self.testView2 = [[UIView alloc]init];
    
}

- (void)tearDown {
    self.testController = nil;
    self.testView1 = nil;
    self.testView2 = nil;;
    
    [super tearDown];
}

-(void)testViewControllerNonNil {
    XCTAssertNotNil(self.testController, @"self.testController is nil!");
}


@end
