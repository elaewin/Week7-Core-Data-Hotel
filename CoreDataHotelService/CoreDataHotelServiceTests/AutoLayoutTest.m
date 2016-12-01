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

@property(strong, nonatomic) UIButton *button1;
@property(strong, nonatomic) UIButton *button2;

@end

@implementation AutoLayoutTest

- (void)setUp {
    [super setUp];
    
    self.testController = [[UIViewController alloc]init];
    self.testView1 = [[UIView alloc]init];
    self.testView2 = [[UIView alloc]init];
    self.button1 = [[UIButton alloc]init];
    self.button2 = [[UIButton alloc]init];
    
    [self.testController.view addSubview:self.testView1];
    [self.testController.view addSubview:self.testView2];
    [self.testController.view addSubview:self.button1];
    [self.testController.view addSubview:self.button2];
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

-(void)testCreateConstraintsWithVFLReturnsConstraintsArray {
    
    NSDictionary *views = @{@"button1": self.button1, @"button2": self.button2};
    
    int count = 0;
    
    NSArray *constraints = [AutoLayout createConstraintsWithVFLFor:views withMetricsDictionary:nil withFormat:@"H:|-10-[button1]-[button2(==button1)]-10-|"];
    
    for (id constraint in constraints) {
        if (![constraint isKindOfClass:[NSLayoutConstraint class]]) {
            count++;
        }
    }
    XCTAssert(count == 0, @"Array contains object that is not an NSLayoutConstraint.");
}

// Full Layout constraints without VFL (does the same as the above VFL method)

-(void)testActivateFullViewConstraintsWithoutVFLReturnsConstraintsArray {
    
    NSArray *constraints = [AutoLayout activateFullViewConstraintsFrom:self.testView1 toView:self.testController.view];
    
    int count = 0;
    
    for (id constraint in constraints) {
        if (![constraint isMemberOfClass:[NSLayoutConstraint class]]) {
            count++;
        }
    }
    XCTAssertEqual(count, 0, @"Array contains object that is not an NSLayoutConstraint.");
}

-(void)testCreateSingleConstraintMethodsReturnConstraint {
    NSLayoutConstraint *leading = [AutoLayout createLeadingConstraintFrom:self.testView1 toView:self.testController.view];
    NSLayoutConstraint *trailing = [AutoLayout createTrailingConstraintFrom:self.testView1 toView:self.testController.view];
    NSLayoutConstraint *equalHeights = [AutoLayout createEqualHeightConstraintFrom:self.testView1 toView:self.testController.view];
    NSLayoutConstraint *equalWithMultiplier = [AutoLayout createEqualHeightConstraintFrom:self.testView1 toView:self.testController.view withMultiplier:1.5];
    
    XCTAssert([leading isKindOfClass:[NSLayoutConstraint class]], @"Attempt to set leading constraint does NOT return an NSLayoutConstraint.");
    XCTAssert([trailing isKindOfClass:[NSLayoutConstraint class]], @"Attempt to set trailing constraint does NOT return an NSLayoutConstraint.");
    XCTAssert([equalHeights isKindOfClass:[NSLayoutConstraint class]], @"Attempt to set equal heights constraint does NOT return an NSLayoutConstraint.");
    XCTAssert([equalWithMultiplier isKindOfClass:[NSLayoutConstraint class]], @"Attempt to set equal heights constraint (with multiplier) does NOT return an NSLayoutConstraint.");
}


-(void)testCreateEqualHeightConstraintWithMultiplierAtOne {
    NSLayoutConstraint *withMultiplierAt1 = [AutoLayout createEqualHeightConstraintFrom:self.testView1 toView:self.testController.view withMultiplier:1.0];
    
    NSLayoutConstraint *withoutMultiplier = [AutoLayout createEqualHeightConstraintFrom:self.testView1 toView:self.testController.view];
    
    XCTAssertEqual([withMultiplierAt1 multiplier], [withoutMultiplier multiplier], @"Constraints do NOT have the same multiplier!");
}

@end










