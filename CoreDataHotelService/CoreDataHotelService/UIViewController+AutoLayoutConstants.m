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

@end
