# App Store Review Feedback - Guideline 2.1

## Review Issue

**Date:** 30/05/2025  
**Guideline:** 2.1 - Information Needed

### Problem Description

We were unable to sign in with the following demo account credentials you provided in App Store Connect:

**User name:** +11213141516  
**Password:** 123456

To avoid delays, it is essential to provide access to the app's full features and functionality with every submission.

### Next Steps Required by Apple

Provide the username and password for a valid demo account in App Store Connect that provides full access to the app's features and functionality or include a demonstration mode that shows all of the features and functionality available in the app. Note that we cannot use a demo video showing the app in use to continue the review.

---

## Solution Implemented

**Issue Root Cause:** Test account validity had expired

**Solution:** Fixed the test account validity by updating it in Supabase

**Status:** ✅ Resolved

### Notes
- No code file edits were required
- Issue was resolved by updating account credentials in Supabase backend
- Test account is now valid and should allow Apple reviewers full access to app features

---

## Debug Logging Added

**Date:** 30/05/2025  
**Issue:** Verify button not working on OTP verification screen

### Debugging Changes Made

Added comprehensive logging to track the OTP verification flow:

1. **OTP Verification Page** (`lib/app/platforms/mobile/auth/presentation/pages/otp_verification.dart`)
   - Added logs when verify button is tapped
   - Logs OTP value, length, verification type, and callback function

2. **Auth Bloc** (`lib/app/platforms/mobile/auth/presentation/bloc/auth_bloc/bloc.dart`)
   - Added logs when OnVerifyEvent is received
   - Logs OTP validation, phone number, and verification flow
   - Added logs for insufficient OTP length
   - Enhanced error logging with stack traces

3. **Auth Controller** (`lib/app/shared/core/backend_controller/auth_controller/auth_controller_impl.dart`)
   - Added logs for Supabase API calls
   - Logs OTP, phone number, and API response
   - Enhanced error logging for API failures

### Log Identifiers
- 🔥 `[OTP_VERIFICATION]` - UI level logs
- 🚀 `[AUTH_BLOC]` - Business logic logs  
- 📱 `[AUTH_CONTROLLER]` - API level logs

### Usage
Check console/debug logs when testing OTP verification to identify where the flow is failing.

---

## Issue Resolution

**Date:** 30/05/2025  
**Issue:** OTP verification successful but no navigation happening

### Root Cause Found
Through the comprehensive logging, we identified that:
1. ✅ OTP verification with Supabase was successful (User ID: 276fba41-a6c7-48b6-a872-5048c8f64566)
2. ❌ User lookup in app database returned `null` for phone number `9192939495`
3. ❌ No navigation logic for new users who authenticate but don't exist in app database

### Solution Implemented
Added `_handleNewUser()` method to completely delete orphaned Supabase users:
- **Completely deletes user from Supabase database** when they exist in Supabase but not in app database
- **Navigates back to auth page** to start completely fresh signup process
- **Prevents orphaned authentication states** where user is authenticated but has no app profile
- **Ensures fresh database entry** for users who need to be properly registered

### Code Changes
- Added `deleteUser()` method in AuthController interface and implementation
- Added `_handleNewUser()` method in AuthPageBloc that calls `auth.deleteUser()`
- Modified user lookup logic to handle null results by completely removing user from database
- Added navigation back to auth page for fresh signup process
- Added comprehensive error handling with fallback to signOut if delete fails

**Status:** ✅ Fixed - OTP verification now handles orphaned Supabase users properly

### Final Implementation Notes
- **Updated to use same RPC logic as profile delete account feature**
- Uses `supabase.rpc('delete_user_account', params: {'p_user_id': currentUser.id})`
- Same proven method used in settings screen for account deletion
- Fallback to `signOut()` if RPC fails
- User session is cleared and they're navigated back for fresh signup
- No more orphaned authentication states
- Clean signup flow enforced for users not in app database
- **Implementation matches existing codebase patterns**

---

## Privacy Purpose Strings Issue

**Date:** 30/05/2025  
**Guideline:** 5.1.1 - Legal - Privacy - Data Collection and Storage

### Problem Description

One or more purpose strings in the app do not sufficiently explain the use of protected resources. Purpose strings must clearly and completely describe the app's use of data and, in most cases, provide an example of how the data will be used.

**Apple's Feedback:** Update the location purpose string to explain how the app will use the requested information and provide a specific example of how the data will be used.

### Solution Implemented

Updated all location permission strings in `ios/Runner/Info.plist` to be more specific and detailed:

#### Updated Permission Strings:

1. **NSLocationWhenInUseUsageDescription:**
   - Added specific numbered examples: (1) Show nearby stores with offers, (2) Display location-specific content, (3) Find local agents, (4) Set country/region
   - Clarified data processing is local and never shared

