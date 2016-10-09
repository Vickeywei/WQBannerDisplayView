//
//  ViewController.m
//  WQImageDisplayView
//
//  Created by 魏琦 on 16/8/16.
//  Copyright © 2016年 com.drcacom.com. All rights reserved.
//

#import "ViewController.h"
#import "WQImageDisplayView.h"
@interface ViewController ()
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@end

@implementation ViewController

- (CGFloat)width {
    return self.view.bounds.size.width;
}

- (CGFloat)height {
    return self.view.bounds.size.height;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    WQImageDisplayView* displayView = [[WQImageDisplayView alloc] initWithFrame:CGRectMake(0, 80, self.width, 260)duration:6];
    [self.view addSubview:displayView];
    [displayView setImagesArray:[self addImageArray]];
    displayView.bannerAction = ^ (NSInteger index) {
        NSLog(@"%zd",index);
        
    };
    
    // Do any additional setup after loading the view, typically from a nib.
}
-(NSArray*)addImageArray {
    NSMutableArray* array = [NSMutableArray array];
    for (int i = 0 ; i < 9; i ++) {
        NSString* str = [NSString stringWithFormat:@"00%d",i];
        [array addObject:str];
    }
    [array addObject:@"http://pic72.nipic.com/file/20150716/21422793_144600530000_2.jpg"];
    [array addObject:@"http://img2.3lian.com/img2007/4/22/303952037bk.jpg"];
    [array addObject:@"http://img.61gequ.com/allimg/2011-4/201142614314278502.jpg"];
    [array addObject:@"http://img15.3lian.com/2015/f1/5/d/108.jpg"];
    [array addObject:@"http://pic1.nipic.com/2008-12-25/2008122510134038_2.jpg"];
    [array addObject:@"http://img3.3lian.com/2013/v10/79/d/86.jpg"];
    
    return array.copy;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
