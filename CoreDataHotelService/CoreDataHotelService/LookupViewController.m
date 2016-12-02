//
//  LookupViewController.m
//  CoreDataHotelService
//
//  Created by Erica Winberry on 11/30/16.
//  Copyright © 2016 Erica Winberry. All rights reserved.
//

#import <Flurry.h>

#import "LookupViewController.h"
#import "ReservationTableViewCell.h"

#import "AppDelegate.h"
#import "AutoLayout.h"

#import "Hotel+CoreDataClass.h"
#import "Room+CoreDataClass.h"
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
    
    [self setTitle:@"Reservations"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // get rid of extra space at top of tableView (might be from NavController)
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupTableView];
    [self setupSearchBar];
    [self setupLayout];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Flurry logEvent:@"Timed_User_Search" timed:YES];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

// Move implementation of checking reservations to ReservationService
-(NSFetchedResultsController *)getReservations {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Reservation"];
    request.predicate = [NSPredicate predicateWithFormat:@"guest.email == %@", self.searchBar.text];
    NSLog(@"Search bar text: %@", self.searchBar.text);
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES]];
    
    NSError *requestError;
    
    _reservations = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:@"guest.email" cacheName:nil];
    
    [_reservations performFetch:&requestError];
    
    if(requestError) {
        NSLog(@"Error fetching reservations for guest %@", self.searchBar.text);
        return nil;
    }
    
    if (self.reservations.sections.count == 0) {
        UIAlertController *noReservationsAlert = [UIAlertController alertControllerWithTitle:@"Sorry..." message:@"I can't find any reservations under that email address." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        
        [noReservationsAlert addAction:okAction];
        
        [self presentViewController:noReservationsAlert animated:YES completion:nil];
    }
    
    NSLog(@"Number of sections: %lu", self.reservations.sections.count);
    
    [Flurry logEvent:@"User_Searched_Reservations"];
    [Flurry endTimedEvent:@"Timed_User_Search" withParameters:nil];
    
    return _reservations;
}

-(void)setupTableView {
    self.tableView = [[UITableView alloc]init];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[ReservationTableViewCell class] forCellReuseIdentifier:@"cell"];
}

-(void)setupSearchBar {
    
    self.searchBar = [[UISearchBar alloc]init];
    self.searchBar.delegate = self;
    
    [self.searchBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    self.searchBar.placeholder = @"Enter your email to search for reservations.";
    
    [self.view addSubview:self.searchBar];
}

-(void)setupLayout {
    
    CGFloat navAndStatusBarHeight = [self navBarHeight] + [self statusBarHeight];
    
    NSDictionary *views = @{@"searchBar": self.searchBar, @"tableView": self.tableView};
    
    NSDictionary *metrics = @{@"navAndStatusBarHeight": [NSNumber numberWithFloat: navAndStatusBarHeight]};
    
    [AutoLayout createConstraintsWithVFLFor:views
                      withMetricsDictionary:metrics
                                 withFormat:@"V:|-navAndStatusBarHeight-[searchBar][tableView]|"];
    
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
    
    NSLog(@"Should be %lu rows in the section.", (unsigned long)[sectionInfo numberOfObjects]);
    return [sectionInfo numberOfObjects];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Your Reservations";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ReservationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
//    if (!cell) {
//        cell = [[ReservationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//    }
    
    Reservation *reservation = [self.reservations objectAtIndexPath:indexPath];
    
    cell.reservation = reservation;
    
//    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    cell.textLabel.numberOfLines = 0;
//    cell.textLabel.font = [UIFont systemFontOfSize:17];
    
    return cell;
}

#pragma mark - TableView Delegate Methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

#pragma mark - Search Bar Delegate Methods

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if([searchText length] > 0) {
        if (![searchText isValid]) {
            searchBar.text = [searchText substringToIndex:([searchText length] - 1)];
        } else {
            [searchBar setShowsSearchResultsButton:YES];
        }
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSString *searchText = self.searchBar.text.lowercaseString;
    
    if ([searchText isEqual: @""]) {
        //put alert here if nothing in search bar?
        return;
    }
    
    [self getReservations];
    [self.tableView reloadData];
    
    [self.searchBar resignFirstResponder];
}

@end







