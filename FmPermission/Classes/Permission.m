//
//  Permission.m
//  TestWebView
//
//  Created by wht on 2017/8/10.
//  Copyright © 2017年 hhwy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Permission.h"

@interface Permission()<CBCentralManagerDelegate,HMHomeManagerDelegate,NFCNDEFReaderSessionDelegate>
@end
@interface Permission()
@end

@implementation Permission{
@private
    void(^locationCallbacks)(BOOL);
    CLLocationManager* locationManager;
    void(^bluetoothCallbacks)(BOOL);
    CBCentralManager* centralManager;
    void(^homeCallbacks)(BOOL);
    HMHomeManager* homeManager;
    void(^nfcCallbacks)(BOOL);
}

-(void)getPermission:(NSMutableArray*)types callback:(nonnull void(^)(BOOL granted))callback{
    __block BOOL bool_true = YES;
    [self recursive:types index: 0 sum:(unsigned int)types.count callback:^(BOOL granted){
        if(!granted){
            bool_true = granted;
        }
    } done:^(){
        callback(bool_true);
    }];
}

-(void)recursive:(NSMutableArray*)types index:(int)index sum:(int)sum callback:(nonnull void(^)(BOOL granted))callback done:(nonnull void(^)(void))done{
    if(index < sum){
        [self requestPermission:[types objectAtIndex:index] callBack:^(BOOL granted){
            NSLog(@"----------------------------%@",granted?@"true":@"false");
            callback(granted);
            [self recursive:types index: index+1 sum:sum callback:callback done:done];
        }];
        return;
    }
    done();
}

- (void)requestPermission:(NSNumber*)type callBack:(nonnull void(^)(BOOL granted))callBack {
    switch ([type intValue]) {
        case PermissionTypeCalendar:
            [self requestCalendar: callBack];
            break;
            
        case PermissionTypeCamera:
            [self requestCamera: callBack];
            break;
            
        case PermissionTypeContacts:
            [self requestContacts: callBack];
            break;
            
        case PermissionTypeLocation:
            [self requestLocation: callBack];
            break;
            
        case PermissionTypeAudio:
            [self requestAudio: callBack];
            break;
            
        case PermissionTypePhotos:
            [self requestPhotos: callBack];
            break;
            
        case PermissionTypeNotification:
            [self requestNotification: callBack];
            break;
            
        case PermissionTypeReminder:
            [self requestReminder: callBack];
            break;
            
        case PermissionTypeMedia:
            [self requestMedia: callBack];
            break;
            
        case PermissionTypeSpeech:
            [self requestSpeech: callBack];
            break;
            
        case PermissionTypeSiri:
            [self requestSiri: callBack];
            break;
            
        case PermissionTypeHealth:
            [self requestHealth: callBack];
            break;
            
        case PermissionTypeBluetooth:
            [self requestBluetooth: callBack];
            break;
            
        case PermissionTypeHome:
            [self requestHome: callBack];
            break;
            
        case PermissionTypeAccounts:
            [self requestAccounts: callBack];
            break;
            
        case PermissionTypeNFC:
            [self requestNFC: callBack];
            break;
            
        case PermissionTypeFaceID:
            [self requestFaceID: callBack];
            break;
        
        default:
            callBack(NO);
            break;
    }
}



-(void)requestLocation:(void (^)(BOOL))locationCallback{
    locationCallbacks = locationCallback;
    if (locationManager == nil) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
    }
    [locationManager requestWhenInUseAuthorization];
}

-(void)requestPhotos: (void (^)(BOOL)) photosCallback{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        switch (status) {
            case PHAuthorizationStatusDenied:
            case PHAuthorizationStatusRestricted:
                photosCallback(NO);
                break;
            case PHAuthorizationStatusAuthorized:
                photosCallback(YES);
                break;
            case PHAuthorizationStatusNotDetermined:
                break;
        }
    }];
}

-(void)requestContacts:(void (^)(BOOL))contactsCallback{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        [[[CNContactStore alloc] init] requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            contactsCallback(granted);
        }];
    }else{
#pragma clang diagnostic push//忽略push和pop之间的警告
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(nil, nil), ^(bool granted, CFErrorRef error) {
            contactsCallback(granted);
        });
#pragma clang diagnostic pop
    }
}

-(void)requestCamera:(void (^)(BOOL))cameraCallback{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        cameraCallback(granted);
    }];
}

