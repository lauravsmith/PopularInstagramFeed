//
//  InstagramPhotoCell.m
//  InstagramFeed
//
//  Created by Laura Smith on 2013-09-27.
//  Copyright (c) 2013 Laura Smith. All rights reserved.
//

#import "InstagramPhotoCell.h"
#import "InstagramPhoto.h"

#import <UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>

@interface InstagramPhotoCellContentView : UIView
@property (nonatomic, strong) InstagramPhoto *photo;
@property (nonatomic, strong) UIImageView *imageView;
- (void)prepareForReuse;
@end

@implementation InstagramPhotoCellContentView


- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.imageView];
        self.layer.delegate = self;
    }
    return self;
}

- (void)prepareForReuse {
    [self.imageView cancelCurrentImageLoad];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(10.0, 15.0, 300.0, 300.0);
}

- (void)setPhoto:(InstagramPhoto *)photo {
    _photo = photo;
    [self.imageView setImageWithURL:self.photo.image];
    
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    NSLog(@"Hello");
    [self.photo.userName drawAtPoint:CGPointMake(0, 0) withFont:[UIFont systemFontOfSize:12.0]];
    NSString *timeStamp = [self.photo.timeStamp description];
    [timeStamp drawAtPoint:CGPointMake(150, 0) withFont:[UIFont systemFontOfSize:12.0]];
    [self.photo.caption drawAtPoint:CGPointMake(0, self.imageView.bounds.size.height + 15.0) forWidth:self.bounds.size.width withFont:[UIFont systemFontOfSize:12.0]  lineBreakMode:NSLineBreakByWordWrapping];
}

@end

@interface InstagramPhotoCell()
@property (nonatomic, strong) InstagramPhotoCellContentView *cellContentView;
@end

@implementation InstagramPhotoCell

- (void)prepareForReuse {
    [_cellContentView prepareForReuse];
}

- (InstagramPhotoCellContentView *)cellContentView {
    if (!_cellContentView) {
        _cellContentView = [[InstagramPhotoCellContentView alloc] initWithFrame:self.contentView.bounds];
        _cellContentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_cellContentView];
        //        [self.layer setDelegate:self];
    }
    return _cellContentView;
}

- (void)setPhoto:(InstagramPhoto *)photo {
    _photo = photo;
    self.cellContentView.photo = self.photo;
}


@end