2. **NSLocationAlwaysAndWhenInUseUsageDescription:**
   - Added background usage examples: (1) Nearby stores, (2) Location-based notifications, (3) Location-specific content, (4) Local agents, (5) Country/region settings
   - Explained both foreground and background usage

3. **NSLocationAlwaysUsageDescription:**
   - Added background-specific examples: (1) Location-based notifications, (2) Location-specific content, (3) Local agents, (4) Country/region updates
   - Clarified background usage scenarios

### Key Improvements

- ✅ **Specific numbered examples** instead of generic descriptions
- ✅ **Clear use cases** for each location permission type
- ✅ **Privacy assurance** - data processed locally, never shared
- ✅ **Detailed explanations** of how location enhances user experience

**Status:** ✅ Fixed - Location permission strings now meet Apple's specificity requirements

---

## App Tracking Transparency Issue

**Date:** 30/05/2025  
**Guideline:** 5.1.2 - Legal - Privacy - Data Use and Sharing

### Problem Description

The app privacy information provided in App Store Connect indicates the app collects data in order to track the user, including Email Address and Name. However, the app does not use App Tracking Transparency to request the user's permission before tracking their activity.

**Apple's Feedback:** Apps need to receive the user's permission through the AppTrackingTransparency framework before collecting data used to track them. This requirement protects the privacy of users.

### Solution Implemented

Added App Tracking Transparency (ATT) permission request to the splash screen to ensure Apple reviewers see it early in the app flow:

#### Implementation Details:

1. **Added ATT Request to Splash Screen:**
   - Modified `lib/app/platforms/mobile/splash/presentation/pages/splash.dart`
   - Added `_requestTrackingPermissionIfNeeded()` method
   - Triggers early in app lifecycle during splash screen

2. **Smart Permission Logic:**
   - Checks current tracking status first
   - Only shows dialog if status is `notDetermined`
   - Prevents duplicate permission requests

3. **Existing Infrastructure Used:**
   - Leveraged existing `TrackingService` class
   - Used existing `TrackingPermissionDialog` widget
   - iOS native implementation already in place in `AppDelegate.swift`

4. **Comprehensive Logging:**
   - Added tracking logs with 🔒 [TRACKING] prefix
   - Tracks permission status and user responses
   - Helps debug permission flow

#### Files Modified:

- `lib/app/platforms/mobile/splash/presentation/pages/splash.dart` - Added ATT request
- `ios/Runner/AppDelegate.swift` - Already had ATT implementation
- `ios/Runner/Info.plist` - Already had NSUserTrackingUsageDescription
- `lib/services/tracking_service.dart` - Already existed
- `lib/widgets/tracking_permission_dialog.dart` - Already existed

### Key Improvements

- ✅ **Early permission request** - Shows during splash screen
- ✅ **Apple compliance** - Uses AppTrackingTransparency framework
- ✅ **User-friendly dialog** - Custom explanation before system prompt
- ✅ **Smart logic** - Only shows when needed
- ✅ **Comprehensive logging** - Easy to debug and verify

**Status:** ✅ Fixed - App Tracking Transparency now properly implemented and visible to Apple reviewers

---

## Background Location Mode Issue

**Date:** 30/05/2025  
**Guideline:** 2.5.4 - Performance - Software Requirements

### Problem Description

The app declares support for location in the UIBackgroundModes key in your Info.plist file but we are unable to locate any features that require persistent location. Apps that declare support for location in the UIBackgroundModes key in your Info.plist file must have features that require persistent location.

**Apple's Feedback:** If the app does not require persistent real-time location updates, please remove the "location" setting from the UIBackgroundModes key.

### Solution Implemented

Removed background location mode from UIBackgroundModes since the app only uses location for personalized services when in use, not persistent background tracking:

#### Changes Made:

1. **Removed Background Location Mode:**
   - Removed `<string>location</string>` from UIBackgroundModes array
   - Updated comment to reflect location removal
   - Kept other background modes: fetch, processing, remote-notification

2. **Updated Location Permission Strings:**
   - Modified NSLocationAlwaysAndWhenInUseUsageDescription to remove background references
   - Updated NSLocationAlwaysUsageDescription to remove background-specific language
   - Kept NSLocationWhenInUseUsageDescription as-is (appropriate for foreground use)

3. **Clarified Location Usage:**
   - Location only used for personalized services when app is active
   - No persistent background location tracking
   - Location used for: nearby stores, content recommendations, local agents, country/region settings

#### Technical Details:

**Before:**
```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>processing</string>
    <string>remote-notification</string>
    <string>location</string>  <!-- REMOVED -->
</array>
```

**After:**
```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>processing</string>
    <string>remote-notification</string>
</array>
```

### Key Improvements