-(void)requestAudio:(void (^)(BOOL))audioCallback{
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        audioCallback(granted);
    }];
}

-(void)requestNotification:(void (^)(BOOL))notificationCallback{
#pragma clang diagnostic push//忽略push和pop之间的警告
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    UIUserNotificationSettings* settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    UIApplication* application = [UIApplication sharedApplication];
    [application registerUserNotificationSettings:settings];
    UIUserNotificationType type = [application currentUserNotificationSettings].types;
    switch (type) {
        case UIUserNotificationTypeAlert:
        case UIUserNotificationTypeBadge:
        case UIUserNotificationTypeSound:
            notificationCallback(YES);
            break;
        default:
        case UIUserNotificationTypeNone:
            notificationCallback(NO);
            break;
    }
#pragma clang diagnostic pop
}

-(void)requestCalendar:(void (^)(BOOL))calendarCallback{
    EKEventStore* store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent  completion:^(BOOL granted, NSError * _Nullable error) {
        calendarCallback(granted);
    }];
}

-(void)requestReminder:(void (^)(BOOL))reminderCallback{
    EKEventStore* store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeReminder  completion:^(BOOL granted, NSError * _Nullable error) {
        reminderCallback(granted);
    }];
}

-(void)requestMedia:(void (^)(BOOL))mediaCallback{
    if (@available(iOS 9.3, *)) {
        [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
            switch (status) {
                case MPMediaLibraryAuthorizationStatusDenied:
                case MPMediaLibraryAuthorizationStatusRestricted:
                    mediaCallback(NO);
                    break;
                case MPMediaLibraryAuthorizationStatusAuthorized:
                    mediaCallback(YES);
                    break;
                case MPMediaLibraryAuthorizationStatusNotDetermined:
                    break;
            }
    }];
    } else {
        mediaCallback(NO);
        // Fallback on earlier versions
    }
}

-(void)requestSpeech:(void (^)(BOOL))speechCallback{
#ifdef __IPHONE_10_0
    if (@available(iOS 10.0, *)) {
        [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
            switch (status) {
                case SFSpeechRecognizerAuthorizationStatusDenied:
                case SFSpeechRecognizerAuthorizationStatusRestricted:
                    speechCallback(NO);
                    break;
                case SFSpeechRecognizerAuthorizationStatusAuthorized:
                    speechCallback(YES);
                    break;
                case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                    break;
            }
    }];
    } else {
        speechCallback(NO);
        // Fallback on earlier versions
    }
#endif
}

-(void)requestSiri:(void (^)(BOOL))siriCallback{
#ifdef __IPHONE_10_0
    if (@available(iOS 10.0, *)) {
        [INPreferences requestSiriAuthorization:^(INSiriAuthorizationStatus status) {
            switch (status) {
                case INSiriAuthorizationStatusDenied:
                case INSiriAuthorizationStatusRestricted:
                    siriCallback(NO);
                    break;
                case INSiriAuthorizationStatusAuthorized:
                    siriCallback(YES);
                    break;
                case INSiriAuthorizationStatusNotDetermined:
                    break;
            }
    }];
    } else {
        siriCallback(NO);
        // Fallback on earlier versions
    }
#endif
}

-(void)requestHealth:(void (^)(BOOL))healthCallback{
    if([HKHealthStore isHealthDataAvailable]){
        HKHealthStore* healthStore = [[HKHealthStore alloc] init];
        HKQuantityType* stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
        HKQuantityType* distanceType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
        NSSet<HKSampleType*>* shareTypes = [NSSet setWithArray:@[stepType,distanceType]];
        NSSet<HKObjectType*>* readTypes = [NSSet setWithArray:@[stepType,distanceType]];
        [healthStore requestAuthorizationToShareTypes:shareTypes readTypes:readTypes completion:^(BOOL success, NSError * _Nullable error) {
            BOOL stepResult = [healthStore authorizationStatusForType:stepType] == HKAuthorizationStatusSharingAuthorized;
            BOOL distanceResult = [healthStore authorizationStatusForType:distanceType] == HKAuthorizationStatusSharingAuthorized;
            healthCallback(stepResult && distanceResult);
        }];
    }
}

