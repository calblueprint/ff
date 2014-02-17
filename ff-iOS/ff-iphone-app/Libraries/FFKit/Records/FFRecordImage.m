//
//  FFRecordImage.m
//  FFiPhoneApp
//
//  Created by lee on 7/24/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "FFRecordImage.h"

#import "FFDataImage.h"

#import "NSDictionary+FFNull.h"

@implementation FFRecordImage

+ (void)loadDataToModelObject:(FFDataImage *)modelObject fromJSONObject:(NSDictionary *)jsonObject;
{
    FFDataImage *model = modelObject;
    NSDictionary *json = jsonObject;

    [model setImageURL:[[json ff_objectForKey:@"large"] ff_objectForKey:@"url"]];
    [model setThumbnailURL:[[json ff_objectForKey:@"thumb"] ff_objectForKey:@"url"]];
}

@end
