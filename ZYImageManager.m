//
//  ZYImageManager.m
//  ZYImageDownloadManager
//
//  Created by LiQiu Yu on 16/3/4.
//  Copyright (c) 2016ๅนด QQ 1158589738. All rights reserved.
//

#import "ZYImageManager.h"
#import "ZYOperation.h"
#import "Base64.h"

/*
 1、声明静态实例 并初始化值为nil
 2、声明静态方法 方法中判断如果实例为nil就创建
 */

//栈、堆、全局变量区（静态区）、方法区、常量区
static ZYImageManager *singletonInstance = nil;

@implementation ZYImageManager

+ (ZYImageManager *)shareImageManager
{
    @synchronized(self){
        if (singletonInstance == nil) {
            singletonInstance = [[super allocWithZone:NULL] init];
        }
    }
    return singletonInstance;
}

//重写初始化方法 初始化一些需要初始化的东西
- (id)init
{
    self = [super init];
    if (self) {
        //添加内存警告的监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memoryWarnning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 3;
        _imageCaches = [[NSMutableDictionary alloc] init];
    }
    return self;
}

//收到内存警告执行的方法
- (void)memoryWarnning
{
    //清除内存中的东西
    [_imageCaches removeAllObjects];
}

- (void)dealloc
{
    //移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    [_imageCaches release];
    [_queue cancelAllOperations];
    [_queue release];
    [super dealloc];
}

//分配内存
//因为alloc会调用此方法 所以应重写防止其再创建对象
+ (id)allocWithZone:(struct _NSZone *)zone
{
    return singletonInstance;
}

//copy时会调用此方法
+ (id)copyWithZone:(struct _NSZone *)zone
{
    return singletonInstance;
}

//重写一下跟引用计数有关的东西 推荐
- (id)retain
{
    return self;
}

//重写release以及autorelease
- (oneway void)release
{

}

- (id)autorelease
{
    return self;
}

//返回1可以 如下亦可
- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

#pragma mark - 图片下载
- (void)downloadImageWithURL:(NSURL *)url forImageView:(UIImageView *)imageView
{
    if (!url) {
        return;
    }
    //如果不是第一次
    
    //内存中找
    NSString *key = [url.absoluteString base64EncodedString];
    UIImage *memoryImage = [_imageCaches objectForKey:key];
    if (memoryImage) {
        imageView.image = memoryImage;
        return;
    }
    
    //本地找
    NSData *imageData = [NSData dataWithContentsOfFile:[self getFilePath:key]];
    UIImage *localImage = [UIImage imageWithData:imageData];
    
    //如果本地有
    if (localImage)
    {
        //将图片放入字典 即内存
        [[[ZYImageManager shareImageManager] imageCaches] setObject:localImage forKey:key];
        imageView.image = localImage;
        return;
    }
    
    
    NSLog(@"%@", [self getFileDirectoryPath]);
    
    //第一进来开启下载
    //自定义operation内部处理任务
    //将url和imageView传给operation
    ZYOperation *operation = [[ZYOperation alloc] initWithURL:url andImageView:imageView];
    [_queue addOperation:operation];
    [operation release];
}


//获取完整文件路径
- (NSString *)getFilePath:(NSString *)fileName
{
    return [[self getFileDirectoryPath] stringByAppendingPathComponent:fileName];
}

//获取存放图片的文件夹路径
- (NSString *)getFileDirectoryPath
{
    NSString *documntPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *fileDirectoryPath = [documntPath stringByAppendingPathComponent:@"imageCaches"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileDirectoryPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:fileDirectoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return fileDirectoryPath;
}

@end


















