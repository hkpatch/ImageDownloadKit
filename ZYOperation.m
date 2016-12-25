//
//  ZYOperation.m
//  ZYImageDownloadManager
//
//  Created by LiQiu Yu on 16/3/4.
//  Copyright (c) 2016ๅนด QQ 1158589738. All rights reserved.
//

#import "ZYOperation.h"
#import "ZYImageManager.h"
#import "Base64.h"

@implementation ZYOperation

- (id)initWithURL:(NSURL *)url andImageView:(UIImageView *)imageView
{
    self = [super init];
    if (self) {
        _imageView = [imageView retain];
        _url = [url copy];
    }
    return self;
}

//当本类对象放入操作队列中时 会在分线程中执行
- (void)main
{
    NSData *imageData = [NSData dataWithContentsOfURL:_url];
    UIImage *image = [UIImage imageWithData:imageData];
    if (image) {
        //回到主线程刷新UI  设置图片
        [self performSelectorOnMainThread:@selector(reloadUI:) withObject:image waitUntilDone:NO];
        
        //内存 先将url转化为base64string 然后作为key
        NSString *key = [_url.absoluteString base64EncodedString];
        [[[ZYImageManager shareImageManager] imageCaches] setObject:image forKey:key];
        
        //本地
        [imageData writeToFile:[[ZYImageManager shareImageManager] getFilePath:key] atomically:YES];
    }
}

- (void)reloadUI:(UIImage *)image
{
    _imageView.image = image;
}

@end







