//
//  WQImageDisplayButton.h
//  WQImageDisplayView
//
//  Created by 魏琦 on 16/8/16.
//  Copyright © 2016年 com.drcacom.com. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  void(^handleButtonBlock)(UIButton* sender);
@interface WQImageDisplayButton : UIButton
@property (copy,nonatomic)handleButtonBlock buttonActionBlock;
-(void)addButtonImage:(id)image;
@end
