//
//  ReservationService.m
//  CoreDataHotelService
//
//  Created by Erica Winberry on 11/30/16.
//  Copyright © 2016 Erica Winberry. All rights reserved.
//

#import "ReservationService.h"

@implementation ReservationService

// get available rooms
//+(NSFetchedResultsController *)getAvailableRoomsFor:(NSDate *)startDate through:(NSDate *)endDate {
//}

// book a reservation
+(BOOL)bookAReservationFor:(NSDate *)startDate through:(NSDate *)endDate atHotel:(Hotel *)hotel inRoom:(Room *)room withFirstName:(NSString *)firstName andLastName:(NSString *)lastName atEmail:(NSString *)email {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
    
    Reservation *reservation = [NSEntityDescription insertNewObjectForEntityForName:@"Reservation" inManagedObjectContext:context];
    
    reservation.startDate = startDate;
    reservation.endDate = endDate;
    reservation.room = room;
    
    // how to write reservation to room.reservations?
    room.reservations = [room.reservations setByAddingObject:reservation];
    
    reservation.guest = [NSEntityDescription insertNewObjectForEntityForName:@"Guest" inManagedObjectContext:context];
    
    reservation.guest.firstName = firstName;
    reservation.guest.lastName = lastName;
    reservation.guest.email = email;
    
    NSError *saveError;
    
    [context save:&saveError];
    
    if (saveError) {
        NSLog(@"Error saving new reservation.");
        return false;
    } else {
        NSLog(@"Saved reservation successfully.");
    }
    return true;
}

// show a user's reservations
//+(NSFetchedResultsController *)getReservationsForUserWithEmail:(NSString *)email{
//}

@end