-(void)requestHome:(void (^)(BOOL))homeCallback{
    if (homeManager == nil) {
        homeManager = [[HMHomeManager alloc] init];
    }
    __block typeof(homeManager) weakHomeManager = homeManager;
    [homeManager addHomeWithName:@"TestHome" completionHandler:^(HMHome * _Nullable home, NSError * _Nullable error) {
        homeCallback(error);
        if (home) {
            [weakHomeManager removeHome:home completionHandler:^(NSError * _Nullable error) {
                weakHomeManager = nil;
            }];
        }
    }];
}

-(void)requestAccounts:(void (^)(BOOL))accountsCallback{
    ACAccountStore* accountStore = [[ACAccountStore alloc] init];
    ACAccountType* accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierSinaWeibo];
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        accountsCallback(granted);
    }];
}

-(void)requestBluetooth:(void (^)(BOOL))bluetoothCallback{
    bluetoothCallbacks = bluetoothCallback;
    if (centralManager == nil) {
        centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    [centralManager scanForPeripheralsWithServices:nil options:nil];
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBManagerStateUnknown:
            NSLog(@"---------------   CBManagerStateUnknown");
            break;
        case CBManagerStateUnsupported:
            NSLog(@"---------------   CBManagerStateUnsupported");
            break;
        case CBManagerStatePoweredOff:
            NSLog(@"---------------   CBManagerStatePoweredOff");
            break;
        case CBManagerStateUnauthorized:
            NSLog(@"---------------   CBManagerStateUnauthorized");
            bluetoothCallbacks(NO);
            break;
        case CBManagerStatePoweredOn:
        case CBManagerStateResetting:
            bluetoothCallbacks(YES);
            break;
    }
    centralManager.delegate = nil;
    centralManager = nil;
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
            locationManager.delegate = nil;
            locationManager = nil;
            locationCallbacks(NO);
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            locationManager.delegate = nil;
            locationManager = nil;
            locationCallbacks(YES);
            break;
        case kCLAuthorizationStatusNotDetermined:
            break;
    }
}
-(void)requestFaceID:(nonnull void(^)(BOOL granted))faceIdCallback{
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    if([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error: &error]) {
        
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"FACE_ID_REASON" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                NSLog(@"验证成功--继续处理相关业务(注意线程");
                faceIdCallback(YES);
            } else {
                NSLog(@"%@",error.localizedDescription);
                faceIdCallback(NO);
                switch (error.code) {
                    case LAErrorSystemCancel:
                    {
                        NSLog(@"切换到其他APP，系统取消验证Touch ID");
                        break;
                    }
                    case LAErrorUserCancel:
                    {
                        NSLog(@"用户取消验证Touch ID");
                        break;
                    }
                    case LAErrorUserFallback:
                    {
                        NSLog(@"用户选择输入密码，切换主线程处理");
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        }];
                        break;
                    }
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //其他情况，切换主线程处理
                        }];
                        break;
                    }
                }
            }
        }];
    } else {
        faceIdCallback(NO);
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
                NSLog(@"LAErrorTouchIDNotEnrolled");
                break;
            case LAErrorPasscodeNotSet:
                NSLog(@"LAErrorPasscodeNotSet"); // 此处触发showPasscodeResetAlert方法
                break;
            default:
                NSLog(@"Touch ID is unaviliable");
                break;
        }
        NSLog(@"%@", error.localizedDescription);
    }
}

/**
 请求NFC权限
 
 @param nfcCallback 用户是否同意权限
 */
-(void)requestNFC:(nonnull void(^)(BOOL granted))nfcCallback{
    self->nfcCallbacks = nfcCallback;
    if (@available(iOS 11.0, *)) {
        NFCNDEFReaderSession *session = [[NFCNDEFReaderSession alloc]initWithDelegate:self queue:nil invalidateAfterFirstRead:YES];
        [session beginSession];
    } else {
        nfcCallbacks(NO);
        // Fallback on earlier versions
    }
}
#pragma mark - NFCNDEFReaderSessionDelegate
- (void)readerSession:(NFCNDEFReaderSession *)session didInvalidateWithError:(NSError *)error  API_AVAILABLE(ios(11.0)){
    if(error == nil){
        nfcCallbacks(YES);
        return;
    }
    nfcCallbacks(NO);
}

- (void)readerSession:(NFCNDEFReaderSession *)session didDetectNDEFs:(NSArray<NFCNDEFMessage *> *)messages  API_AVAILABLE(ios(11.0)){
    nfcCallbacks(YES);
}

@end
