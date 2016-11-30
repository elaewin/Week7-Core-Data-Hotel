//
//  AvailabilityViewController.m
//  CoreDataHotelService
//
//  Created by Erica Winberry on 11/29/16.
//  Copyright © 2016 Erica Winberry. All rights reserved.
//

#import "AppDelegate.h"
#import "AutoLayout.h"
#import "AvailabilityViewController.h"
#import "BookViewController.h"
#import "Reservation+CoreDataClass.h"
#import "Room+CoreDataClass.h"

@interface AvailabilityViewController () <UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) NSArray *availableRooms;

@end

@implementation AvailabilityViewController

-(NSArray *)availableRooms {
    
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
        
        NSError *roomRequestError;
        
        _availableRooms = [context executeFetchRequest:roomRequest error:&roomRequestError];
        
        if(roomRequestError) {
            NSLog(@"There was an error requesting available rooms.");
        }
    
        // if count of available rooms is 0 (no reservations) alert the user.
    
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

#pragma mark - Data Source Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.availableRooms.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    Room *room = self.availableRooms[indexPath.row];
    
    // add hotel name (because room #'s might be the same)
    cell.textLabel.text = [NSString stringWithFormat:@"Room: %i (%i beds, $%.2f/night)", room.roomNumber, room.beds, room.rate.floatValue];
    
    return cell;
}

#pragma mark - Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Room *room = self.availableRooms[indexPath.row];
    
    BookViewController *bookVC = [[BookViewController alloc]init];
    bookVC.room = room;
    bookVC.startDate = self.startDate;
    bookVC.endDate = self.endDate;
    
    [self.navigationController pushViewController:bookVC animated:YES];
    
}

@end










