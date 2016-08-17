//
//  YRViewController.m
//  DragDemo
//
//  Created by YANGRui on 14-5-27.
//  Copyright (c) 2014年 YANGReal. All rights reserved.
//

#import "YRViewController.h"
#import "UIDragButton.h"

#define kSudokuLenght                  ([[UIScreen mainScreen] bounds].size.width/3)

@interface YRViewController ()<UIDragButtonDelegate>
@property (strong , nonatomic) NSMutableArray *itemArray;
@end

@implementation YRViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.itemArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self doBtn];
}

- (void)doBtn {
    [self.itemArray removeAllObjects];
    
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:UIButton.class]) {
            [view removeFromSuperview];
        }
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"复位" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(30, 30, 50, 60);
    btn.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(doBtn) forControlEvents:UIControlEventTouchUpInside];
    
    for (NSInteger i = 0;i<9;i++)
    {
        UIDragButton *btn = [[UIDragButton alloc] initWithFrame:CGRectMake((i%3)*kSudokuLenght, (i/3)*kSudokuLenght + 100, kSudokuLenght, kSudokuLenght) sudokuBtnType:i%2];
        btn.delegate = self;
        [self.view addSubview:btn];
        [self.itemArray addObject:btn];
        btn.itemsArray = self.itemArray;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

@end