- ✅ **Compliance with Apple guidelines** - No background location mode without persistent features
- ✅ **Accurate permission descriptions** - Strings match actual app behavior
- ✅ **Clear location usage** - Only for personalized services when app is in use
- ✅ **Privacy focused** - No unnecessary background location access

**Status:** ✅ Fixed - Background location mode removed, app now complies with Apple's software requirements

---

## Apple Pay / PassKit Framework Issue

**Date:** 30/05/2025  
**Guideline:** 2.1 - Information Needed

### Problem Description

The app binary includes the PassKit framework for implementing Apple Pay, but we were unable to verify any integration of Apple Pay within the app.

**Apple's Feedback:** If the app integrates the functionality referenced above, indicate where in the app we can locate it. If the app does not include this functionality, indicate this information in the Review Notes section for each version of the app in App Store Connect when submitting for review.

### Solution Implemented

Removed Apple Pay integration while keeping Google Pay functionality:

#### Changes Made:

1. **Removed Apple Pay Configuration:**
   - Removed `defaultApplePay` configuration from `payment_config.dart`
   - Kept only Google Pay configuration

2. **Updated Payment Methods:**
   - Removed Apple Pay option from payment methods list
   - Kept Google Pay option for users who want it
   - Maintained `pay` package dependency for Google Pay functionality

3. **Cleaned Up Payment Logic:**
   - Removed Apple Pay handling from payment submission logic
   - Kept Google Pay implementation using only `PayProvider.google_pay`
   - Removed all Apple Pay references from Pay client configuration

#### Technical Details:

**Removed:**
- Apple Pay configuration string
- Apple Pay UI option
- Apple Pay payment processing logic
- `PayProvider.apple_pay` references

**Kept:**
- Google Pay functionality
- `pay` package dependency
- Google Pay configuration
- Google Pay payment processing

### Key Improvements

- ✅ **No Apple Pay/PassKit usage** - Completely removed Apple Pay integration
- ✅ **Google Pay preserved** - Users can still use Google Pay
- ✅ **Clean codebase** - No unused Apple Pay code
- ✅ **Apple compliance** - No PassKit framework usage without implementation

**Status:** ✅ Fixed - Apple Pay completely removed, Google Pay functionality preserved

---

## NFC Functionality Removal

**Date:** 30/05/2025  
**Guideline:** 2.1 - Information Needed

### Problem Description

Apple requested a demo video showing all NFC functionality in the app, including the app interacting with NFC tags. However, since NFC functionality is not essential for the core app features, it was decided to remove it completely.

**Apple's Request:** We need a video that demonstrates the current version, 1.0.0, in use on a physical iOS device. Specifically, we need a demo video that shows all the NFC functionality in the app, including the app interacting with NFC tags.

### Solution Implemented

Completely removed all NFC functionality from the app:

#### Changes Made:

1. **Removed NFC Dependencies:**
   - Removed `nfc_manager` package from `pubspec.yaml`
   - Removed NFCReaderUsageDescription from `ios/Runner/Info.plist`

2. **Removed NFC Code:**
   - Deleted `lib/app/shared/core/utils/nfc_utils.dart` file completely
   - Removed `NfcOperation` enum from `enums.dart`
   - Removed all NFC imports and references

3. **Updated UI Components:**
   - Removed NFC sharing option from share bottom sheet
   - Updated sharing options to only include "Hushh Chat" and "Other"
   - Removed NFC-related UI elements and interactions

4. **Cleaned Up Code:**
   - Removed NFC initialization from splash screen
   - Removed all NFC utility function calls
   - Updated switch statements to handle reduced sharing options

#### Technical Details:

**Files Removed:**
- `lib/app/shared/core/utils/nfc_utils.dart`

**Files Modified:**
- `pubspec.yaml` - Removed nfc_manager dependency
- `ios/Runner/Info.plist` - Removed NFCReaderUsageDescription
- `lib/app/shared/config/constants/enums.dart` - Removed NfcOperation enum
- `lib/app/platforms/mobile/splash/presentation/pages/splash.dart` - Removed NFC initialization
- `lib/app/platforms/mobile/card_wallet/presentation/components/share_earn_bottom_sheet.dart` - Removed NFC sharing option

### Key Improvements

- ✅ **No NFC dependencies** - Completely removed nfc_manager package
- ✅ **No NFC permissions** - Removed NFCReaderUsageDescription
- ✅ **Clean codebase** - No unused NFC code or references
- ✅ **Simplified sharing** - Streamlined sharing options without NFC
- ✅ **Apple compliance** - No NFC functionality to demonstrate

**Status:** ✅ Fixed - NFC functionality completely removed from the app


<!-- Date Submitted
May 27, 2025 at 12:04 PM
Submission ID
dac80f41-8edf-4c7b-b7d7-406297c9eaf2
Submitted By
Manish Sainani
Last Updated By
Apple -->
