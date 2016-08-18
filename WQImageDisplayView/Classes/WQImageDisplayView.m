//
//  WQImageDisplayView.m
//  WQImageDisplayView
//
//  Created by 魏琦 on 16/8/16.
//  Copyright © 2016年 com.drcacom.com. All rights reserved.
//

#import "WQImageDisplayView.h"
#import "WQImageDisplayButton.h"
#define WQRGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
static CGFloat pageControlHeight = 50;
@interface WQImageDisplayView ()<UIScrollViewDelegate>
@property (nullable, strong, nonatomic) UIScrollView * scrollView;
@property (assign,nonatomic) NSInteger currentPage;//当前页
@property (nullable, strong, nonatomic) UIPageControl * pageControl;
@property (nullable, strong, nonatomic) NSMutableArray * imageArray;//图片数组
@property (nullable, strong, nonatomic) dispatch_queue_t queue;//下载图片的并发队列
@property (nullable, strong, nonatomic) NSMutableArray<WQImageDisplayButton*> * buttonArray;//保存三个按钮的数组
@property (assign, nonatomic) CGFloat direction;//方向
@property (assign, nonatomic) CGFloat width;//宽度
@property (assign, nonatomic) CGFloat height;//高度
@property (assign, nonatomic) BOOL isSourceActive;//定时器是否起作用
@property (assign, nonatomic) CGFloat duration;//运动时间间隔
@property (nullable, strong, nonatomic) NSTimer * scrollTimer;//定时器
@end
@implementation WQImageDisplayView
#pragma -mark self.width self.height
- (CGFloat)width {
    return self.bounds.size.width;
}

- (CGFloat)height {
    return self.bounds.size.height;
}
#pragma -mark initialize
- (instancetype)initWithFrame:(CGRect)frame duration:(CGFloat)duration {
    if (self = [super initWithFrame:frame]) {
        /**
         *  初始化scrollview和基础数据
         */
        _direction = 1;
        _currentPage = 0;
        _isSourceActive = NO;
        _duration = duration;
        [self addSubview:self.scrollView];
        [self addImageButton];
        [self addSubview:self.pageControl];
        
        [self addDispatchSourceTimer];
    }
    return self;
}
/**
 *  @author vicky 2016-08-18 10:45
 *  设置图片数组
 *
 *  @param imagesArray 图片数组的数据源
 */
- (void)setImagesArray:(NSArray *)imagesArray {
    _imageArray = imagesArray.mutableCopy;
    [self requestImageArray:_imageArray];
    [self addimagesButton:_imageArray];
}
/**
 *  @author vicky 2016-08-18 10:45
 *  设置三个button的图片(分别是前一页,当前页,下一页)
 *
 *  @param imagesNameArray 图片数组
 */
- (void)addimagesButton:(NSMutableArray*)imagesNameArray {
    if (imagesNameArray.count > 0) {
        [self setButtonImage:((int)self.currentPage)];
        self.pageControl.numberOfPages = imagesNameArray.count;
        self.currentPage = 0;
        
    }
}

/**
 *  @author vicky 2016-08-18 10:45
 *  判断图片数组的资源类型,如果为网络类型就去下载.
 *
 *  @param imagesArray 图片数组
 */
- (void)requestImageArray:(NSMutableArray*)imagesArray {
    for (int i = 0 ; i < imagesArray.count ; i ++) {
        id image = imagesArray[i];
        if ([image isKindOfClass:[NSString class]]) {
            if ([self isURLString:image]) {
                dispatch_async(self.queue, ^{
                    [self requeImageWithUrl:image index:i];
                });
            }
            continue;
        }
        
    }
    
}
/**
 *  @author vicky 2016-08-18 10:45
 *  添加自动轮播的定时器
 */
- (void)addDispatchSourceTimer {
    _scrollTimer = [NSTimer timerWithTimeInterval:_duration target:self selector:@selector(anmationScroll:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_scrollTimer forMode:NSRunLoopCommonModes];
    self.isSourceActive = YES;
}

-(void)anmationScroll:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.contentOffset = CGPointMake((self.scrollView.contentOffset.x + (self.width * self.direction)-1), 0);
    }completion:^(BOOL finished) {
        if (finished) {
            self.scrollView.contentOffset = CGPointMake((self.scrollView.contentOffset.x +1), 0);
        }
    }];
}

/**
 *  @author vicky 2016-08-18 10:45
 *  添加用来复用轮播的button
 */
- (void)addImageButton {
    for (int i = 0; i < 3; i++) {
        WQImageDisplayButton* button = [[WQImageDisplayButton alloc] initWithFrame:[self getButtonFrameWithIndex:i]];
        button.tag = i;
        [self.scrollView addSubview:button];
        [self.buttonArray addObject:button];
        button.buttonActionBlock = ^ (UIButton*sender){
            if (self.bannerAction) {
                self.bannerAction(self.currentPage);
            }
        };
    }
}
/**
 *  @author vicky 2016-08-18 10:45
 *  下载图片
 *
 *  @param url   图片链接
 *  @param index 在图片数组中的下标
 */
