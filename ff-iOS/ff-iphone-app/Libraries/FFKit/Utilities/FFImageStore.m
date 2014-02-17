//
//  FFImageStore.m
//  FFiPhoneApp
//
//  Created by lee on 7/28/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "FFImageStore.h"
#import <Foundation/NSCache.h>

@implementation FFImageStore
{
    NSCache *imageCache;
}

+ (instancetype)sharedStore
{
    static FFImageStore *sharedStore;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] init];
    });
    
    return sharedStore;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        // You can specify any additonal
        // initialization steps here.
        
        imageCache = [NSCache new];
    }

    return self;
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
    [imageCache setObject:image forKey:key];
}

- (UIImage *)imageForKey:(NSString *)key
{
    return [imageCache objectForKey:key];
}

- (void)removeImageForKey:(NSString *)key
{
    [imageCache removeObjectForKey:key];
}

@end
