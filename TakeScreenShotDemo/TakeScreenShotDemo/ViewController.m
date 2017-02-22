//
//  ViewController.m
//  TakeScreenShotDemo
//
//  Created by 沈龙 on 2017/2/20.
//  Copyright © 2017年 graystone-labs. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleUserDidTakeScreenshot:)
                                                 name:UIApplicationUserDidTakeScreenshotNotification
                                               object:nil];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭"
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(onCloseFromModal:)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 

- (void)onCloseFromModal:(UIBarButtonItem *)barBtnItem {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -

- (void)handleUserDidTakeScreenshot:(NSNotification *)notif {
    NSLog(@"检测到截屏");
    
    UIView *v = [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:NO];
    v.frame = CGRectMake(0, 0, self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.5);
    v.layer.borderColor = [UIColor blackColor].CGColor;
    v.layer.borderWidth = 2.0;
    v.layer.cornerRadius = 5.0;
    v.layer.masksToBounds =  YES;
    [self.view addSubview:v];
    
    [self.view snapshotViewAfterScreenUpdates:NO];
    
    
    //人为截屏,   模拟用户截屏行为, 获取所截图片
    
    UIImage   *image_  =  [self  imageWithScreenshot];
    
    
    
    //添加显示
    
    UIImageView   *imgvPhoto  =  [[UIImageView  alloc]initWithImage:image_];
    
    imgvPhoto.frame  =  CGRectMake(self.view.frame.size.width/2,  self.view.frame.size.height/2,  self.view.frame.size.width/2,  self.view.frame.size.height/2);
    
    
    
    //添加边框
    
    CALayer   *  layer  =  [imgvPhoto  layer];
    
    layer.borderColor  =  [
                           
                           [UIColor  whiteColor]  CGColor];
    
    layer.borderWidth  =  5.0f;
    
    //添加四个边阴影
    
    imgvPhoto.layer.shadowColor  =  [UIColor  blackColor].CGColor;
    
    imgvPhoto.layer.shadowOffset  =  CGSizeMake(0,  0);
    
    imgvPhoto.layer.shadowOpacity  =  0.5;
    
    imgvPhoto.layer.shadowRadius  =  10.0;
    
    //添加两个边阴影
    
    imgvPhoto.layer.shadowColor  =  [UIColor  blackColor].CGColor;
    
    imgvPhoto.layer.shadowOffset  =  CGSizeMake(4,  4);
    
    imgvPhoto.layer.shadowOpacity  =  0.5;
    
    imgvPhoto.layer.shadowRadius  =  2.0;
    
    
    
    [self.view  addSubview:imgvPhoto];
}

#pragma mark -

/**
 
 *  截取当前屏幕
 
 *
 
 *  @return NSData *
 
 */

-  (NSData   *)dataWithScreenshotInPNGFormat

{
    
    CGSize  imageSize  =  CGSizeZero;
    
    UIInterfaceOrientation  orientation  =  [UIApplication  sharedApplication].statusBarOrientation;
    
    if  (UIInterfaceOrientationIsPortrait(orientation))
        
        imageSize  =  [UIScreen  mainScreen].bounds.size;
    
    else
        
        imageSize  =  CGSizeMake([UIScreen  mainScreen].bounds.size.height,  [UIScreen  mainScreen].bounds.size.width);
    
    
    
    UIGraphicsBeginImageContextWithOptions(imageSize,  NO,  0);
    
    CGContextRef  context  =  UIGraphicsGetCurrentContext();
    
    for  (UIWindow   *window  in  [[UIApplication  sharedApplication]  windows])
        
    {
        
        CGContextSaveGState(context);
        
        CGContextTranslateCTM(context,  window.center.x,  window.center.y);
        
        CGContextConcatCTM(context,  window.transform);
        
        CGContextTranslateCTM(context,  -window.bounds.size.width   *  window.layer.anchorPoint.x,  -window.bounds.size.height   *  window.layer.anchorPoint.y);
        
        if  (orientation  ==  UIInterfaceOrientationLandscapeLeft)
            
        {
            
            CGContextRotateCTM(context,  M_PI_2);
            
            CGContextTranslateCTM(context,  0,  -imageSize.width);
            
        }
        
        else  if  (orientation  ==  UIInterfaceOrientationLandscapeRight)
            
        {
            
            CGContextRotateCTM(context,  -M_PI_2);
            
            CGContextTranslateCTM(context,  -imageSize.height,  0);
            
        }  else  if  (orientation  ==  UIInterfaceOrientationPortraitUpsideDown)  {
            
            CGContextRotateCTM(context,  M_PI);
            
            CGContextTranslateCTM(context,  -imageSize.width,  -imageSize.height);
            
        }
        
        if  ([window  respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
            
        {
            
            [window  drawViewHierarchyInRect:window.bounds  afterScreenUpdates:YES];
            
        }
        
        else
            
        {
            
            [window.layer  renderInContext:context];
            
        }
        
        CGContextRestoreGState(context);
        
    }
    
    
    
    UIImage   *image  =  UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    
    return  UIImagePNGRepresentation(image);
    
}



/**
 
 *  返回截取到的图片
 
 *
 
 *  @return UIImage *
 
 */

-  (UIImage   *)imageWithScreenshot

{
    
    NSData   *imageData  =  [self  dataWithScreenshotInPNGFormat];
    
    return  [UIImage  imageWithData:imageData];
    
}

@end
