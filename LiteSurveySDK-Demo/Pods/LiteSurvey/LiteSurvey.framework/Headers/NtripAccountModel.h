//
//  NtripAccount.h
//  LiteSurvey
//
//  Created by Woncan on 2024/10/16.
//  Ntrip account details

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Ntrip account details
@interface NtripAccountModel : NSObject

/// IP address or URL
@property (nonatomic,copy) NSString *address;

/// Port number
@property (nonatomic,assign) int port;

/// mountpoint
@property (nonatomic,copy) NSString *mountpoint;

/// username
@property (nonatomic,copy) NSString *username;

/// password
@property (nonatomic,copy) NSString *password;

@end

NS_ASSUME_NONNULL_END
