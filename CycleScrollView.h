//
//  CycleScrollView.h
//  ScrollDemo
//
//  Created by keyzhang on 15/9/8.
//  Copyright (c) 2015年 keyzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CycleScrollView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *imgs;    //显示的图片数据

@property (nonatomic, assign, readonly) NSInteger selectedIndex;  //当前显示的图片下标

@property (nonatomic, strong) NSArray *titles;    //显示的文字数据

- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration;

@end
