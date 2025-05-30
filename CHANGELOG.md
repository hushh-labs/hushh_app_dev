# Changelog

## [Unreleased]

### Added
- Added instructions in README.md for running the Flutter app with environment and flavor, including device-specific commands.
- **Database Schema Enhancement**: Added timestamp tracking fields to users table:
  - `dob_updated_at`: Tracks when user updates Date of Birth
  - `education_updated_at`: Tracks when user updates Education information
  - `income_updated_at`: Tracks when user updates Income information
- Created `schema.md` file for database schema documentation

### Fixed
- Added null checks for `cardData.id` and `cardData.brandId` in `UserCardWalletInfoScreen` (`lib/app/platforms/mobile/card_wallet/presentation/pages/card_wallet_info/user_card_wallet_info_screen.dart`) to prevent runtime errors caused by null check operator on null values.
- **iOS App Crash Issue**: Resolved critical iOS app freezing/crashing issue related to geofencing service
  - Fixed `geofence_foreground_service` plugin causing crashes due to improper background location authorization
  - Added platform-specific conditional logic to safely disable geofencing on iOS while preserving Android functionality
  - Added proper error handling and logging for geofencing operations
  - Enhanced iOS Info.plist with proper background location permissions
  - App now runs smoothly on iOS without compromising core functionality

### Committed but Ignored
- User-specific Xcode workspace state files were not committed as they are not relevant to source control.

---

**Recent commit messages:**
- Update README with run instructions for environment and flavor
- Fix: Add null checks for cardData fields in UserCardWalletInfoScreen to prevent runtime errors
