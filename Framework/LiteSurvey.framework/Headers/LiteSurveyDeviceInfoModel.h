//
//  LiteSurveyDeviceInfo.h
//  LiteSurvey
//
//  Created by Woncan on 2024/10/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// General information of a LiteSurvey device
@interface LiteSurveyDeviceInfoModel : NSObject

/// Device model
@property (nonatomic,copy) NSString *deviceModel;

/// Device unique ID
@property (nonatomic,copy) NSString *deviceId;

/// Product name
@property (nonatomic,copy) NSString *productName;

/// Internal hardware identification number
@property (nonatomic,copy) NSString *serialNumber;

/// Firmware version
@property (nonatomic,copy) NSString *firmwareVersion;

/// Hardware version
@property (nonatomic,copy) NSString *hardwareVersion;

@end

NS_ASSUME_NONNULL_END
