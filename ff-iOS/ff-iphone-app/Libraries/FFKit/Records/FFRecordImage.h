//
//  FFRecordImage.h
//  FFiPhoneApp
//
//  Created by lee on 7/24/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FFRecordObject.h"

@class FFDataImage;

@interface FFRecordImage : FFRecordObject

+ (void)loadDataToModelObject:(FFDataImage *)modelObject fromJSONObject:(NSDictionary *)jsonObject;

@end
