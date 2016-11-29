//
//  RoomsViewController.m
//  CoreDataHotelService
//
//  Created by Erica Winberry on 11/28/16.
//  Copyright © 2016 Erica Winberry. All rights reserved.
//

#import "RoomsViewController.h"
#import "AutoLayout.h"
#import "AppDelegate.h"
#import "Room+CoreDataClass.h"
#import "Hotel+CoreDataClass.h"

@interface RoomsViewController () <UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic)NSArray *dataSource;
@property(strong, nonatomic)UITableView *tableView;

@end

@implementation RoomsViewController

-(void)loadView {
    [super loadView];
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.dataSource = self;
    self.dataSource = self.hotel.rooms.allObjects;
    self.tableView.delegate = self;
    
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

    [AutoLayout activateFullViewConstraintsUsingVFLFor:self.tableView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Rooms"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data Source Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.hotel.rooms.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    Room *room = self.dataSource[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Room %hd (%hd beds - $%@.00 per night)", room.roomNumber, room.beds, room.rate];
    
    return cell;
}

#pragma mark - Delegate Methods

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIImageView *roomsHeaderView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"room"]];
    roomsHeaderView.contentMode = UIViewContentModeScaleAspectFill;
    roomsHeaderView.clipsToBounds = YES;
    return roomsHeaderView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 128.0;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
