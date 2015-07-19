//
//  UserProfileHeaderView.m
//  MrCode
//
//  Created by hao on 7/19/15.
//  Copyright (c) 2015 hao. All rights reserved.
//

#import "UserProfileHeaderView.h"
#import "GITUser.h"
#import "UIImage+MRC_Octicons.h"

#import "Masonry.h"
#import "NSDate+DateTools.h"


@interface UserProfileHeaderView ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *bioLabel;
@property (nonatomic, strong) UIButton    *followersButton;
@property (nonatomic, strong) UIButton    *repositoriesButton;
@property (nonatomic, strong) UIButton    *followingButton;

@end

@implementation UserProfileHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    _avatarImageView = [UIImageView new];
    _avatarImageView.image = [UIImage octicon_imageWithIdentifier:@"Person" size:CGSizeMake(30.f, 30.f)];
    [self addSubview:_avatarImageView];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:14.f];
    _titleLabel.textColor = [UIColor darkTextColor];
    [self addSubview:_titleLabel];
    
    _bioLabel = [UILabel new];
    _bioLabel.font = [UIFont systemFontOfSize:10.f];
    _bioLabel.textColor = [UIColor lightGrayColor];
    _bioLabel.numberOfLines = 1;
    [self addSubview:_bioLabel];
    
    // Buttons
    _followersButton = [UIButton new];
    [self setupButton:_followersButton withTag:101];
    
    _repositoriesButton = [UIButton new];
    [self setupButton:_repositoriesButton withTag:102];
    
    _followingButton = [UIButton new];
    [self setupButton:_followingButton withTag:103];

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.left.equalTo(@5);
        make.top.equalTo(@10);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_right).offset(10);
        make.top.equalTo(@10);
    }];
    
    [self.bioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(4);
    }];
    self.bioLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.bounds) - 15 * 2;
    
    // Buttons
    CGFloat horizontalPadding = 15;
    [self.followersButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.left.mas_equalTo(horizontalPadding);
        make.top.equalTo(self.avatarImageView.mas_bottom).offset(10);
    }];
    [self.repositoriesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.followersButton);
        make.left.equalTo(self.followersButton.mas_right).offset(horizontalPadding);
        make.top.equalTo(self.followersButton);
    }];
    [self.followingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.repositoriesButton);
        make.left.equalTo(self.repositoriesButton.mas_right).offset(horizontalPadding);
        make.top.equalTo(self.repositoriesButton);
        make.right.mas_equalTo(-horizontalPadding);
    }];
}

#pragma mark - Private

- (void)setupButton:(UIButton *)button withTag:(NSUInteger)tag
{
    button.tag = tag;
    
    button.layer.borderWidth = 1;
    button.layer.borderColor = [[UIColor blackColor] CGColor];
    
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    button.titleLabel.numberOfLines = 2;
    button.titleLabel.font = [UIFont systemFontOfSize:11];
    button.backgroundColor = [UIColor greenColor];
    button.enabled = YES;
    [button setUserInteractionEnabled:YES];
    [button setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:button];
}

- (void)tapButton:(UIButton *)button
{
    NSLog(@"%@", @(button.tag));
}

- (void)setUser:(GITUser *)user
{
    _user = user;
    self.titleLabel.text = user.login;
    self.bioLabel.text   = user.bio ? : [NSString stringWithFormat:@"Updated %@", user.updatedAt.timeAgoSinceNow];
    
    [self.followingButton setTitle:[NSString stringWithFormat:@"Following\n%@", @(user.following)] forState:UIControlStateNormal];
    [self.repositoriesButton setTitle:[NSString stringWithFormat:@"Repositories\n%@", @(user.publicRepos)] forState:UIControlStateNormal];
    [self.followersButton setTitle:[NSString stringWithFormat:@"Followers\n%@", @(user.followers)] forState:UIControlStateNormal];
}

@end
