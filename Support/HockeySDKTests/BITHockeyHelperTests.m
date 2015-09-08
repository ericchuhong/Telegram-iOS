//
//  HockeySDKPrivateTests.m
//  HockeySDK
//
//  Created by Andreas Linde on 25.09.13.
//
//

#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#define MOCKITO_SHORTHAND
#import <OCMockitoIOS/OCMockitoIOS.h>

#import "HockeySDK.h"
#import "BITHockeyHelper.h"
#import "BITKeychainUtils.h"


@interface BITHockeyHelperTests : XCTestCase

@end

@implementation BITHockeyHelperTests


- (void)setUp {
  [super setUp];
  // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown {
  // Tear-down code here.
  [super tearDown];
}

- (void)testValidateEmail {
  BOOL result = NO;
  
  // valid email
  result = bit_validateEmail(@"mail@test.com");
  assertThatBool(result, equalToBool(YES));
  
  // invalid emails
  
  result = bit_validateEmail(@"mail@test");
  assertThatBool(result, equalToBool(NO));

  result = bit_validateEmail(@"mail@.com");
  assertThatBool(result, equalToBool(NO));

  result = bit_validateEmail(@"mail.com");
  assertThatBool(result, equalToBool(NO));

}

- (void)testAppName {
  NSString *resultString = bit_appName(@"Placeholder");
  assertThatBool([resultString isEqualToString:@"Placeholder"], equalToBool(YES));
}

- (void)testUUIDPreiOS6 {
  NSString *resultString = bit_UUIDPreiOS6();
  assertThat(resultString, notNilValue());
  assertThatInteger([resultString length], equalToInteger(36));
}

- (void)testUUID {
  NSString *resultString = bit_UUID();
  assertThat(resultString, notNilValue());
  assertThatInteger([resultString length], equalToInteger(36));
}

- (void)testAppAnonID {
  // clean keychain cache
  NSError *error = NULL;
  [BITKeychainUtils deleteItemForUsername:@"appAnonID"
                           andServiceName:bit_keychainHockeySDKServiceName()
                                    error:&error];
  
  NSString *resultString = bit_appAnonID(NO);
  assertThat(resultString, notNilValue());
  assertThatInteger([resultString length], equalToInteger(36));
}

