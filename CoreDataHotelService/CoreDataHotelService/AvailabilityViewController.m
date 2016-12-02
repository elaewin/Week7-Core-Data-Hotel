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
#import "ReservationService.h"
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
        
        [ReservationService getAvailableRoomsFor:self.startDate through:self.endDate forFRC:_availableRooms];
    
//        if (self.availableRooms.sections.count == 0) {
//            UIAlertController *alertController = [UIAlertController
//                                                  alertControllerWithTitle:@"Sorry"
//                                                  message:@"No rooms are available for the dates you have selected."
//                                                  preferredStyle:UIAlertControllerStyleAlert];
//            
//            UIAlertAction *selectNewAction = [UIAlertAction actionWithTitle:@"Pick New Dates" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                
//                [self.navigationController popViewControllerAnimated:YES];
//            }];
//            
//            [alertController addAction:selectNewAction];
//            
//            [self presentViewController:alertController animated:YES completion:nil];
//            
//            return nil;
//        }
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










