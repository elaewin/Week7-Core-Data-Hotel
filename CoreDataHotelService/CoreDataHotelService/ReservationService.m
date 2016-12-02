//
//  ReservationService.m
//  CoreDataHotelService
//
//  Created by Erica Winberry on 11/30/16.
//  Copyright © 2016 Erica Winberry. All rights reserved.
//

#import <Flurry.h>
#import "ReservationService.h"

@implementation ReservationService

// get available rooms
+(NSFetchedResultsController *)getAvailableRoomsFor:(NSDate *)startDate through:(NSDate *)endDate forFRC:(NSFetchedResultsController *)fetchedResultsController {

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Reservation"];
    
    // Get a list of all rooms WITH reservations.
    request.predicate = [NSPredicate predicateWithFormat:@"startDate <= %@ AND endDate >= %@", startDate, endDate];
    
    NSError *requestError;
    NSArray *results = [context executeFetchRequest:request error:&requestError];
    if (requestError) {
        NSLog(@"Error with reservation fetch request.");
        return nil;
    }

    // Add the unavailable rooms to a mutable array.
    NSMutableArray *unavailableRooms = [[NSMutableArray alloc]init];
    for (Reservation *reservation in results) {
        [unavailableRooms addObject:reservation.room];
    }
    
    // Now fetch all of the rooms, and use the predicate to remove the rooms that are already reserved.
    NSFetchRequest *roomRequest = [NSFetchRequest fetchRequestWithEntityName:@"Room"];
    roomRequest.predicate = [NSPredicate predicateWithFormat:@"NOT self IN %@", unavailableRooms];
    
    // Sort rooms by hotel, then sort by room number
    roomRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"hotel.name" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"roomNumber" ascending:YES]];
    
    NSError *roomRequestError;
    
    fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:roomRequest managedObjectContext:context sectionNameKeyPath:@"hotel.name" cacheName:nil];
    
    [fetchedResultsController performFetch:&roomRequestError];
    
    if (roomRequestError) {
        NSLog(@"There was an error requesting available rooms.");
    }
    
    return fetchedResultsController;
}

// book a reservation
+(BOOL)bookAReservationFor:(NSDate *)startDate
                   through:(NSDate *)endDate
                   atHotel:(Hotel *)hotel
                    inRoom:(Room *)room
             withFirstName:(NSString *)firstName
               andLastName:(NSString *)lastName
                   atEmail:(NSString *)email {
    
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
    reservation.guest.email = email.lowercaseString;
    
    NSError *saveError;
    
    [context save:&saveError];
    
    if (saveError) {
        NSLog(@"Error saving new reservation.");
        return false;
    } else {
        NSLog(@"Saved reservation successfully.");
        NSDictionary *parameters = @{@"Guest":reservation.guest.objectID};
        [Flurry logEvent:@"Reservation_Booked" withParameters:parameters];
    }
    return true;
}

// show a user's reservations
//+(NSFetchedResultsController *)getReservationsForUserWithEmail:(NSString *)email{
//}

@end
