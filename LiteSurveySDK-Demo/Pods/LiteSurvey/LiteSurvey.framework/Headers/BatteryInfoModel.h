//
//  BatteryInfo.h
//  LiteSurvey
//
//  Created by Woncan on 2024/10/15.
//  LiteSurvey device battery information

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// LiteSurvey device battery information
@interface BatteryInfoModel : NSObject

/// Battery percentage remaining
@property (nonatomic,assign) int percentageRemaining;

/// true if charger is connected, false otherwise
@property (nonatomic,assign) BOOL chargerConnected;

/// true if battery is charging, false otherwise
@property (nonatomic,assign) BOOL isCharging;


@end

NS_ASSUME_NONNULL_END
