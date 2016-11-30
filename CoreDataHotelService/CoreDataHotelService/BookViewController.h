//
//  BookViewController.h
//  CoreDataHotelService
//
//  Created by Erica Winberry on 11/29/16.
//  Copyright © 2016 Erica Winberry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Room+CoreDataClass.h"


@interface BookViewController : UIViewController

@property(strong, nonatomic) Room *room;
@property(strong, nonatomic) NSDate *startDate;
@property(strong, nonatomic) NSDate *endDate;

@end
