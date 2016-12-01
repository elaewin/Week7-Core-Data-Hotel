//
//  AvailabilityViewController.m
//  CoreDataHotelService
//
//  Created by Erica Winberry on 11/29/16.
//  Copyright © 2016 Erica Winberry. All rights reserved.
//

#import "AvailabilityViewController.h"
#import "BookViewController.h"
#import "AppDelegate.h"
#import "AutoLayout.h"
#import "Reservation+CoreDataClass.h"
#import "Room+CoreDataClass.h"
#import "Hotel+CoreDataClass.h"

@interface AvailabilityViewController () <UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) NSFetchedResultsController *availableRooms;

@end

@implementation AvailabilityViewController

// move implementation in this method to ReservationService
-(NSFetchedResultsController *)availableRooms {
    
    // this is how you do lazy properties in Obj-C.
    if (!_availableRooms) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
    
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Reservation"];
        
        // Have to get all of the rooms with reservations FIRST.
        request.predicate = [NSPredicate predicateWithFormat:@"startDate <= %@ AND endDate >= %@", self.startDate, self.endDate];
        
        NSError *requestError;
        NSArray *results = [context executeFetchRequest:request error:&requestError];
        if (requestError) {
            NSLog(@"Error with reservation fetch request.");
            return nil;
        }
        
        // This is the array of rooms WITH reservations during the requested dates, so these rooms are unavailable!
        NSMutableArray *unavailableRooms = [[NSMutableArray alloc]init];
        for (Reservation *reservation in results) {
            [unavailableRooms addObject:reservation.room];
        }
        
        // Now get all of the rooms that are not already reserved.
        NSFetchRequest *roomRequest = [NSFetchRequest fetchRequestWithEntityName:@"Room"];
        roomRequest.predicate = [NSPredicate predicateWithFormat:@"NOT self IN %@", unavailableRooms];
        
        // sort rooms by hotel, then sort by room number.
        roomRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"hotel.name" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"roomNumber" ascending:YES]];
        
        NSError *roomRequestError;

        _availableRooms = [[NSFetchedResultsController alloc]initWithFetchRequest:roomRequest managedObjectContext:context sectionNameKeyPath:@"hotel.name" cacheName:nil];
        
        [_availableRooms performFetch:&roomRequestError];
        
        if (roomRequestError) {
            NSLog(@"There was an error requesting available rooms.");
        }
    
        if (self.availableRooms.sections.count == 0) {
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Sorry"
                                                  message:@"No rooms are available for the dates you have selected."
                                                  preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *selectNewAction = [UIAlertAction actionWithTitle:@"Pick New Dates" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            [alertController addAction:selectNewAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
            return nil;
        }
    }

    return _availableRooms;
}

-(void)loadView {
    [super loadView];
    
    [self setupTableView];
    [self setTitle:@"Available Rooms"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
}

-(void)setupTableView {
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [AutoLayout activateFullViewConstraintsUsingVFLFor:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    
}

#pragma mark - Data Source Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // id here has to conform to the NSFetchedResultsSectionInfo protocol.
    NSArray *sections = [self.availableRooms sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.availableRooms.sections.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSArray *sections = [self.availableRooms sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    
    Room *room = [[sectionInfo objects] objectAtIndex:section];
    
    return room.hotel.name;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    Room *room = [self.availableRooms objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Room: %i (%i beds, $%.2f/night)", room.roomNumber, room.beds, room.rate.floatValue];
    
    return cell;
}

#pragma mark - Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Room *room = [self.availableRooms objectAtIndexPath:indexPath];
    
    BookViewController *bookVC = [[BookViewController alloc]init];
    bookVC.room = room;
    bookVC.startDate = self.startDate;
    bookVC.endDate = self.endDate;
    
    [self.navigationController pushViewController:bookVC animated:YES];
    
}

@end










