//
//  DemoViewController.m
//  JXRequestManagerDemo
//
//  Created by JLee21 on 2015/11/26.
//  Copyright © 2015年 VS7X. All rights reserved.
//

#import "DemoViewController.h"
#import "JXRequestManager.h"

@interface DemoViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *contentArray;
@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"JXRequestManagerDemo";
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    _contentArray = [NSMutableArray array];
    NSString *baseUrl = @"http://rest-service.guides.spring.io/greeting";
    
    NSInteger numberOfRequest = 50;
    for (int n=1; n<=numberOfRequest; n++)
    {
        NSString *urlString = [NSString stringWithFormat:@"%@?name=JXUser_%d",baseUrl,n];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        [info setObject:[NSString stringWithFormat:@"URL[%d]",n] forKey:@"url"];
        [_contentArray addObject:info];
        
        __weak NSMutableDictionary *weakInfo = info;
        __weak UITableView *weakTableView = _tableView;
        [[JXRequestManager sharedManager] addRequest:request withHandler:^(NSURLResponse *response, NSData *data, NSError *error) {

            if (error) {
                [weakInfo setObject:[error localizedDescription] forKey:@"content"];
            } else {
                NSError *parseError = nil;
                NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                if (jsonData) {
                    NSString *contentString = [jsonData objectForKey:@"content"];
                    [weakInfo setObject:contentString forKey:@"content"];
                    
                    // UI update
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        
                        [weakTableView beginUpdates];
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:n-1 inSection:0];
                        [weakTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                        [weakTableView endUpdates];
                    }];
                }
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _contentArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellType = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellType];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellType];
    }
    NSDictionary *info = _contentArray[indexPath.row];
    cell.textLabel.text = [info objectForKey:@"url"];
    cell.detailTextLabel.text = [info objectForKey:@"content"];
    return cell;
}

@end
