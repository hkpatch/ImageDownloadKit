//
//  UIImageView+AsyncDownload.h
//  ZYImageDownloadManager
//
//  Created by LiQiu Yu on 16/3/4.
//  Copyright (c) 2016年 QQ 1158589738. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (AsyncDownload)

- (void)setImageWithURL:(NSURL *)url;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

@end
