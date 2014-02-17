//
//  FFStoreImage.h
//  FFiPhoneApp
//
//  Created by lee on 7/28/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFStoreImage : NSObject

+ (instancetype)sharedClient;
- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;
- (void)removeImageForKey:(NSString *)key;

@end
