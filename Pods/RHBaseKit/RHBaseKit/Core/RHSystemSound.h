//
//  RHSystemSound.h
//  RHBaseKit
//
//  Created by PengTao on 2017/8/11.
//  Copyright © 2017年 CMRH. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<AudioToolbox/AudioToolbox.h>)

#import <AudioToolbox/AudioToolbox.h>

/**
 *  System Audio IDs enum - http://iphonedevwiki.net/index.php/AudioServices
 */
typedef NS_ENUM(NSInteger, RHSystemAudioID) {
    /** New Mail */
    RHSystemAudioIDNewMail = 1000,
    /** Mail Sent */
    RHSystemAudioIDMailSent = 1001,
    /** Voice Mail */
    RHSystemAudioIDVoiceMail = 1002,
    /** Recived Message */
    RHSystemAudioIDRecivedMessage = 1003,
    /** Sent Message */
    RHSystemAudioIDSentMessage = 1004,
    /** Alerm */
    RHSystemAudioIDAlarm = 1005,
    /** Low pPower */
    RHSystemAudioIDLowPower = 1006,
    /** SMS Received 1 */
    RHSystemAudioIDSMSReceived1 = 1007,
    /** SMS Received 2 */
    RHSystemAudioIDSMSReceived2 = 1008,
    /** SMS Received 3 */
    RHSystemAudioIDSMSReceived3 = 1009,
    /** MS Received 4 */
    RHSystemAudioIDSMSReceived4 = 1010,
    /** MS Received 5 */
    RHSystemAudioIDSMSReceived5 = 1013,
    /** SMS Received 6 */
    RHSystemAudioIDSMSReceived6 = 1014,
    /** Tweet Sent */
    RHSystemAudioIDTweetSent = 1016,
    /** Anticipate */
    RHSystemAudioIDAnticipate = 1020,
    /** Bloom */
    RHSystemAudioIDBloom = 1021,
    /** Calypso */
    RHSystemAudioIDCalypso = 1022,
    /** Choo Choo */
    RHSystemAudioIDChooChoo = 1023,
    /** Descent */
    RHSystemAudioIDDescent = 1024,
    /** Fanfare */
    RHSystemAudioIDFanfare = 1025,
    /** Ladder */
    RHSystemAudioIDLadder = 1026,
    /** Minuet */
    RHSystemAudioIDMinuet = 1027,
    /** News Flash */
    RHSystemAudioIDNewsFlash = 1028,
    /** Noir */
    RHSystemAudioIDNoir = 1029,
    /** Sherwood Forest */
    RHSystemAudioIDSherwoodForest = 1030,
    /** Speel */
    RHSystemAudioIDSpell = 1031,
    /** Suspance */
    RHSystemAudioIDSuspence = 1032,
    /** Telegraph */
    RHSystemAudioIDTelegraph = 1033,
    /** Tiptoes */
    RHSystemAudioIDTiptoes = 1034,
    /** Typewriters */
    RHSystemAudioIDTypewriters = 1035,
    /** Update */
    RHSystemAudioIDUpdate = 1036,
    /** USSD Alert */
    RHSystemAudioIDUSSDAlert = 1050,
    /** SIM Toolkit Call Dropped */
    RHSystemAudioIDSIMToolkitCallDropped = 1051,
    /** SIM Toolkit General Beep */
    RHSystemAudioIDSIMToolkitGeneralBeep = 1052,
    /** SIM Toolkit Negative ACK */
    RHSystemAudioIDSIMToolkitNegativeACK = 1053,
    /** SIM Toolkit Positive ACK */
    RHSystemAudioIDSIMToolkitPositiveACK = 1054,
    /** SIM Toolkit SMS */
    RHSystemAudioIDSIMToolkitSMS = 1055,
    /** Tink */
    RHSystemAudioIDTink = 1057,
    /** CT Busy */
    RHSystemAudioIDCTBusy = 1070,
    /** CT Congestion */
    RHSystemAudioIDCTCongestion = 1071,
    /** CT Pack ACK */
    RHSystemAudioIDCTPathACK = 1072,
    /** CT Error */
    RHSystemAudioIDCTError = 1073,
    /** CT Call Waiting */
    RHSystemAudioIDCTCallWaiting = 1074,
    /** CT Keytone */
    RHSystemAudioIDCTKeytone = 1075,
    /** Lock */
    RHSystemAudioIDLock = 1100,
    /** Unlock */
    RHSystemAudioIDUnlock = 1101,
    /** Failed Unlock */
    RHSystemAudioIDFailedUnlock = 1102,
    /** Keypressed Tink */
    RHSystemAudioIDKeypressedTink = 1103,
    /** Keypressed Tock */
    RHSystemAudioIDKeypressedTock = 1104,
    /** Tock */
    RHSystemAudioIDTock = 1105,
    /** Beep Beep */
    RHSystemAudioIDBeepBeep = 1106,
    /** Ringer Charged */
    RHSystemAudioIDRingerCharged = 1107,
    /** Photo Shutter */
    RHSystemAudioIDPhotoShutter = 1108,
    /** Shake */
    RHSystemAudioIDShake = 1109,
    /** JBL Begin */
    RHSystemAudioIDJBLBegin = 1110,
    /** JBL Confirm */
    RHSystemAudioIDJBLConfirm = 1111,
    /** JBL Cancel */
    RHSystemAudioIDJBLCancel = 1112,
    /** Begin Recording */
    RHSystemAudioIDBeginRecording = 1113,
    /** End Recording */
    RHSystemAudioIDEndRecording = 1114,
    /** JBL Ambiguous */
    RHSystemAudioIDJBLAmbiguous = 1115,
    /** JBL No Match */
    RHSystemAudioIDJBLNoMatch = 1116,
    /** Begin Video Record */
    RHSystemAudioIDBeginVideoRecord = 1117,
    /** End Video Record */
    RHSystemAudioIDEndVideoRecord = 1118,
    /** VC Invitation Accepted */
    RHSystemAudioIDVCInvitationAccepted = 1150,
    /** VC Ringing */
    RHSystemAudioIDVCRinging = 1151,
    /** VC Ended */
    RHSystemAudioIDVCEnded = 1152,
    /** VC Call Waiting */
    BEAudioIDVCCallWaiting = 1153,
    /** VC Call Upgrade */
    RHSystemAudioIDVCCallUpgrade = 1154,
    /** Touch Tone 1 */
    RHSystemAudioIDTouchTone1 = 1200,
    /** Touch Tone 2 */
    RHSystemAudioIDTouchTone2 = 1201,
    /** Touch Tone 3 */
    RHSystemAudioIDTouchTone3 = 1202,
    /** Touch Tone 4 */
    RHSystemAudioIDTouchTone4 = 1203,
    /** Touch Tone 5 */
    RHSystemAudioIDTouchTone5 = 1204,
    /** Touch Tone 6 */
    RHSystemAudioIDTouchTone6 = 1205,
    /** Touch Tone 7 */
    RHSystemAudioIDTouchTone7 = 1206,
    /** Touch Tone 8 */
    RHSystemAudioIDTouchTone8 = 1207,
    /** Touch Tone 9 */
    RHSystemAudioIDTouchTone9 = 1208,
    /** Touch Tone 10 */
    RHSystemAudioIDTouchTone10 = 1209,
    /** Tone Star */
    RHSystemAudioIDTouchToneStar = 1210,
    /** Tone Pound */
    RHSystemAudioIDTouchTonePound = 1211,
    /** Headset Start Call */
    RHSystemAudioIDHeadsetStartCall = 1254,
    /** Headset Redial */
    RHSystemAudioIDHeadsetRedial = 1255,
    /** Headset Answer Call */
    RHSystemAudioIDHeadsetAnswerCall = 1256,
    /** Headset End Call */
    RHSystemAudioIDHeadsetEndCall = 1257,
    /** Headset Call Waiting Actions */
    RHSystemAudioIDHeadsetCallWaitingActions = 1258,
    /** Headset Transition End */
    RHSystemAudioIDHeadsetTransitionEnd = 1259,
    /** Voicemail */
    RHSystemAudioIDVoicemail = 1300,
    /** Received Message */
    RHSystemAudioIDReceivedMessage = 1301,
    /** New Mail 2 */
    RHSystemAudioIDNewMail2 = 1302,
    /** Email Sent 2 */
    RHSystemAudioIDMailSent2 = 1303,
    /** Alarm 2 */
    RHSystemAudioIDAlarm2 = 1304,
    /** Lock 2 */
    RHSystemAudioIDLock2 = 1305,
    /** Tock 2 */
    RHSystemAudioIDTock2 = 1306,
    /** SMS Received 7 */
    RHSystemAudioIDSMSReceived1_2 = 1307,
    /** SMS Received 8 */
    RHSystemAudioIDSMSReceived2_2 = 1308,
    /** SMS Received 9 */
    RHSystemAudioIDSMSReceived3_2 = 1309,
    /** SMS Received 10 */
    RHSystemAudioIDSMSReceived4_2 = 1310,
    /** SMS Received Vibrate */
    RHSystemAudioIDSMSReceivedVibrate = 1311,
    /** SMS Received 11 */
    RHSystemAudioIDSMSReceived1_3 = 1312,
    /** SMS Received 12 */
    RHSystemAudioIDSMSReceived5_3 = 1313,
    /** SMS Received 13 */
    RHSystemAudioIDSMSReceived6_3 = 1314,
    /** Voicemail 2 */
    RHSystemAudioIDVoicemail2 = 1315,
    /** Anticipate 2 */
    RHSystemAudioIDAnticipate2 = 1320,
    /** Bloom 2 */
    RHSystemAudioIDBloom2 = 1321,
    /** Calypso 2 */
    RHSystemAudioIDCalypso2 = 1322,
    /** Choo Choo 2 */
    RHSystemAudioIDChooChoo2 = 1323,
    /** Descent 2 */
    RHSystemAudioIDDescent2 = 1324,
    /** Fanfare 2 */
    RHSystemAudioIDFanfare2 = 1325,
    /** Ladder 2 */
    RHSystemAudioIDLadder2 = 1326,
    /** Minuet 2 */
    RHSystemAudioIDMinuet2 = 1327,
    /** News Flash 2 */
    RHSystemAudioIDNewsFlash2 = 1328,
    /** Noir 2 */
    RHSystemAudioIDNoir2 = 1329,
    /** Sherwood Forest 2 */
    RHSystemAudioIDSherwoodForest2 = 1330,
    /** Speel 2 */
    RHSystemAudioIDSpell2 = 1331,
    /** Suspence 2 */
    RHSystemAudioIDSuspence2 = 1332,
    /** Telegraph 2 */
    RHSystemAudioIDTelegraph2 = 1333,
    /** Tiptoes 2 */
    RHSystemAudioIDTiptoes2 = 1334,
    /** Typewriters 2 */
    RHSystemAudioIDTypewriters2 = 1335,
    /** Update 2 */
    RHSystemAudioIDUpdate2 = 1336,
    /** Ringer View Changed */
    RHSystemAudioIDRingerVibeChanged = 1350,
    /** Silent View Changed */
    RHSystemAudioIDSilentVibeChanged = 1351,
    /** Vibrate  */
    RHSystemAudioIDVibrate = 4095
};

@interface RHSystemSound : NSObject

/** 播放警告声音，如果手机在静音状态，警告声音将自动触发震动 */
+ (void)playSystemSound:(RHSystemAudioID)audioID __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_2_0);

#if TARGET_OS_IPHONE
/** 手机震动 */
+ (void)playSystemSoundVibrate NS_AVAILABLE_IPHONE(__IPHONE_2_0);
#endif

/** 播放自定义声音 */
+ (SystemSoundID)playCustomSound:(NSURL *_Nonnull)soundURL __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_2_0);

/** 清除自定义声音 */
+ (BOOL)disposeSound:(SystemSoundID)soundID __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_2_0);

@end

#endif /* __has_include */
