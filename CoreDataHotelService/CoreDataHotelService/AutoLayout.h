//
//  AutoLayout.h
//  CoreDataHotelService
//
//  Created by Erica Winberry on 11/28/16.
//  Copyright © 2016 Erica Winberry. All rights reserved.
//

@import UIKit;

@interface AutoLayout : NSObject

// create generic constraints
+(NSLayoutConstraint *)createGenericConstraintFrom:(UIView *)view toView:(UIView *)superView withAttribute:(NSLayoutAttribute)attribute andMultiplier:(CGFloat)multiplier;

+(NSLayoutConstraint *)createGenericConstraintFrom:(UIView *)view toView:(UIView *)superView withAttribute:(NSLayoutAttribute)attribute;

// create full view constraints
+(NSArray *)activateFullViewConstraintsUsingVFLFor:(UIView *)view;
+(NSArray *)activateFullViewConstraintsFrom:(UIView *)view toView:(UIView *)superView;

// VFL constraints
+(NSArray *)createConstraintsWithVFLFor:(NSDictionary *)viewDictionary withMetricsDictionary:(NSDictionary *)metrics withFormat:(NSString *)constraintFormat;

//leading constraint
+(NSLayoutConstraint *)createLeadingConstraintFrom:(UIView *)view toView:(UIView *)superView;

//trailing constraint
+(NSLayoutConstraint *)createTrailingConstraintFrom:(UIView *)view toView:(UIView *)superView;

//equal height constraint
+(NSLayoutConstraint *)createEqualHeightConstraintFrom:(UIView *)view toView:(UIView *)otherView;

+(NSLayoutConstraint *)createEqualHeightConstraintFrom:(UIView *)view toView:(UIView *)otherView withMultiplier:(CGFloat)multiplier;



@end
