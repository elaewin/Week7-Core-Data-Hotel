//
//  UIViewController+AutoLayoutConstants.m
//  CoreDataHotelService
//
//  Created by Erica Winberry on 11/29/16.
//  Copyright © 2016 Erica Winberry. All rights reserved.
//

#import "UIViewController+AutoLayoutConstants.h"

@implementation UIViewController (AutoLayoutConstants)

-(CGFloat)navBarHeight{
    return CGRectGetHeight(self.navigationController.navigationBar.frame);
}

-(CGFloat)statusBarHeight{
    return 20;
}

//// MARK: Metrics Dictionary
//
//-(CGFloat)buttonHeight{
//    
//    return 20.0;
//}
//
//-(CGFloat)margin{
//    return 20.0;
//}
//
//CGFloat *navAndStatusBarHeight = navBarHeight + statusBarHeight;
//
//-(CGFloat)topPadding{
//    
//    return 20.0;
//}
//
//
//-(NSDictionary *)metricsDictionary {
//    NSDictionary *metrics = @{@"navHeightPadding": [NSNumber numberWithFloat:navAndStatusBarHeight], @"buttonHeight":  [NSNumber numberWithFloat:buttonHeight]};
//    return metrics;
//}

// Date formatter
-(NSString *)getReadableDatefor:(NSDate *)date withFormat:(NSDateFormatterStyle)format {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = format;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    return [dateFormatter stringFromDate:date];
}
@end
