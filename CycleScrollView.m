//
//  CycleScrollView.m
//  ScrollDemo
//
//  Created by keyzhang on 15/9/8.
//  Copyright (c) 2015年 keyzhang. All rights reserved.
//

#import "CycleScrollView.h"
#import "NSTimer+Addition.h"

@interface CycleScrollView ()
{
    UIImageView *leftImgView;
    UIImageView *centerImgView;
    UIImageView *rightImgView;
    UILabel *leftlabel;
    UILabel *centerlabel;
    UILabel *rightlabel;
    
}

@property (nonatomic , strong) NSTimer *animationTimer;
@property (nonatomic , assign) NSTimeInterval animationDuration;


@end

@implementation CycleScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _costomInit];

    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self _costomInit];
}

- (void)_costomInit
{
    
    self.delegate = self;
    
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.bounces = NO;

    self.contentSize = CGSizeMake(self.frame.size.width * 3, self.frame.size.height);
    
    self.pagingEnabled = YES;
    
    //控制视图
    leftImgView = [[UIImageView alloc] initWithFrame:self.bounds];
    //第六个，UILabel
    leftlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 170, kScreenWidth, 30)];
    leftlabel.textColor = [UIColor whiteColor];
    leftlabel.backgroundColor = [UIColor blackColor];
    leftlabel.alpha = 0.7;
    leftlabel.textAlignment = NSTextAlignmentCenter;
    leftlabel.font = [UIFont boldSystemFontOfSize:14];
    [leftImgView addSubview:leftlabel];
    
    [self addSubview:leftImgView];
    centerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
    //第六个，UILabel
    centerlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 170, kScreenWidth, 30)];
    centerlabel.textColor = [UIColor whiteColor];
    centerlabel.backgroundColor = [UIColor blackColor];
    centerlabel.alpha = 0.7;
    centerlabel.textAlignment = NSTextAlignmentCenter;
    centerlabel.font = [UIFont boldSystemFontOfSize:14];
    [centerImgView addSubview:centerlabel];

    [self addSubview:centerImgView];
    rightImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width * 2, 0, self.frame.size.width, self.frame.size.height)];
    //第六个，UILabel
    rightlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 170, kScreenWidth, 30)];
    rightlabel.textColor = [UIColor whiteColor];
    rightlabel.textAlignment = NSTextAlignmentCenter;
    rightlabel.backgroundColor = [UIColor blackColor];
    rightlabel.alpha = 0.7;
    rightlabel.font = [UIFont boldSystemFontOfSize:14];
    [rightImgView addSubview:rightlabel];

    [self addSubview:rightImgView];
    
    
    
    //初始化位置
    _selectedIndex = 1;
    self.contentOffset = CGPointMake(self.frame.size.width, 0);
    
//    NSLog(@"%ld", _selectedIndex);
    
    

}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat xOff = scrollView.contentOffset.x;
    
    //调用下面封装好的方法
    [self contentOffSet:xOff];
    
}

- (void)setImgs:(NSArray *)imgs
{
    NSMutableArray *selfImgs = [NSMutableArray arrayWithArray:imgs];
    
    if (imgs.count < 3) {
        [selfImgs addObjectsFromArray:imgs];
        [selfImgs addObjectsFromArray:imgs];
    }
    
    _imgs = selfImgs;
    
    [leftImgView sd_setImageWithURL:_imgs[0]];
    
    [centerImgView sd_setImageWithURL:_imgs[1]];
    [rightImgView sd_setImageWithURL:_imgs[2]];
    
    //添加定时器
    [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];

}

- (void)setTitles:(NSArray *)titles
{
    NSMutableArray *selftitles = [NSMutableArray arrayWithArray:titles];
    
    if (titles.count < 3) {
        [selftitles addObjectsFromArray:titles];
        [selftitles addObjectsFromArray:titles];
    }
    
    _titles = selftitles;
    
    leftlabel.text = _titles[0];
    centerlabel.text = _titles[1];
    rightlabel.text = _titles[2];
    

}
- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration
{
    self = [self initWithFrame:frame];
    if (animationDuration > 0.0) {
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:(self.animationDuration = animationDuration)
                                                               target:self
                                                             selector:@selector(animationTimerDidFired:)
                                                             userInfo:nil
                                                              repeats:YES];
        [self.animationTimer pauseTimer];
    }
    return self;
}
- (void)animationTimerDidFired:(NSTimer *)timer
{
    CGFloat xOff = self.contentOffset.x + kScreenWidth;
    
    [self contentOffSet:xOff];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.animationTimer pauseTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
}

//封装滑动时设置的偏移量
- (void)contentOffSet:(CGFloat)xOff
{
    if (xOff == 0) {    //向右滑动
        if (_selectedIndex == 0) {
            _selectedIndex = self.imgs.count - 1;
        }else {
            _selectedIndex = _selectedIndex - 1;
        }
    } else if (xOff == self.frame.size.width * 2) {   //向左滑动
        if (_selectedIndex == self.imgs.count -1) {
            _selectedIndex = 0;
        }else {
            _selectedIndex = _selectedIndex + 1;
        }
    }
    
    //    NSLog(@"%ld", _selectedIndex);
    
    //设置左边图片
    if (_selectedIndex == 0) {
        [leftImgView sd_setImageWithURL:self.imgs.lastObject];
        leftlabel.text = self.titles.lastObject;
    }else {
        [leftImgView sd_setImageWithURL:self.imgs[_selectedIndex - 1]];
        leftlabel.text = self.titles[_selectedIndex - 1];
    }
    
    //设置中间图片
    [centerImgView sd_setImageWithURL:self.imgs[_selectedIndex]];
    centerlabel.text = self.titles[_selectedIndex];
    
    //设置右边图片
    if (_selectedIndex == self.imgs.count - 1) {
        
        [rightImgView sd_setImageWithURL:self.imgs[0]];
        rightlabel.text = self.titles[0];
    }else {
        [rightImgView sd_setImageWithURL:self.imgs[_selectedIndex + 1]];
        rightlabel.text = self.titles[_selectedIndex + 1];
    }
    
    //每次都显示中间的视图
    self.contentOffset = CGPointMake(self.frame.size.width, 0);

}


@end