- (void)requeImageWithUrl:(NSString*)url index:(int)index {
    if (!url)return;
    NSURL* imageUrl = [[NSURL alloc] initWithString:url];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:imageUrl];
    request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    NSURLSession* session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask* task = [session dataTaskWithURL:imageUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        UIImage* image;
        if (data) {
            image = [UIImage imageWithData:data];
        }
        else {
            NSLog(@"please write correct image url");
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (image == nil) {
                return ;
                
            }
            self.imageArray[index]= image;
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, 0)];
            
        });
    }];
    [task resume];
}
/**
 *  @author vicky 2016-08-18 10:45
 *  移动button的位置至显示区域
 *
 *  @param offsetX 偏移量
 */
- (void)moveImageViewWithOffsetX:(CGFloat)offsetX {
    CGFloat index = offsetX / self.width;
    if (index ==0 || index == 1 ||index ==2) {
        int position = ((int)(index))-1;
        self.currentPage = [self getCurrtnImageIndex:((int)self.currentPage + position)];
        self.scrollView.contentOffset = CGPointMake(self.width, 0);
        [self setButtonImage:(int)self.currentPage];
        self.pageControl.currentPage = self.currentPage;
        
    }
}
/**
 *  @author vicky 2016-08-18 10:45
 *  设置button的图片
 *
 *  @param currentPage 当前页
 */
- (void)setButtonImage:(int)currentPage {
    NSArray* imageIndexArray = @[@([self getBeforeImageIndex:currentPage]),@([self getCurrtnImageIndex:currentPage]),@([self getLastNumberImageIndex:currentPage])];
    for (int i = 0 ; i < self.buttonArray.count; i ++) {
        WQImageDisplayButton* button = self.buttonArray[i];
        NSNumber* number = imageIndexArray[i];
        int index = number.intValue;
        id imageName = self.imageArray[index];
        [button addButtonImage:imageName];
    }
}
/**
 *  @author vicky 2016-08-18 10:45
 *  获取当前显示图片button索引
 *
 *  @param currentPage 当前页数
 *
 *  @return 索引index(下标)
 */
- (int)getCurrtnImageIndex:(int)currentPage{
    if (self.imageArray.count > 0) {
        int tempCurrentImage = currentPage % (int)self.imageArray.count;
        return tempCurrentImage < 0 ? (int)self.imageArray.count-1:tempCurrentImage;
    }
    return 0;
}
/**
 *  @author vicky 2016-08-18 10:45
 *  获取下一页的图片索引
 *
 *  @param currentPage 当前页
 *
 *  @return 下一页的索引(下标)
 */
- (int)getLastNumberImageIndex:(int)currentPage {
    int lastNumber = ((int)[self getCurrtnImageIndex:(currentPage)]) +1;
    return lastNumber >= self.imageArray.count ? 0 : lastNumber;
    
}
/**
 *  @author vicky 2016-08-18 10:45
 *  获取上一页的图片
 *
 *  @param currentPage 当前页
 *
 *  @return 上一页的索引(下标)
 */
- (int)getBeforeImageIndex:(int)currentPage {
    int beforeNum = ((int)[self getCurrtnImageIndex:(currentPage)])-1;
    return beforeNum < 0 ? (int)self.imageArray.count -1 :beforeNum;
}
/**
 *  @author vicky 2016-08-18 10:45
 *  button的frame
 *
 *  @param index 第几个
 *
 *  @return 返回三个不同button的frame
 */
- (CGRect)getButtonFrameWithIndex:(int)index {
    return CGRectMake(index*self.width, 0,self.width, self.height);
}

#pragma -mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self moveImageViewWithOffsetX:scrollView.contentOffset.x];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.x - self.width > 0) {
        self.direction = 1;
    }
    else {
        self.direction = 1;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.isSourceActive && scrollView.tracking) {
        [self.scrollTimer invalidate];
        self.isSourceActive = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self addDispatchSourceTimer];
}

#pragma -mark lazyloading subView or source and queue
- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.height-pageControlHeight,self.width,pageControlHeight)];
        _pageControl.enabled = NO;
        _pageControl.currentPageIndicatorTintColor = WQRGBColor(33, 192, 174);
        _pageControl.pageIndicatorTintColor = [UIColor groupTableViewBackgroundColor];
    }
    return _pageControl;
}

- (dispatch_queue_t)queue {
    if (!_queue) {
        _queue = dispatch_queue_create("concurrentQururDownLoad.com", DISPATCH_QUEUE_CONCURRENT);
    }
    return _queue;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,self.width, self.height)];
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor grayColor];
        _scrollView.contentSize = CGSizeMake(3 * self.width, self.height);
        _scrollView.pagingEnabled = YES;
        _scrollView.delaysContentTouches = YES;
        _scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        _scrollView.contentOffset = CGPointMake(self.width, 0);
    }
    return _scrollView;
}

- (BOOL)isURLString:(NSString*)string {
    NSString* url = @"((http|ftp|https)://)(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-]*)?";
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",url];
    return [predicate evaluateWithObject:string];
}

- (NSMutableArray<WQImageDisplayButton *> *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
        
    }
    return _buttonArray;
}

@end
