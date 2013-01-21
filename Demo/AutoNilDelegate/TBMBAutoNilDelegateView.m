//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-21 上午8:09.
//


#import "TBMBAutoNilDelegateView.h"
#import "TBMBBind.h"
#import "TBMBAutoNilDelegateViewDO.h"


@interface TBMBAutoNilDelegateView () <UITableViewDataSource, UITableViewDelegate>
@end

@implementation TBMBAutoNilDelegateView {
@private
    UITableView *_tableView;
}

- (void)loadView {
    [super loadView];

    UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds];
    TBMBAutoNilDelegate(UITableView *, tableView, delegate, self)
    TBMBAutoNilDelegate(UITableView *, tableView, dataSource, self)
    [self addSubview:tableView];
    _tableView = tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewDO.tableData.count;
}

static NSString *const identifier = @"TBMBAutoNilDelegateViewCell";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *value = nil;
    if (indexPath.row < self.viewDO.tableData.count && indexPath.row >= 0) {
        value = [self.viewDO.tableData objectAtIndex:(NSUInteger) indexPath.row];
    } else {
        return nil;
    }
    UITableViewCell *cell
            = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]
                                 initWithStyle:UITableViewCellStyleDefault
                               reuseIdentifier:identifier];
    }
    cell.textLabel.text = value;
    return cell;
}

- (void)dealloc {
    NSLog(@"%@ dealloc", self);
}


@end