//
//  WQImageDisplayView.h
//  WQImageDisplayView
//
//  Created by 魏琦 on 16/8/16.
//  Copyright © 2016年 com.drcacom.com. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  @author vicky 2016-08-18 10:45
 *
 *  @param index 点击图片的下标
 */
typedef void (^tapBannerAction)(NSInteger index);

@interface WQImageDisplayView : UIView
/**
 *  @author vicky 2016-08-18 10:45
 *
 *  @param imagesArray 设置图片数据源数组
 */
- (void)setImagesArray:(NSArray*)imagesArray;
/**
 *  @author vicky 2016-08-18 10:45
 *  点击图片的block
 */
@property(copy,nonatomic)tapBannerAction bannerAction;
/**
 *  @author vicky 2016-08-18 10:45
 *  初始化轮播图组件
 *
 *  @param frame    轮播图组件的frame
 *  @param duration 每一张图片切换的时长
 *
 *  @return 轮播图组件实例
 */
- (instancetype)initWithFrame:(CGRect)frame duration:(CGFloat)duration;
/**
 *  @author vicky 2016-08-18 10:45
 *  初始化轮播图组件
 *
 *  @param frame    轮播图组件的frame
 *  @param duration 每一张图片切换的时长
 *  @param currentPagePageControlTintColor  当前pagecontrol的颜色
 *  @param pageControlTintColor pagecontrol的颜色
 *
 *
 *  @return 轮播图组件实例
 */
- (instancetype)initWithFrame:(CGRect)frame duration:(CGFloat)duration currentPagePageControlTintColor:(UIColor*)currentPagePageControlTintColor pageControlTintColor:(UIColor*)pageControlTintColor;


@end
