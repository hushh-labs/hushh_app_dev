# Changelog

## [Unreleased]

### Added
- Added instructions in README.md for running the Flutter app with environment and flavor, including device-specific commands.

### Fixed
- Added null checks for `cardData.id` and `cardData.brandId` in `UserCardWalletInfoScreen` (`lib/app/platforms/mobile/card_wallet/presentation/pages/card_wallet_info/user_card_wallet_info_screen.dart`) to prevent runtime errors caused by null check operator on null values.

### Committed but Ignored
- User-specific Xcode workspace state files were not committed as they are not relevant to source control.

---

**Recent commit messages:**
- Update README with run instructions for environment and flavor
- Fix: Add null checks for cardData fields in UserCardWalletInfoScreen to prevent runtime errors 