//
//  LYUser.m
//  Leyingke
//
//  Created by 思 高 on 12-9-10.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#import "LYUser.h"

@implementation LYUser
@synthesize userId = _userId;
@synthesize userInfo = _userInfo;
@synthesize userName = _userName;
@synthesize tinyurl = _tinyurl;
@synthesize headurl = _headurl;
@synthesize mainurl = _mainurl;
@synthesize online = _online;
@synthesize isRegister = _isRegister;
@synthesize phoneNum = _phoneNum;

- (void) dealloc
{
	LY_RELEASE_SAFELY(_userId);
	LY_RELEASE_SAFELY(_userName);
	LY_RELEASE_SAFELY(_tinyurl);
	LY_RELEASE_SAFELY(_headurl);
	LY_RELEASE_SAFELY(_mainurl);
    self.userInfo = nil;
    self.phoneNum = nil;
	[super dealloc];
}

- (void) setHeadurl:(NSString*)newURL
{
	if ((NSNull*)newURL == [NSNull null])
	{
		LY_RELEASE_SAFELY(_headurl);
		_headurl = [newURL copy];
		return;
	}
	
	if (![_headurl isEqualToString:newURL]) {
		NSString* temp = [newURL copy];
		[_headurl release];
		_headurl = temp;
	}
}

- (id) init {
	
	if (self = [super init]) {
		
	}
	return self;
}

- (id) initWithUserId:(NSString*)userId
{
	if (self = [self init])
	{
		self.userId = userId;
	}
	return self;
}

#pragma mark -
#pragma mark NSCoding methods
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [self init]) {
		self.userId = [decoder decodeObjectForKey:@"userId"];
		self.userName = [decoder decodeObjectForKey:@"userName"];
		self.tinyurl = [decoder decodeObjectForKey:@"tinyurl"];
		self.headurl = [decoder decodeObjectForKey:@"headURL"];
		self.mainurl = [decoder decodeObjectForKey:@"mainurl"];
        self.phoneNum = [decoder decodeObjectForKey:@"phonenum"];
	}
	return self;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)encodeWithCoder:(NSCoder*)encoder {
	[encoder encodeObject:self.userId forKey:@"userId"];
	[encoder encodeObject:self.userName forKey:@"userName"];
	[encoder encodeObject:self.tinyurl forKey:@"tinyurl"];
	[encoder encodeObject:self.headurl forKey:@"headURL"];
	[encoder encodeObject:self.mainurl forKey:@"mainurl"];
    [encoder encodeObject:self.phoneNum forKey:@"phonenum"];
}

@end
