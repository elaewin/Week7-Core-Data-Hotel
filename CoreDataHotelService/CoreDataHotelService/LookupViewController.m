//
//  LookupViewController.m
//  CoreDataHotelService
//
//  Created by Erica Winberry on 11/30/16.
//  Copyright © 2016 Erica Winberry. All rights reserved.
//

#import "LookupViewController.h"
#import "Hotel+CoreDataClass.h"
#import "Room+CoreDataClass.h"
#import "AppDelegate.h"
#import "AutoLayout.h"
#import "Guest+CoreDataClass.h"
#import "Reservation+CoreDataClass.h"
#import "Hotel+CoreDataClass.h"
#import "NSString+RegexStringValidation.h"


@interface LookupViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property(strong, nonatomic)NSFetchedResultsController *reservations;
@property(strong, nonatomic)UITableView *tableView;
@property(strong, nonatomic)UISearchBar *searchBar;


@end

@implementation LookupViewController

-(void)loadView {
    [super loadView];
    
    self.tableView = [[UITableView alloc]init];
    self.searchBar = [[UISearchBar alloc]init];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
    
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.searchBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.searchBar];
    
    [self setTitle:@"Reservations"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

    [self setupLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

-(NSFetchedResultsController *)getReservations {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Reservation"];
    request.predicate = [NSPredicate predicateWithFormat:@"guest.email == %@", self.searchBar.text];
    NSLog(@"Search bar text: %@", self.searchBar.text);
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES]];
    
    NSError *requestError;
    
    _reservations = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:@"reservation.guest.email" cacheName:nil];
    
    [_reservations performFetch:&requestError];
    
    if(requestError) {
        NSLog(@"Error fetching reservations for guest %@", self.searchBar.text);
    }
    
    if (self.reservations.sections.count == 0) {
        UIAlertController *noReservationsAlert = [UIAlertController alertControllerWithTitle:@"Sorry..." message:@"I can't find any reservations under that email address." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        
        [noReservationsAlert addAction:okAction];
        
        [self presentViewController:noReservationsAlert animated:YES completion:nil];
    }
    
    return _reservations;
}

-(void)setupLayout {
    
    CGFloat navAndStatusBarHeight = [self navBarHeight] + [self statusBarHeight];
    
    NSDictionary *views = @{@"searchBar": self.searchBar, @"tableView": self.tableView};
    
    NSDictionary *metrics = @{@"navAndStatusBarHeight": [NSNumber numberWithFloat: navAndStatusBarHeight]};
    
    [AutoLayout createConstraintsWithVFLFor:views withMetricsDictionary:metrics withFormat:@"V:|-navAndStatusBarHeight-[searchBar]-[tableView]|"];
    
    [AutoLayout createLeadingConstraintFrom:self.searchBar toView:self.view];
    [AutoLayout createTrailingConstraintFrom:self.searchBar toView:self.view];
    
    [AutoLayout createLeadingConstraintFrom:self.tableView toView:self.view];
    [AutoLayout createTrailingConstraintFrom:self.tableView toView:self.view];
}

#pragma mark - Data Source Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.reservations.sections.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sections = [self.reservations sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSArray *sections = [self.reservations sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    
    Room *room = [[sectionInfo objects] objectAtIndex:section];
    
    return room.hotel.name;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    Reservation *reservation = [self.reservations objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Reservation At: %@\nBegins: %@\nEnds: %@\nRoom: %i (%i beds)\nCost Per Night: $%.2f",
                           reservation.room.hotel,
                           [self getReadableDatefor:reservation.startDate withFormat:NSDateFormatterMediumStyle],
                           [self getReadableDatefor:reservation.endDate withFormat:NSDateFormatterMediumStyle],
                           reservation.room.roomNumber,
                           reservation.room.beds,
                           reservation.room.rate.floatValue];
    
    return cell;
}

#pragma mark - TableView Delegate Methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

#pragma mark - Search Bar Delegate Methods

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if(searchText > 0) {        
        if (![searchText isValid]) {
            NSUInteger lastIndex = [searchText characterAtIndex:([searchText length] - 1)];
            searchBar.text = [searchText substringToIndex:lastIndex];
        } else {
            [searchBar setShowsSearchResultsButton:YES];
        }
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSString *searchText = self.searchBar.text;
    
    if ([searchText isEqual: @""]) {
        //put alert here if nothing in search bar?
        return;
    }
    
    [self getReservations];
    
    
    [self.searchBar resignFirstResponder];
}

@end







