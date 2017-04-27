# 【Objective-C 联动】：两个 TableView 之间的联动，TableView 与 CollectionView 之间的联动

## 前言

现在市面上有很多 app 都有联动功能，有的是两个 TableView 之间的联动，比如美团外卖，百度外卖，饿了么等等。有的是 TableView 与 CollectionView 之间的联动，比如礼物说等等。

本文仿造了美团外卖和礼物说，分别实现了两个 TableView 之间和 TablView 与 CollectionView 之间的联动效果，效果图看下面的 gif 图。先附上 gif 图的 demo 下载链接，[【GitHub - OC 版】](https://github.com/leejayID/Linkage)、[【GitHub - Swift 版】](https://github.com/leejayID/Linkage-Swift)，配合 demo 一起看文章，效果会更佳。

![联动.gif](http://upload-images.jianshu.io/upload_images/1321491-c9c4ca5f36d38ff0.gif?imageMogr2/auto-orient/strip)

## 正文

### 一、TableView 与 TableView 之间的联动
下面来说下实现两个 TableView 之间联动的主要思路：
先解析数据装入模型，```objectWithDictionary:```是将字典转化为模型，这个工具是我用 runtime 写的，一行代码解析数据，具体使用方法可以参考我简书上另一篇文章[【Objective-C中的Runtime】](http://www.jianshu.com/p/3e050ec3b759)。

```objc
NSString *path = [[NSBundle mainBundle] pathForResource:@"meituan" ofType:@"json"];
NSData *data = [NSData dataWithContentsOfFile:path];
NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
NSArray *foods = dict[@"data"][@"food_spu_tags"];

for (NSDictionary *dict in foods)
{
    CategoryModel *model = [CategoryModel objectWithDictionary:dict];
    [self.categoryData addObject:model];
    
    NSMutableArray *datas = [NSMutableArray array];
    for (FoodModel *f_model in model.spus)
    {
        [datas addObject:f_model];
    }
    [self.foodData addObject:datas];
}
```

定义两个 TableView：LeftTableView 和 RightTableView。

```objc
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_leftTableView == tableView)
    {
        LeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Left forIndexPath:indexPath];
        FoodModel *model = self.categoryData[indexPath.row];
        cell.name.text = model.name;
        return cell;
    }
    else
    {
        RightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Right forIndexPath:indexPath];
        FoodModel *model = self.productData[indexPath.section][indexPath.row];
        cell.model = model;
        return cell;
    }
}
```
先将左边的 TableView 关联右边的 TableView：点击左边的 TableViewCell，右边的 TableView 跳到相应的分区列表头部。

```objc
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (_leftTableView == tableView)
    {
        _selectIndex = indexPath.row;
        [_rightTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_selectIndex] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}
```
再将右边的 TableView 关联左边的 TableView：标记一下 RightTableView 的滚动方向，然后分别在 TableView 分区标题即将展示和展示结束的代理函数里面处理逻辑。

* 1.在 TableView 分区标题即将展示里面，判断当前的 tableView 是 RightTableView， RightTableView 滑动的方向向上，RightTableView 是用户拖拽而产生滚动的（主要判断 RightTableView 是用户拖拽的，还是点击 LeftTableView 滚动的），如果三者都成立，那么 LeftTableView 的选中行就是 RightTableView 的当前 section。
* 2.在 TableView 分区标题展示结束里面，判断当前的 tableView 是 RightTableView，滑动的方向向下，RightTableView 是用户拖拽而产生滚动的，如果三者都成立，那么 LeftTableView 的选中行就是 RightTableView 的当前 section-1。

```objc
// 标记一下 RightTableView 的滚动方向，是向上还是向下
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

// TableView 分区标题即将展示
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section
{
    // 当前的 tableView 是 RightTableView，RightTableView 滚动的方向向上， RightTableView 是用户拖拽而产生滚动的（（主要判断 RightTableView 用户拖拽而滚动的，还是点击 LeftTableView 而滚动的）
    if ((_rightTableView == tableView) && !_isScrollDown && _rightTableView.dragging)
    {
        [self selectRowAtIndexPath:section];
    }
}

// TableView 分区标题展示结束
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // 当前的 tableView 是 RightTableView，RightTableView 滚动的方向向下， RightTableView 是用户拖拽而产生滚动的（主要判断 RightTableView 用户拖拽而滚动的，还是点击 LeftTableView 而滚动的）
    if ((_rightTableView == tableView) && _isScrollDown && _rightTableView.dragging)
    {
        [self selectRowAtIndexPath:section + 1];
    }
}

// 当拖动右边 TableView 的时候，处理左边 TableView
- (void)selectRowAtIndexPath:(NSInteger)index
{
    [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
}
```
这样就实现了两个 TableView 之间的联动，是不是很简单。
### 二、TableView 与 CollectionView 之间的联动
TableView 与 CollectionView 之间的联动与两个 TableView 之间的联动逻辑类似。
下面说下实现 TableView 与 CollectionView 之间的联动的主要思路：
还是一样，先解析数据装入模型。

```objc
NSString *path = [[NSBundle mainBundle] pathForResource:@"liwushuo" ofType:@"json"];
NSData *data = [NSData dataWithContentsOfFile:path];
NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
NSArray *categories = dict[@"data"][@"categories"];

for (NSDictionary *dict in categories)
{
    CollectionCategoryModel *model = [CollectionCategoryModel objectWithDictionary:dict];
    [self.dataSource addObject:model];
    
    NSMutableArray *datas = [NSMutableArray array];
    for (SubCategoryModel *sModel in model.subcategories)
    {
        [datas addObject:sModel];
    }
    [self.collectionDatas addObject:datas];
}
```

定义一个 TableView，一个 CollectionView。

```objc
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Left forIndexPath:indexPath];
    CollectionCategoryModel *model = self.dataSource[indexPath.row];
    cell.name.text = model.name;
    return cell;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_CollectionView forIndexPath:indexPath];
    SubCategoryModel *model = self.collectionDatas[indexPath.section][indexPath.row];
    cell.model = model;
    return cell;
}
```

先将 TableView 关联 CollectionView，点击 TableViewCell，右边的 CollectionView 跳到相应的分区列表头部。

```objc
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectIndex = indexPath.row;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:_selectIndex] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}
```

再将 CollectionView 关联 TableView，标记一下 RightTableView 的滚动方向，然后分别在 CollectionView 分区标题即将展示和展示结束的代理函数里面处理逻辑。

* 1.在 CollectionView 分区标题即将展示里面，判断 当前 CollectionView 滚动的方向向上， CollectionView 是用户拖拽而产生滚动的（主要是判断 CollectionView 是用户拖拽而滚动的，还是点击 TableView 而滚动的），如果二者都成立，那么 TableView 的选中行就是 CollectionView 的当前 section。
* 2.在 CollectionView 分区标题展示结束里面，判断当前 CollectionView 滚动的方向向下， CollectionView 是用户拖拽而产生滚动的，如果二者都成立，那么 TableView 的选中行就是 CollectionView 的当前 section-1。

```objc
// 标记一下 CollectionView 的滚动方向，是向上还是向下
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static float lastOffsetY = 0;
    
    if (self.collectionView == scrollView)
    {
        _isScrollDown = lastOffsetY < scrollView.contentOffset.y;
        lastOffsetY = scrollView.contentOffset.y;
    }
}

// CollectionView 分区标题即将展示
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    // 当前 CollectionView 滚动的方向向上，CollectionView 是用户拖拽而产生滚动的（主要是判断 CollectionView 是用户拖拽而滚动的，还是点击 TableView 而滚动的）
    if (!_isScrollDown && collectionView.dragging)
    {
        [self selectRowAtIndexPath:indexPath.section];
    }
}

// CollectionView 分区标题展示结束
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(nonnull UICollectionReusableView *)view forElementOfKind:(nonnull NSString *)elementKind atIndexPath:(nonnull NSIndexPath *)indexPath
{
    // 当前 CollectionView 滚动的方向向下，CollectionView 是用户拖拽而产生滚动的（主要是判断 CollectionView 是用户拖拽而滚动的，还是点击 TableView 而滚动的）
    if (_isScrollDown && collectionView.dragging)
    {
        [self selectRowAtIndexPath:indexPath.section + 1];
    }
}

// 当拖动 CollectionView 的时候，处理 TableView
- (void)selectRowAtIndexPath:(NSInteger)index
{
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}
```
TableView 与 CollectionView 之间的联动就这么实现了，是不是也很简单。

## 最后

由于笔者水平有限，文中如果有错误的地方，或者有更好的方法，还望大神指出。
附上本文的所有 demo 下载链接，[【GitHub - OC 版】](https://github.com/leejayID/Linkage)、[【GitHub - Swift 版】](https://github.com/leejayID/Linkage-Swift)，配合 demo 一起看文章，效果会更佳。
如果你看完后觉得对你有所帮助，还望在 GitHub 上点个 star。赠人玫瑰，手有余香。

## 建议 & 支持

如有问题请[与我联系](mailto:leejay_email@163.com)

