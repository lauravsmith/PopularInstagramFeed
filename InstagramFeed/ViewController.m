//
//  ViewController.m
//  InstagramFeed
//
//  Created by Laura Smith on 2013-09-27.
//  Copyright (c) 2013 Laura Smith. All rights reserved.
//

#import "ViewController.h"
#import "InstagramPhoto.h"
#import "InstagramPhotoCell.h"
#import <AFNetworking/AFJSONRequestOperation.h>

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, strong) UITableView *feedTableView;
@property (nonatomic, strong) UITableViewController *feedTableViewControlller;
@end

@implementation ViewController

- (id)init {
    self = [super init];
    if (self) {
        self.imagesArray = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.feedTableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                      style:UITableViewStylePlain];
    self.feedTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleWidth;
    [self.feedTableView setDataSource:self];
    [self.feedTableView setDelegate:self];
    [self.view addSubview:self.feedTableView];
    
    self.feedTableViewControlller = [[UITableViewController alloc] init];
    self.feedTableViewControlller.tableView = self.feedTableView;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self
                       action:@selector(loadImages) forControlEvents:UIControlEventValueChanged];
    self.feedTableViewControlller.refreshControl = refreshControl;
    
    [self loadImages];
}

- (void)loadImages {
    NSURL *url = [NSURL URLWithString:@"https://api.instagram.com/v1/media/popular?client_id=50c0e12b64a84dd0b9bbf334ba7f6bf6"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *jsonDict = (NSDictionary *)JSON;
        [self process:jsonDict];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure");
    }];
    [operation start];
    
}

- (void)process:(NSDictionary *)json {
    NSArray *data = [json objectForKey:@"data"];
    [self.imagesArray removeAllObjects];
    for (NSDictionary *photo in data) {
        InstagramPhoto *newPhoto = [[InstagramPhoto alloc] init];
        NSURL *imageURL = [NSURL URLWithString:[[[photo objectForKey:@"images"] objectForKey:@"standard_resolution"] objectForKey:@"url"]];
        newPhoto.image = imageURL;
        if ([[photo objectForKey:@"caption"] isKindOfClass:[NSDictionary class]]) {
            newPhoto.caption = [[photo objectForKey:@"caption"] objectForKey:@"text"];
        }
        newPhoto.userName = [[photo objectForKey:@"user"] objectForKey:@"username"];
        newPhoto.timeStamp =
        [NSDate dateWithTimeIntervalSince1970:[[photo objectForKey:@"created_time"] doubleValue]];
        [self.imagesArray addObject:newPhoto];
    }
    
    [self.feedTableView reloadData];
    [self.feedTableViewControlller.refreshControl endRefreshing];
}

#pragma mark UITableViewDataSource Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float userNameHeight = [[[self.imagesArray objectAtIndex:indexPath.row] userName] sizeWithFont:[UIFont systemFontOfSize:12.0]
                                                                                 constrainedToSize:self.view.bounds.size].height;
    float captionHeight = [[[self.imagesArray objectAtIndex:indexPath.row] caption] sizeWithFont:[UIFont systemFontOfSize:12.0]
                                                                               constrainedToSize:self.view.bounds.size].height;
    return 300.0 + userNameHeight + captionHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.imagesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InstagramPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[InstagramPhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    [cell setPhoto:[self.imagesArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return;
}

@end