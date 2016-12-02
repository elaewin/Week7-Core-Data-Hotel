//
//  ReservationTableViewCell.h
//  CoreDataHotelService
//
//  Created by Erica Winberry on 12/1/16.
//  Copyright © 2016 Erica Winberry. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Reservation+CoreDataClass.h"

@interface ReservationTableViewCell : UITableViewCell

@property(strong, nonatomic)Reservation *reservation;

@end
