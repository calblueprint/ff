//
//  FFRecordDelivery.m
//  FFiPhoneApp
//
//  Created by lee on 8/11/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "FFRecordDelivery.h"
#import "FFRecordUser.h"

#import "FFDataDelivery.h"
#import "FFDataUser.h"

#import "NSDate+FFDateUtilities.h"
#import "NSDictionary+FFNull.h"
#import "FFError.h"
#import "FFValue.h"

@implementation FFRecordDelivery

+ (void)loadDataToModelObject:(FFDataDelivery *)modelObject fromJSONObject:(NSDictionary *)jsonObject
{
    FFDataDelivery *model = modelObject;
    NSDictionary *json = jsonObject;
    
    [model setDeliveryID:[[json ff_objectForKey:@"id"] unsignedIntegerValue]];
    [model setDonationID:[[json ff_objectForKey:@"donation_id"] unsignedIntegerValue]];
    
    // Set donee
    FFDataUser *donee = [FFDataUser new];
    [FFRecordUser loadDataToModelObject:donee fromJSONObject:[json ff_objectForKey:@"donee"]];
    [model setDonee:donee];
    
    // Set recovery org
    FFDataUser *recoveryOrg = [FFDataUser new];
    [FFRecordUser loadDataToModelObject:recoveryOrg fromJSONObject:[json ff_objectForKey:@"recovery_org"]];
    [model setRecoveryOrg:recoveryOrg];
    
    // Pickup time
    [model setPickupTime:[NSDate ff_dateFromString:[json ff_objectForKey:@"pick_up_time"]
                                            withFormat:FFRecordDateFormat]];
}

+ (instancetype)initWithModelObject:(FFDataDelivery *)modelObject
{
    id object = [[super alloc] init];
    
    if (object)
    {
        [object loadDataFromModelObject:modelObject];
    }

    return object;
}

- (void)loadDataFromModelObject:(FFDataDelivery *)modelObject
{
    FFDataDelivery *delivery = modelObject;
    
    [self setRecordID:delivery.deliveryID];
    [self setDonationID:delivery.donationID];
    [self setDonee:delivery.donee];
    [self setRecoveryOrg:delivery.recoveryOrg];
}

@end
