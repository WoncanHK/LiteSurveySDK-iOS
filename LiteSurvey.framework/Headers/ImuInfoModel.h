//
//  ImuInfo.h
//  LiteSurvey
//
//  Created by Woncan on 2024/10/16.
//  Inertial measurement unit (IMU) data

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Inertial measurement unit (IMU) data
@interface ImuInfoModel : NSObject

/// Accelerometer X,Y,Z data in unit of gravitational acceleration g
@property (nonatomic,strong) NSArray *accelerometer;

/// Gyroscope X,Y,Z in degrees per second
@property (nonatomic,strong) NSArray *gyroscope;

@end

NS_ASSUME_NONNULL_END
