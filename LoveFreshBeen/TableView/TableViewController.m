//
//  TableViewController.m
//  LoveFreshBeen
//
//  Created by LeeJay on 16/3/17.
//  Copyright © 2016年 以撒网. All rights reserved.
//

#import "HeaderView.h"
#import "LeftTableViewCell.h"
#import "RefreshHeader.h"
#import "RightTableViewCell.h"
#import "SupermarketModel.h"
#import "TableViewController.h"

@interface TableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *categoryData;
@property (nonatomic, strong) NSMutableArray *productData;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;

@end

@implementation TableViewController
{
    NSInteger _selectIndex;
    BOOL _isScrollDown;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.view.backgroundColor = [UIColor whiteColor];

    _selectIndex = 0;
    _isScrollDown = YES;

    NSString *path = [[NSBundle mainBundle] pathForResource:@"supermarket" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray *categories = dict[@"data"][@"categories"];
    NSDictionary *productDict = dict[@"data"][@"products"];
    
    for (NSDictionary *dict in categories)
    {
        CategoryModel *model = [CategoryModel objectWithDictionary:dict];
        [self.categoryData addObject:model];
        NSArray *products = productDict[model.categoryId];
        NSMutableArray *datas = [NSMutableArray array];
        for (NSDictionary *pro_dict in products)
        {
            [datas addObject:[SupermarketModel objectWithDictionary:pro_dict]];
        }
        [self.productData addObject:datas];
    }

    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightTableView];

    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];

    self.rightTableView.mj_header = [RefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.rightTableView.mj_header beginRefreshing];
}

- (void)loadNewData
{
    // 延迟两秒结束刷新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.rightTableView.mj_header endRefreshing];
    });
}

#pragma mark - FooterView

- (UIImageView *)loadFooterView
{
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 80, 70)];
    imageV.contentMode = UIViewContentModeCenter;
    imageV.image = [UIImage imageNamed:@"v2_common_footer"];
    return imageV;
}

#pragma mark - Getters

- (NSMutableArray *)categoryData
{
    if (!_categoryData)
    {
        _categoryData = [NSMutableArray array];
    }
    return _categoryData;
}

- (NSMutableArray *)productData
{
    if (!_productData)
    {
        _productData = [NSMutableArray array];
    }
    return _productData;
}

- (UITableView *)leftTableView
{
    if (!_leftTableView)
    {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 80, SCREEN_HEIGHT)];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.rowHeight = 45;
        _leftTableView.tableFooterView = [UIView new];
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.separatorColor = [UIColor clearColor];
        [_leftTableView registerClass:[LeftTableViewCell class] forCellReuseIdentifier:kCellIdentifier_Left];
    }
    return _leftTableView;
}

- (UITableView *)rightTableView
{
    if (!_rightTableView)
    {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(80, 64, SCREEN_WIDTH - 80, SCREEN_HEIGHT - 64)];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.rowHeight = 80;
        _rightTableView.tableFooterView = [self loadFooterView];
        _rightTableView.showsVerticalScrollIndicator = NO;
        [_rightTableView registerClass:[RightTableViewCell class] forCellReuseIdentifier:kCellIdentifier_Right];
    }
    return _rightTableView;
}

#pragma mark - TableView DataSource Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_leftTableView == tableView)
    {
        return 1;
    }
    else
    {
        return self.categoryData.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_leftTableView == tableView)
    {
        return self.categoryData.count;
    }
    else
    {
        return [self.productData[section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_leftTableView == tableView)
    {
        LeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Left forIndexPath:indexPath];
        CategoryModel *model = self.categoryData[indexPath.row];
        cell.name.text = model.name;
        return cell;
    }
    else
    {
        RightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Right forIndexPath:indexPath];
        SupermarketModel *model = self.productData[indexPath.section][indexPath.row];
        cell.model = model;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_rightTableView == tableView)
    {
        return 20;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_rightTableView == tableView)
    {
        HeaderView *view = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        CategoryModel *model = self.categoryData[section];
        view.name.text = model.name;
        return view;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section
{
    if ((_rightTableView == tableView) && !_isScrollDown && _rightTableView.dragging)
    {
        [self selectRowAtIndexPath:section];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if ((_rightTableView == tableView) && _isScrollDown && _rightTableView.dragging)
    {
        [self selectRowAtIndexPath:section + 1];
    }
}

- (void)selectRowAtIndexPath:(NSInteger)index
{
    [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (_leftTableView == tableView)
    {
        _selectIndex = indexPath.row;
        [_rightTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_selectIndex] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

#pragma mark - UISrcollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static CGFloat lastOffsetY = 0;
    
    UITableView *tableView = (UITableView *) scrollView;
    if (_rightTableView == tableView)
    {
        _isScrollDown = lastOffsetY < scrollView.contentOffset.y;
        lastOffsetY = scrollView.contentOffset.y;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
