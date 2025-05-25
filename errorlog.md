# App Store Review Issues Log

## Submission Details
- **Submission ID**: dac80f41-8edf-4c7b-b7d7-406297c9eaf2
- **Review Date**: March 20, 2025
- **Version**: 1.0.0
- **Device Tested**: iPhone 13 mini
- **OS Version**: iOS 18.3.2

## 1. Guideline 2.1 - Performance - App Completeness

### Critical Bugs Found
1. **Phone Registration Issue**
   - Bug: App loads indefinitely after tapping Next post phone number entry
   - Steps to reproduce:
     1. Enter phone number
     2. Tap Next
     3. App enters infinite loading state

2. **Phone Login Issue**
   - Bug: App loads indefinitely after tapping "Continue with Phone"
   - Steps to reproduce:
     1. Select phone login option
     2. Tap "Continue with Phone"
     3. App enters infinite loading state

### Required Actions
- Test app on supported devices to identify and resolve bugs
- For new apps: Uninstall all previous versions before testing
- For updates: Install new version as update to previous version
- Test networking functionality thoroughly

## 2. Guideline 2.1 - Information Needed

### Location Features Information Required
1. **Background Location Usage**
   - Required Information:
     - Features requiring background location
     - Frequency of location collection
     - Available features using location
     - Behavior when location permission denied
     - Location visibility in app
     - Location history tracking
     - Distance tracking functionality

### Core NFC Information Required
1. **NFC Feature Details**
   - Required Information:
     - Features using Core NFC
     - Steps to access NFC features
     - If using specific NFC tags:
       - Provide demo video showing NFC interaction
       - Video must be uploaded to App Store Connect

## 3. Guideline 5.1.1 - Privacy - Data Collection and Storage

### Purpose String Issues
- Current purpose strings insufficiently explain protected resource usage
- Required Actions:
  - Update location purpose string
  - Provide clear explanation of data usage
  - Include specific examples of data utilization

### Example of Unacceptable Purpose Strings
- "App would like to access your Contacts"
- "App needs microphone access"

## 4. Guideline 5.1.2 - Privacy - Data Use and Sharing

### App Tracking Transparency Issue
- App collects tracking data (Email Address and Name) without proper permission
- Missing AppTrackingTransparency framework implementation

### Required Actions
Choose one of the following solutions:
1. **If app doesn't track:**
   - Update app privacy information in App Store Connect
   - Requires Account Holder or Admin role

2. **If app tracks on other platforms only:**
   - Notify App Review via App Store Connect reply

3. **If app tracks on all platforms:**
   - Implement AppTrackingTransparency framework
   - Request permission before data collection
   - Document permission request location in Review Notes

### Additional Notes
- Document regional variations in app behavior
- Include documentation in Review Notes
- Ensure privacy policy reflects actual data collection practices

## Resources
- [Testing a Release Build](https://developer.apple.com/documentation/xcode/testing-a-release-build)
- [Networking Overview](https://developer.apple.com/documentation/foundation/url_loading_system)
- [App Tracking Transparency](https://developer.apple.com/documentation/apptrackingtransparency)
- [Privacy Guidelines](https://developer.apple.com/app-store/user-privacy-and-data-use/)

## Next Steps
1. Address all critical bugs
2. Provide required location and NFC information
3. Update privacy purpose strings
4. Implement proper tracking transparency
5. Update App Store Connect information
6. Resubmit for review with detailed notes 