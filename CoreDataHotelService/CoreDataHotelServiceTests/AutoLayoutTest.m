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
    
    [self.testController.view addSubview:self.testView1];
    [self.testController.view addSubview:self.testView2];
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

-(void)testViewsAreNotEqual {
    XCTAssertNotEqual(self.testView1, self.testView2, @"testView1 is equal to testView2");
}

-(void)testViewClass {
    XCTAssert([self.testView1 isKindOfClass:[UIView class]], @"view1 is NOT a UIView.");
}

-(void)testCreateGenericConstraintFromViewToViewWithAttrAndMult {
    id constraint = [AutoLayout createGenericConstraintFrom:self.testView1 toView:self.testView2 withAttribute:NSLayoutAttributeTop andMultiplier:1.0];
    
    XCTAssert([constraint isMemberOfClass:[NSLayoutConstraint class]], @"constraint is NOT an NSLayoutConstraint Object.");
}

-(void)testActivateFullViewConstraintsWithVFLReturnsConstraintsArray {
    
    NSArray *constraints = [AutoLayout activateFullViewConstraintsUsingVFLFor:self.testView1];
    
    int count = 0;
    
    for (id constraint in constraints) {
        
        if (![constraint isKindOfClass:[NSLayoutConstraint class]]) {
            count++;
        }
    }
    
    XCTAssert(count == 0, @"Array contains %i objects that are not NSLayoutConstraints", count);
}

@end
