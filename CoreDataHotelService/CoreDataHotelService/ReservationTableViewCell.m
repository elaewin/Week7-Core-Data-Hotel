//
//  ReservationTableViewCell.m
//  CoreDataHotelService
//
//  Created by Erica Winberry on 12/1/16.
//  Copyright © 2016 Erica Winberry. All rights reserved.
//

#import "AutoLayout.h"
#import "ReservationTableViewCell.h"

#import "Hotel+CoreDataClass.h"
#import "Room+CoreDataClass.h"
#import "Guest+CoreDataClass.h"

@interface ReservationTableViewCell ()

@property(strong, nonatomic)UILabel *hotelLabel;
@property(strong, nonatomic)UILabel *datesLabel;
@property(strong, nonatomic)UILabel *guestLabel;
@property(strong, nonatomic)UILabel *roomLabel;

@end

@implementation ReservationTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.hotelLabel = [[UILabel alloc]init];
    self.guestLabel = [[UILabel alloc]init];
    self.roomLabel = [[UILabel alloc]init];
    self.datesLabel = [[UILabel alloc]init];
    
    [self.contentView addSubview:self.hotelLabel];
    [self.contentView addSubview:self.guestLabel];
    [self.contentView addSubview:self.datesLabel];
    [self.contentView addSubview:self.roomLabel];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    [self setCellText];
    
    NSDictionary *views = @{@"hotelLabel": self.hotelLabel, @"guestLabel": self.guestLabel, @"roomLabel": self.roomLabel, @"datesLabel": self.datesLabel};
    
    [self formatLabel:self.hotelLabel];
    [self formatLabel:self.guestLabel];
    [self formatLabel:self.roomLabel];
    [self formatLabel:self.datesLabel];
    
    [AutoLayout createConstraintsWithVFLFor:views
                      withMetricsDictionary:nil
                                 withFormat:@"V:|-[hotelLabel]-[datesLabel]-[guestLabel]-[roomLabel]-|"];
    
    [AutoLayout createConstraintsWithVFLFor:views withMetricsDictionary:nil withFormat:@"H:|-[hotelLabel]-|"];
    [AutoLayout createConstraintsWithVFLFor:views withMetricsDictionary:nil withFormat:@"H:|-[datesLabel]-|"];
    [AutoLayout createConstraintsWithVFLFor:views withMetricsDictionary:nil withFormat:@"H:|-[guestLabel]-|"];
    [AutoLayout createConstraintsWithVFLFor:views withMetricsDictionary:nil withFormat:@"H:|-[roomLabel]-|"];
    
}

-(void)setCellText {
    
    self.hotelLabel.text = [NSString stringWithFormat:@"Reservation At: %@ - Located in %@", self.reservation.room.hotel.name, self.reservation.room.hotel.location];
    
    self.datesLabel.text = [NSString stringWithFormat:@"Begins: %@ - Ends: %@",
                            [self getReadableDatefor:self.reservation.startDate withFormat:NSDateFormatterMediumStyle],
                            [self getReadableDatefor:self.reservation.endDate withFormat:NSDateFormatterMediumStyle]];
    
    self.guestLabel.text = [NSString stringWithFormat:@"Booked by: %@ %@", self.reservation.guest.firstName, self.reservation.guest.lastName];
    
    self.roomLabel.text = [NSString stringWithFormat:@"Room: %i (%i beds) - Cost Per Night: $%.2f",
                            self.reservation.room.roomNumber,
                            self.reservation.room.beds,
                            self.reservation.room.rate.floatValue];
}


-(void)formatLabel:(UILabel *)label {
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:14];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [label setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
}

-(NSString *)getReadableDatefor:(NSDate *)date withFormat:(NSDateFormatterStyle)format {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = format;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    return [dateFormatter stringFromDate:date];
}


@end
