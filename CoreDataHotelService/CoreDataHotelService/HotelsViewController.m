//
//  HotelsViewController.m
//  CoreDataHotelService
//
//  Created by Erica Winberry on 11/28/16.
//  Copyright © 2016 Erica Winberry. All rights reserved.
//

#import "HotelsViewController.h"
#import "AutoLayout.h"
#import "AppDelegate.h"
#import "Hotel+CoreDataClass.h"

#import "RoomsViewController.h"
#import "Room+CoreDataClass.h"

@interface HotelsViewController () <UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic)NSArray *dataSource;
@property(strong, nonatomic)UITableView *tableView;

@end

@implementation HotelsViewController

-(void)loadView {
    [super loadView];
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // don't translate the frame/bounds/etc. into constraints
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [AutoLayout activateFullViewConstraintsUsingVFLFor:self.tableView];
 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Hotels"];
    // Do any additional setup after loading the view.
}

-(NSArray *)dataSource {
    
    if (!_dataSource) {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSManagedObjectContext *context = delegate.persistentContainer.viewContext;
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Hotel"];
        
        NSError *fetchError;
        
        _dataSource = [context executeFetchRequest:request error:&fetchError];
        
        if (fetchError) {
            NSLog(@"Error fetching hotels from Core Data.");
        }
    }
    
    return _dataSource;
}

#pragma mark - Data Source Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    Hotel *hotel = self.dataSource[indexPath.row];
    
    cell.textLabel.text = hotel.name;
    
    return cell;
}

#pragma mark - Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RoomsViewController *roomsVC = [[RoomsViewController alloc]init];
    
    Hotel *selectedHotel = self.dataSource[indexPath.row];
    
    roomsVC.hotel = selectedHotel;
    
    NSLog(@"%@ selected from hotel list.", selectedHotel.name);
    
    [self.navigationController pushViewController:roomsVC animated:YES];
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIImageView *hotelHeaderView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotel"]];
    hotelHeaderView.contentMode = UIViewContentModeScaleAspectFill;
    hotelHeaderView.clipsToBounds = YES;
    return hotelHeaderView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 128.0;
    
}

@end
