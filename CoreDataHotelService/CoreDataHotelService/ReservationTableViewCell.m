//
//  ReservationTableViewCell.m
//  CoreDataHotelService
//
//  Created by Erica Winberry on 12/1/16.
//  Copyright © 2016 Erica Winberry. All rights reserved.
//

#import "AutoLayout.h"
//#import "UIViewController+AutoLayoutConstants.h"

#import "ReservationTableViewCell.h"

@interface ReservationTableViewCell ()

@property(strong, nonatomic)UILabel *hotelLabel;
@property(strong, nonatomic)UILabel *guestLabel;
@property(strong, nonatomic)UILabel *datesLabel;
@property(strong, nonatomic)UILabel *roomLabel;

@end

@implementation ReservationTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    [self setupCellLabels];
    [self layoutIfNeeded];
    
    return self;
}

//-(void)layoutSubviews {
//    [super layoutSubviews];
//    
//
//}

-(void)setReservation:(Reservation *)reservation {
    [self setupCell];
    _reservation = reservation;
}

-(void)setupCell {
    
    self.hotelLabel.text = [NSString stringWithFormat:@"Reservation At: %@", self.reservation.room.hotel.name];
    
    self.guestLabel.text = [NSString stringWithFormat:@"Booked by: %@ %@", self.reservation.guest.firstName, self.reservation.guest.lastName];
    
    self.datesLabel.text = [NSString stringWithFormat:@"Begins: %@\nEnds: %@",
                            self.reservation.startDate, self.reservation.endDate];
    
    self.roomLabel.text = [NSString stringWithFormat:@"Room: %i (%i beds)\nCost Per Night: $%.2f",
                            self.reservation.room.roomNumber,
                            self.reservation.room.beds,
                            self.reservation.room.rate.floatValue];
}

-(void)setupCellLabels {

    self.hotelLabel = [[UILabel alloc]init];
    self.guestLabel = [[UILabel alloc]init];
    self.roomLabel = [[UILabel alloc]init];
    self.datesLabel = [[UILabel alloc]init];
    
    UILabel *hotelLabel = self.hotelLabel;
    UILabel *guestLabel = self.guestLabel;
    UILabel *roomLabel = self.roomLabel;
    UILabel *datesLabel = self.datesLabel;
    
    NSDictionary *views = @{@"hotelLabel": hotelLabel, @"guestLabel": guestLabel, @"roomLabel": roomLabel, @"datesLabel": datesLabel};
    
    [hotelLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [guestLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [roomLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [datesLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self.contentView addSubview:hotelLabel];
    [self.contentView addSubview:guestLabel];
    [self.contentView addSubview:datesLabel];
    [self.contentView addSubview:roomLabel];
    
    [AutoLayout createConstraintsWithVFLFor:views
                      withMetricsDictionary:nil
                                 withFormat:@"V:|-[hotelLabel]-[datesLabel]-[guestLabel]-[roomLabel]-|"];
    
    [AutoLayout createConstraintsWithVFLFor:views withMetricsDictionary:nil withFormat:@"H:|-[hotelLabel]-|"];
    [AutoLayout createConstraintsWithVFLFor:views withMetricsDictionary:nil withFormat:@"H:|-[datesLabel]-|"];
    [AutoLayout createConstraintsWithVFLFor:views withMetricsDictionary:nil withFormat:@"H:|-[guestLabel]-|"];
    [AutoLayout createConstraintsWithVFLFor:views withMetricsDictionary:nil withFormat:@"H:|-[roomLabel]-|"];
    
    hotelLabel.numberOfLines = 0;
    guestLabel.numberOfLines = 0;
    roomLabel.numberOfLines = 0;
    datesLabel.numberOfLines = 0;
    
}

-(void)formatLabel:(UILabel *)label {
    //format label stuff here.
}


@end
