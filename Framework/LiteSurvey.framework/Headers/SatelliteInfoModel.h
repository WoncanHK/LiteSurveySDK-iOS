//
//  SatelliteInfo.h
//  LiteSurvey
//
//  Created by Woncan on 2024/10/15.
//  GNSS Satellite information

#import <Foundation/Foundation.h>

/// GNSS Systems
typedef NS_ENUM(NSUInteger, GnssSystem){
    GnssSystemGPS = 0,//"G", "GPS", "GPS"
    GnssSystemGLONASS,//"R", "GLO", "GLONASS"
    GnssSystemGALILEO,//"E", "GAL", "GALILEO"
    GNSSSystemQZSS, //"J", "QZSS", "QZSS"
    GnssSystemBeidou//"C", "BDS", "Beidou"
};

NS_ASSUME_NONNULL_BEGIN

@class SignalInfoModel;

/// GNSS Satellite information
@interface SatelliteInfoModel : NSObject

/// GNSS system / constellation of this satellite
@property (nonatomic, assign) GnssSystem system;

/// FCN & OSN number for Glonass, PRN for other systems
@property (nonatomic, assign) int satelliteId;

/// true if satellite was used in recent GNSS fix, false otherwise
@property (nonatomic, assign) BOOL usedInFix;

/// elevation angle of this satellite, in degrees
@property (nonatomic, assign) float elevationDegrees;

/// azimuth angle of this satellite, in degrees
@property (nonatomic, assign) float azimuthDegrees;

/// List of signal information received by this satellite
@property (nonatomic, strong) NSMutableArray<SignalInfoModel*> *signalList;



@end


/// GNSS Signal Information
@interface SignalInfoModel : NSObject

/// Signal Id number as defined by NMEA GSV message
@property (nonatomic, assign) int gsvSignalId;

/// Name of the signal (for reference only)
@property (nonatomic, copy) NSString *signalName;

/// Signal-to-noise ratio (C/N0) in dBHz
@property (nonatomic, assign) float cn0DbHz;
@end

NS_ASSUME_NONNULL_END
