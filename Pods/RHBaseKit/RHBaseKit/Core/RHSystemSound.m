//
//  RHSystemSound.m
//  RHBaseKit
//
//  Created by PengTao on 2017/8/11.
//  Copyright © 2017年 CMRH. All rights reserved.
//

#import "RHSystemSound.h"

#if __has_include(<AudioToolbox/AudioToolbox.h>)

@implementation RHSystemSound

+ (void)playSystemSound:(RHSystemAudioID)audioID {
    AudioServicesPlaySystemSound(audioID);
}

#if TARGET_OS_IPHONE
+ (void)playSystemSoundVibrate {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}
#endif

+ (SystemSoundID)playCustomSound:(NSURL *)soundURL {
    SystemSoundID soundID;
    
    CFURLRef URL = (__bridge_retained CFURLRef)soundURL;
    OSStatus error = AudioServicesCreateSystemSoundID(URL, &soundID);
    CFRelease(URL);
    if (error != kAudioServicesNoError) {
        NSLog(@"Could not load %@", soundURL);
    }
    
    AudioServicesPlaySystemSound(soundID);
    return soundID;
}

+ (BOOL)disposeSound:(SystemSoundID)soundID {
    OSStatus error = AudioServicesDisposeSystemSoundID(soundID);
    if (error != kAudioServicesNoError) {
        NSLog(@"Error while disposing sound %i", (unsigned int)soundID);
        return NO;
    }
    return YES;
}

@end

#endif /* __has_include */
