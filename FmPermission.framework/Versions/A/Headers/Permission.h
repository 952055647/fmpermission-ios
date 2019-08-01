//
//  Permission.h
//  TestWebView
//
//  Created by wht on 2017/8/10.
//  Copyright © 2017年 hhwy. All rights reserved.
//

#ifndef Permission_h
#define Permission_h
#import <CoreLocation/CoreLocation.h>
#import <Photos/Photos.h>
#ifdef __IPHONE_9_0
#import <Contacts/Contacts.h>
#endif
#import <AddressBook/AddressBook.h>
#import <CoreTelephony/CTCellularData.h>
#import <UserNotifications/UserNotifications.h>
#import <EventKit/EventKit.h>
#ifdef __IPHONE_9_3
#import <MediaPlayer/MediaPlayer.h>
#endif
#ifdef __IPHONE_10_0
#import <Speech/Speech.h>
#import <Intents/Intents.h>
#endif
#import <HealthKit/HealthKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <HomeKit/HomeKit.h>
#import <Accounts/Accounts.h>

#import <AVFoundation/AVFoundation.h>
#import <LocalAuthentication/LocalAuthentication.h>
#import <CoreMotion/CoreMotion.h>
#import <StoreKit/StoreKit.h>
#import <CoreNFC/CoreNFC.h>

typedef NS_ENUM(NSInteger,PermissionType){
    //Notes：HomeKit、HealthKit、Siri need open switch of Capabilities in Xcode otherwise the project will crash when the requestPermission method called with these PermissionType
    
    //Privacy - Calendars Usage Description
    PermissionTypeCalendar = 0,//日历
    //Privacy - Camera Usage Description
    PermissionTypeCamera,//相机
    //Privacy - Contacts Usage Description
    PermissionTypeContacts,//通讯录
    //Privacy - Location When In Use Usage Description || Privacy - Location Always Usage Description
    PermissionTypeLocation,//定位
    //Privacy - Microphone Usage Description
    PermissionTypeAudio,//录音
    
    //Privacy - Photo Library Usage Description
    PermissionTypePhotos,//相册
    PermissionTypeNotification,//推送
    //Privacy - Reminders Usage Description
    PermissionTypeReminder,//提醒事件
    //Privacy - Media Library Usage Description && Privacy - Music Usage Description
    PermissionTypeMedia,//媒体资源库
    //Privacy - Speech Recognition Usage Description
    PermissionTypeSpeech,//语音识别
    //Privacy - Siri Usage Description
    PermissionTypeSiri,//Siri
    //Privacy - Health Share Usage Description && Privacy - Health Update Usage Description
    PermissionTypeHealth,//健康数据
    //Privacy - Bluetooth Peripheral Usage Description
    PermissionTypeBluetooth,//蓝牙
    //Privacy - HomeKit Usage Description
    PermissionTypeHome,//住宅
    PermissionTypeAccounts,//社交账户
    //Privacy - NFC Scan Usage Description
    PermissionTypeNFC,//NFC
    //Privacy - NSFaceIDUsageDescription
    PermissionTypeFaceID//FACEID
};

@interface Permission : NSObject

-(void)getPermission:(NSMutableArray*)types callback:(nonnull void(^)(BOOL granted))callback;
- (void)requestPermission:(NSNumber*)type callBack:(nonnull void(^)(BOOL granted))callBack;

/**
 请求定位权限

 @param locationCallback 用户是否同意权限
 */
-(void)requestLocation:(nonnull void(^)(BOOL granted))locationCallback;

/**
 请求相册权限

 @param photosCallback 用户是否同意权限
 */
-(void)requestPhotos:(nonnull void(^)(BOOL granted))photosCallback;

/**
 请求通讯录权限

 @param contactsCallback 用户是否同意权限
 */
-(void)requestContacts:(nonnull void(^)(BOOL granted))contactsCallback;

/**
 请求相机权限

 @param cameraCallback 用户是否同意权限
 */
-(void)requestCamera:(nonnull void(^)(BOOL granted))cameraCallback;

/**
 请求录音权限

 @param audioCallback 用户是否同意权限
 */
-(void)requestAudio:(nonnull void(^)(BOOL granted))audioCallback;

/**
 请求推送权限

 @param notificationCallback 用户是否同意权限
 */
-(void)requestNotification:(nonnull void(^)(BOOL granted))notificationCallback;

/**
 请求日历权限

 @param calendarCallback 用户是否同意权限
 */
-(void)requestCalendar:(nonnull void(^)(BOOL granted))calendarCallback;

/**
 请求提醒事件权限

 @param reminderCallback 用户是否同意权限
 */
-(void)requestReminder:(nonnull void(^)(BOOL granted))reminderCallback;

/**
 请求媒体库权限

 @param mediaCallback 用户是否同意权限
 */
-(void)requestMedia:(nonnull void(^)(BOOL granted))mediaCallback;

/**
 请求语音识别权限

 @param speechCallback 用户是否同意权限
 */
-(void)requestSpeech:(nonnull void(^)(BOOL granted))speechCallback;

/**
 请求Siri权限

 @param siriCallback 用户是否同意权限
 */
-(void)requestSiri:(nonnull void(^)(BOOL granted))siriCallback;

/**
 请求健康数据权限

 @param healthCallback 用户是否同意权限
 */
-(void)requestHealth:(nonnull void(^)(BOOL granted))healthCallback;

/**
 请求蓝牙权限

 @param bluetoothCallback 用户是否同意权限
 */
-(void)requestBluetooth:(nonnull void(^)(BOOL granted))bluetoothCallback;

/**
 请求住宅权限

 @param homeCallback 用户是否同意权限
 */
-(void)requestHome:(nonnull void(^)(BOOL granted))homeCallback;

/**
 请求社交账户权限

 @param accountsCallback 用户是否同意权限
 */
-(void)requestAccounts:(nonnull void(^)(BOOL granted))accountsCallback;

/**
 请求FaceID权限
 
 @param faceIdCallback 用户是否同意权限
 */
-(void)requestFaceID:(nonnull void(^)(BOOL granted))faceIdCallback;

/**
 请求NFC权限
 
 @param nfcCallback 用户是否同意权限
 */
-(void)requestNFC:(nonnull void(^)(BOOL granted))nfcCallback;

@end

#endif /* Permission_h */
