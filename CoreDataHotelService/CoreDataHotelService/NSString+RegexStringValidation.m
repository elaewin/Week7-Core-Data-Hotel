//
//  NSString+RegexStringValidation.m
//  CoreDataHotelService
//
//  Created by Erica Winberry on 11/30/16.
//  Copyright © 2016 Erica Winberry. All rights reserved.
//

#import "NSString+RegexStringValidation.h"

@implementation NSString (RegexStringValidation)

-(BOOL)isValid {
    
    NSString *regexPattern = @"[^0-9a-z@_\.]";
    
    NSError *regexError;
    
    NSRegularExpression *regex = [[NSRegularExpression alloc]initWithPattern:regexPattern options:NSRegularExpressionCaseInsensitive error:&regexError];
    
    NSRange range = NSMakeRange(0, self.length);
    
    NSUInteger matches = [regex numberOfMatchesInString:self options:NSMatchingReportCompletion range:range];
        
    if (matches > 0) {
        return false;
    }
    return true;
}


@end
