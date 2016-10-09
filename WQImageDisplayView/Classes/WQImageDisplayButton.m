//
//  WQImageDisplayButton.m
//  WQImageDisplayView
//
//  Created by 魏琦 on 16/8/16.
//  Copyright © 2016年 com.drcacom.com. All rights reserved.
//

#import "WQImageDisplayButton.h"
@interface WQImageDisplayButton ()
@property (nullable, strong, nonatomic) UIImageView* imageDisplayView;


@end

@implementation WQImageDisplayButton
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addButtonImageView];
        [self configuButton];
        
    }
    return self;
}

- (void)configuButton{
    [self addTarget:self action:@selector(hadleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.clipsToBounds = YES;
}

- (void)hadleButtonAction:(UIButton*)sender {
    if (self.buttonActionBlock) {
        self.buttonActionBlock(sender);
    }
}

-  (void)addButtonImage:(id)image {
    if ([image isKindOfClass:[UIImage class]]) {
        self.imageDisplayView.image = image;
        return;
        
    }
    NSString *imageNameString = @"";
    if ([image isKindOfClass:[NSString class]]) {
        imageNameString = image;
    }
    if ([self isURLString:image]) {
        imageNameString = @"place_image";
        
    }
    self.imageDisplayView.image = [UIImage imageNamed:imageNameString];
    
    
    
}

- (void)addButtonImageView {
    _imageDisplayView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imageDisplayView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_imageDisplayView];
}

- (BOOL)isURLString:(NSString*)string {
    NSString* url = @"((http|ftp|https)://)(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-]*)?";
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",url];
    return [predicate evaluateWithObject:string];
}
@end
