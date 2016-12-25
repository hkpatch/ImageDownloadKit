//
//  ZYOperation.h
//  ZYImageDownloadManager
//
//  Created by LiQiu Yu on 16/3/4.
//  Copyright (c) 2016ๅนด QQ 1158589738. All rights reserved.
//

#import <Foundation/Foundation.h>

///专门用来操作下载图片的类
@interface ZYOperation : NSOperation

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, copy) NSURL *url;

- (id)initWithURL:(NSURL *)url andImageView:(UIImageView *)imageView;

@end






