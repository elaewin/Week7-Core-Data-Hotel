//
//  UIViewController+AutoLayoutConstants.h
//  CoreDataHotelService
//
//  Created by Erica Winberry on 11/29/16.
//  Copyright © 2016 Erica Winberry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (AutoLayoutConstants)

-(CGFloat)navBarHeight;
-(CGFloat)statusBarHeight;

//// MARK: Metrics Dictionary
//-(CGFloat)margin;
//-(CGFloat)buttonHeight;
//-(CGFloat)topPadding;
//
//-(NSDictionary *)metricsDictionary;

// Date formatter
-(NSString *)getReadableDatefor:(NSDate *)date withFormat:(NSDateFormatterStyle)format;

@end
