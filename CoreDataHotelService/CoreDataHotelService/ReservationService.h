//
//  ReservationService.h
//  CoreDataHotelService
//
//  Created by Erica Winberry on 11/30/16.
//  Copyright © 2016 Erica Winberry. All rights reserved.
//

@import UIKit;
#import "AppDelegate.h"
#import "Hotel+CoreDataClass.h"
#import "Room+CoreDataClass.h"
#import "Guest+CoreDataClass.h"
#import "Reservation+CoreDataClass.h"

@interface ReservationService : NSObject

// get available rooms
+(NSFetchedResultsController *)getAvailableRoomsFor:(NSDate *)startDate through:(NSDate *)endDate;

// book a reservation
+(BOOL)bookAReservationFor:(NSDate *)startDate through:(NSDate *)endDate atHotel:(Hotel *)hotel inRoom:(Room *)room withFirstName:(NSString *)firstName andLastName:(NSString *)lastName atEmail:(NSString *)email;

// show a user's reservations
+(NSFetchedResultsController *)getReservationsForUserWithEmail:(NSString *)email;

@end
