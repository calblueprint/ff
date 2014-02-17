//
//  FFDataImage.h
//  FFiPhoneApp
//
//  Created by lee on 7/22/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FFDataObject.h"

@interface FFDataImage : FFDataObject

@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSString *thumbnailURL;

@end