- (void)testValidAppIconFilename {
  NSString *resultString = nil;
  NSBundle *mockBundle = mock([NSBundle class]);
  NSBundle *resourceBundle = [NSBundle bundleForClass:self.class];
  NSString *validIconPath = @"AppIcon";
  NSString *validIconPath2x = @"AppIcon@2x";
  
  // No valid icons defined at all
  [given([mockBundle objectForInfoDictionaryKey:@"CFBundleIconFiles"]) willReturn:nil];
  [given([mockBundle objectForInfoDictionaryKey:@"CFBundleIcons"]) willReturn:nil];
  [given([mockBundle objectForInfoDictionaryKey:@"CFBundleIcons~ipad"]) willReturn:nil];
  [given([mockBundle objectForInfoDictionaryKey:@"CFBundleIconFile"]) willReturn:@"invalidFilename.png"];
  
  resultString = bit_validAppIconFilename(mockBundle, resourceBundle);
  assertThat(resultString, nilValue());
  
  // CFBundleIconFiles contains valid filenames
  [given([mockBundle objectForInfoDictionaryKey:@"CFBundleIconFiles"]) willReturn:@[validIconPath, validIconPath2x]];
  [given([mockBundle objectForInfoDictionaryKey:@"CFBundleIcons"]) willReturn:nil];
  [given([mockBundle objectForInfoDictionaryKey:@"CFBundleIcons~ipad"]) willReturn:nil];
  [given([mockBundle objectForInfoDictionaryKey:@"CFBundleIconFile"]) willReturn:nil];

  resultString = bit_validAppIconFilename(mockBundle, resourceBundle);
  assertThat(resultString, notNilValue());
  
  // CFBundleIcons contains valid dictionary filenames
  [given([mockBundle objectForInfoDictionaryKey:@"CFBundleIconFiles"]) willReturn:@[@"invalidFilename.png"]];
  [given([mockBundle objectForInfoDictionaryKey:@"CFBundleIcons"]) willReturn:@{@"CFBundlePrimaryIcon":@{@"CFBundleIconFiles":@[validIconPath, validIconPath2x]}}];
  [given([mockBundle objectForInfoDictionaryKey:@"CFBundleIcons~ipad"]) willReturn:nil];
  [given([mockBundle objectForInfoDictionaryKey:@"CFBundleIconFile"]) willReturn:nil];

  // CFBundleIcons contains valid ipad dictionary and valid default dictionary filenames
  [given([mockBundle objectForInfoDictionaryKey:@"CFBundleIconFiles"]) willReturn:@[@"invalidFilename.png"]];
  [given([mockBundle objectForInfoDictionaryKey:@"CFBundleIcons"]) willReturn:@{@"CFBundlePrimaryIcon":@{@"CFBundleIconFiles":@[validIconPath, validIconPath2x]}}];
  [given([mockBundle objectForInfoDictionaryKey:@"CFBundleIcons~ipad"]) willReturn:@{@"CFBundlePrimaryIcon":@{@"CFBundleIconFiles":@[validIconPath, validIconPath2x]}}];
  [given([mockBundle objectForInfoDictionaryKey:@"CFBundleIconFile"]) willReturn:nil];

  resultString = bit_validAppIconFilename(mockBundle, resourceBundle);
  assertThat(resultString, notNilValue());

  // CFBundleIcons contains valid filenames
  [given([mockBundle objectForInfoDictionaryKey:@"CFBundleIconFiles"]) willReturn:@[@"invalidFilename.png"]];
  [given([mockBundle objectForInfoDictionaryKey:@"CFBundleIcons"]) willReturn:@[validIconPath, validIconPath2x]];
  [given([mockBundle objectForInfoDictionaryKey:@"CFBundleIcons~ipad"]) willReturn:nil];
  [given([mockBundle objectForInfoDictionaryKey:@"CFBundleIconFile"]) willReturn:nil];

  resultString = bit_validAppIconFilename(mockBundle, resourceBundle);
  assertThat(resultString, notNilValue());

  // CFBundleIcon contains valid filename
  [given([mockBundle objectForInfoDictionaryKey:@"CFBundleIconFiles"]) willReturn:@[@"invalidFilename.png"]];
  [given([mockBundle objectForInfoDictionaryKey:@"CFBundleIcons"]) willReturn:nil];
  [given([mockBundle objectForInfoDictionaryKey:@"CFBundleIcons~ipad"]) willReturn:nil];
  [given([mockBundle objectForInfoDictionaryKey:@"CFBundleIconFile"]) willReturn:validIconPath];
  
  resultString = bit_validAppIconFilename(mockBundle, resourceBundle);
  assertThat(resultString, notNilValue());
}

- (void)testDevicePlattform {
  NSString *resultString = bit_devicePlatform();
  assertThat(resultString, notNilValue());
}

- (void)testDeviceModel {
  NSString *resultString = bit_devicePlatform();
  assertThat(resultString, notNilValue());
}

- (void)testOsVersion {
  NSString *resultString = bit_osVersionBuild();
  assertThat(resultString, notNilValue());
  assertThatFloat([resultString floatValue], greaterThan(@(0.0)));
}

- (void)testOsName {
  NSString *resultString = bit_osName();
  assertThat(resultString, notNilValue());
  assertThatInteger([resultString length], greaterThan(@(0)));
}

- (void)testDeviceType {
  NSString *resultString = bit_deviceType();
  assertThat(resultString, notNilValue());
  NSArray *typesArray = @[@"Phone", @"Tablet", @"Unknown"];
  assertThat(typesArray, hasItem(resultString));
}

- (void)testSdkVersion {
  NSString *resultString = bit_sdkVersion();
  assertThat(resultString, notNilValue());
  assertThatInteger([resultString length], greaterThan(@(0)));
}

- (void)testUtcDateString{
  NSDate *testDate = [NSDate dateWithTimeIntervalSince1970:0];
  NSString *utcDateString = bit_utcDateString(testDate);
  
  assertThat(utcDateString, equalTo(@"1970-01-01T00:00:00.000Z"));
}

#ifndef CI
- (void)testUtcDateStringPerformane {
  [self measureBlock:^{
    for (int i = 0; i < 100; i++) {
      NSDate *testDate = [NSDate dateWithTimeIntervalSince1970:0];
      NSString *utcDateString = bit_utcDateString(testDate);
    }
  }];
}
#endif

@end
