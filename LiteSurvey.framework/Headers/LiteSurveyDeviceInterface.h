//
//  LiteSurveyDeviceInterface.h
//  LiteSurvey
//
//  Created by Woncan on 2024/10/15.
//
//  This interface provides access to LiteSurvey devices.
//  Methods contained in this interface allow applications to
//  1. Scan for, connect to, and disconnect from LiteSurvey devices;
//  2. Change the settings of device's output or peripherals;
//  3. Receive notifications when data have arrived from the device;
//  4. Query basic information about the device.
//
//  Implemented by the LiteSurveyDevice class.

#import <Foundation/Foundation.h>
#import <LiteSurvey/LiteSurveyDeviceDelegate.h>
#import <LiteSurvey/NtripAccountModel.h>

NS_ASSUME_NONNULL_BEGIN

///  This interface provides access to LiteSurvey devices.
///
///  Methods contained in this interface allow applications to
///  1. Scan for, connect to, and disconnect from LiteSurvey devices;
///  2. Change the settings of device's output or peripherals;
///  3. Receive notifications when data have arrived from the device;
///  4. Query basic information about the device.
///
///  Implemented by the LiteSurveyDevice class.
@interface LiteSurveyDeviceInterface : NSObject

@property (nonatomic, weak) id<LiteSurveyDeviceDelegate> delegate;

/// Display name of the LiteSurvey device
@property (nonatomic,copy) NSString *displayName;


- (instancetype)initWithDelegate:(id<LiteSurveyDeviceDelegate>)delegate;

/// Scans for LiteSurvey devices (Bluetooth and USB serial).
///
/// If a LiteSurvey device is already discovered by the system when this function is called,
/// device connection will be automatically established. Otherwise, an Accessory Picker window will be shown.
/// After establishing a connection, the deviceDidConnect callback will be called.
- (void)startScan;

/// Attempts to disconnect from the LiteSurvey device. Monitor its progress with the deviceDidDisconnect callback
- (void)disconnect;


/// Set the constellation systems used in position
/// - Parameters:
///   - enableGPS: TRUE = enable GPS system, FALSE = disable GPS system
///   - enableGLONASS: TRUE = enable GLONASS system, FALSE = disable GLONASS system
///   - enableGALILEO: TRUE = enable GALILEO system, FALSE = disable GALILEO system
///   - enableQZSS: TRUE = enable QZSS system,FALSE = disable QZSS system
///   - enableBeidou: TRUE = enable Beidou system, FALSE = disable Beidou system
- (void)setGnssSystems:(BOOL)enableGPS enableGLONASS:(BOOL)enableGLONASS enableGALILEO:(BOOL)enableGALILEO enableQZSS:(BOOL)enableQZSS enableBeidou:(BOOL)enableBeidou;

/// Sets the output rate of an NMEA message
/// - Parameters:
///   - nmeaType: Type of an NMEA message
///   - enable: TRUE: enable FALSE:disable
- (void)setNmeaOutput:(NmeaType)nmeaType enable:(BOOL)enable;

/// Enable the output of a RTCM message (if supported)
/// - Parameter rtcmMessageNumbers: RTCM message number
- (void)setRtcmOutput:(NSArray *)rtcmMessageNumbers;

/// Disable the output of a RTCM message (if supported)
- (void)disableRtcmOutput;

/// Enables or disables the laser of the LiteSurvey device
/// - Parameter enable: TRUE = enable laser. FALSE = disable laser.
- (void)setLaserState:(BOOL)enable;

/// Set the output rate of the inertial measurement unit (IMU), if available
/// - Parameter rateMillis: Output rate in milliseconds
- (void)setImuOutput:(int)rateMillis;

/// Query whether firmware upgrade is available for this LiteSurvey device.
///
/// Monitor the didReceiveFirmwareUpgradeAvailability callback for results.
/// This request will send your basic device information (device ID, serial number, etc.) to Woncan servers.
- (void)queryFirmwareUpgrade;

/// Attempts to upgrade the firmware of this LiteSurvey device.
///
/// Monitor the firmwareUpgradeDidProgress callback for upgrade progress
/// This request will send your basic device information (device ID, serial number, etc.) to Woncan servers.
- (void)startFirmwareUpgrade;


/// Query NTRIP mountpoints for an NTRIP server
/// - Parameters:
///   - address: IP address or URL of NTRIP server
///   - port: Port of NTRIP server
- (void)queryNtripMountpoint:(NSString *)address port:(NSString *)port;

/// Connect to the specified NTRIP account.
/// - Parameters:
///   - ntripAccount: NTRIP account to connect
///   - transmitNmeaPosition: transmitNmeaPosition if true, location of LiteSurvey device will be transmitted to the NTRIP server.
- (void)startNtripConnection:(NtripAccountModel *)ntripAccount transmitNmeaPosition:(BOOL)transmitNmeaPosition;

/// Disconnect NTRIP service for this LiteSurvey device
- (void)stopNtripConnection;


/// Retrieves details of currently active NTRIP account
- (NtripAccountModel *)getNtripAccount;


@end

NS_ASSUME_NONNULL_END
