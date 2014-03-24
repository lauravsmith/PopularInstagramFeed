//
//  InstagramPhoto.h
//  InstagramFeed
//
//  Created by Laura Smith on 2013-09-27.
//  Copyright (c) 2013 Laura Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstagramPhoto : NSObject
@property (nonatomic, strong) NSURL *image;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSDate *timeStamp;
@end
