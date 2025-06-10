# Hushh User Management API Documentation

## Overview

The Hushh User Management system uses a **two-step user creation process** with separate APIs for each step:

1. **User Registration API** - Step 1: Basic user creation
2. **User Profile API** - Step 2: Profile completion

## 🔗 Base Configuration

```javascript
Base URL: https://rpmzykoxqnbozgdoqbpc.supabase.co/rest/v1
API Key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJwbXp5a294cW5ib3pnZG9xYnBjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDE5Mjc5NzEsImV4cCI6MjAxNzUwMzk3MX0.3GwG8YQKwZSWfGgTBEEA47YZAZ-Nr4HiirYPWiZtpZ0

Required Headers:
- apikey: [API_KEY]
- Authorization: Bearer [API_KEY]
- Content-Type: application/json
```

---

## 📋 API 1: User Registration API

**File:** `user_registration_api.js`  
**Purpose:** Handle basic user registration (Step 1)

### Class: `UserRegistrationAPI`

#### Methods:

### 1. `registerUser(formData)`
**Purpose:** Register a new user with basic information

**Parameters:**
```javascript
{
  first_name: "John",        // Required, min 2 characters
  last_name: "Doe",          // Optional
  email: "john@example.com"  // Required, valid email
}
```

**Response:**
```javascript
// Success
{
  success: true,
  data: {
    user: { /* user object */ },
    hushh_id: "hushh_1736164800000_abc123",
    status: "registered",
    next_step: "profile_completion"
  },
  message: "User registered successfully! Profile completion is pending.",
  code: "USER_REGISTERED"
}

// Error
{
  success: false,
  error: "Email already exists. Please use a different email.",
  code: "EMAIL_EXISTS"
}
```

### 2. `checkEmailExists(email)`
**Purpose:** Check if email is already registered

**Parameters:**
```javascript
email: "john@example.com"
```

**Response:**
```javascript
{
  exists: true/false,
  user: { /* user object if exists */ }
}
```

### 3. `getUserById(hushhId)`
**Purpose:** Get user by their hushh_id

**Parameters:**
```javascript
hushhId: "hushh_1736164800000_abc123"
```

### 4. `getRegisteredUsers(filters)`
**Purpose:** Get all users with "registered" status

**Parameters:**
```javascript
{
  search: "john",    // Optional
  limit: 50          // Optional
}
```

---

## 📋 API 2: User Profile API

**File:** `user_profile_api.js`  
**Purpose:** Handle profile completion and updates (Step 2)

### Class: `UserProfileAPI`

#### Methods:

### 1. `completeProfile(hushhId, formData)`
**Purpose:** Complete user profile (Step 2)

**Parameters:**
```javascript
hushhId: "hushh_1736164800000_abc123"

formData: {
  phone_number: "+1234567890",                    // Optional
  country_code: "+1",                             // Optional
  gender: "male",                                 // Optional: male/female/other
  dob: "1990-01-15",                             // Optional: YYYY-MM-DD
  selected_reason_for_using_hushh: "Personal",   // Optional
  user_coins: 100,                               // Optional, default 100
  is_hushh_button_user: false,                   // Optional
  is_browser_companion_user: false,              // Optional
  is_hushh_vibe_user: false                      // Optional
}
```

**Response:**
```javascript
// Success
{
  success: true,
  data: {
    user: { /* updated user object */ },
    hushh_id: "hushh_1736164800000_abc123",
    status: "authenticated",
    completed_fields: ["phone_number", "gender", "dob"],
    profile_completion_date: "2024-01-15T10:30:00Z"
  },
  message: "Profile completed successfully! User is now fully authenticated.",
  warnings: ["Phone number not provided"],
  code: "PROFILE_COMPLETED"
}
```

### 2. `updateProfileFields(hushhId, updateData)`
**Purpose:** Update specific profile fields without changing status

### 3. `checkUserForProfileCompletion(hushhId)`
**Purpose:** Check if user is eligible for profile completion

**Response:**
```javascript
{
  success: true,
  data: { /* user object */ },
  code: "USER_READY_FOR_PROFILE_COMPLETION"
}
```

### 4. `getAuthenticatedUsers(filters)`
**Purpose:** Get all users with "authenticated" status

### 5. `getProfileStats()`
**Purpose:** Get profile completion statistics

**Response:**
```javascript
{
  success: true,
  data: {
    total_users: 150,
    registered_users: 30,
    authenticated_users: 120,
    users_with_phone: 100,
    users_with_dob: 80,
    users_with_gender: 90,
    total_coins: 15000,
    completion_rate: "80.00"
  }
}
```

---

## 🔄 Two-Step User Flow

### Step 1: User Registration
```javascript
// Initialize Registration API
const registrationAPI = new UserRegistrationAPI();

// Register user
const result = await registrationAPI.registerUser({
  first_name: "John",
  last_name: "Doe",
  email: "john@example.com"
});

if (result.success) {
  console.log("User registered:", result.data.hushh_id);
  // Proceed to Step 2
}
```

### Step 2: Profile Completion
```javascript
// Initialize Profile API
const profileAPI = new UserProfileAPI();

// Complete profile
const result = await profileAPI.completeProfile(hushhId, {
  phone_number: "+1234567890",
  gender: "male",
  dob: "1990-01-15",
  user_coins: 100
});

if (result.success) {
  console.log("Profile completed:", result.data.status);
}
```

---

## 📊 User Status Flow

```
┌─────────────┐    Step 1     ┌─────────────┐    Step 2     ┌─────────────┐
│   No User   │ ──────────→   │ registered  │ ──────────→   │authenticated│
└─────────────┘  Registration └─────────────┘  Profile      └─────────────┘
                     API           Status       Completion
                                                   API
```

### Status Meanings:
- **`registered`**: Basic user created, profile incomplete
- **`authenticated`**: Profile completed, fully onboarded user

---

## ⚠️ Error Codes

### Registration API Errors:
- `VALIDATION_ERROR`: Invalid input data
- `EMAIL_EXISTS`: Email already registered
- `REGISTRATION_ERROR`: Database/network error
- `USER_NOT_FOUND`: User doesn't exist
- `FETCH_ERROR`: Failed to retrieve data

### Profile API Errors:
- `VALIDATION_ERROR`: Invalid profile data
- `USER_NOT_FOUND`: User doesn't exist
- `PROFILE_ALREADY_COMPLETED`: User already authenticated
- `INVALID_STATUS`: User not in registered status
- `PROFILE_COMPLETION_ERROR`: Failed to complete profile
- `PROFILE_UPDATE_ERROR`: Failed to update profile

---

## 🔧 Usage Examples

### Complete Registration Flow:
```javascript
// Step 1: Register user
const registrationAPI = new UserRegistrationAPI();
const regResult = await registrationAPI.registerUser({
  first_name: "John",
  last_name: "Doe",
  email: "john@example.com"
});

if (regResult.success) {
  const hushhId = regResult.data.hushh_id;
  
  // Step 2: Complete profile
  const profileAPI = new UserProfileAPI();
  const profileResult = await profileAPI.completeProfile(hushhId, {
    phone_number: "+1234567890",
    gender: "male",
    dob: "1990-01-15",
    user_coins: 100
  });
  
  if (profileResult.success) {
    console.log("User fully onboarded!");
  }
}
```

### Get Statistics:
```javascript
const profileAPI = new UserProfileAPI();
const stats = await profileAPI.getProfileStats();
console.log(`Completion rate: ${stats.data.completion_rate}%`);
```

### Search Users:
```javascript
// Get registered users
const registrationAPI = new UserRegistrationAPI();
const registered = await registrationAPI.getRegisteredUsers({
  search: "john",
  limit: 10
});

// Get authenticated users
const profileAPI = new UserProfileAPI();
const authenticated = await profileAPI.getAuthenticatedUsers({
  search: "john",
  limit: 10
});
```

---

## 🎯 Key Features

### Registration API Features:
✅ **Email Validation** - Prevents duplicate emails  
✅ **Auto hushh_id Generation** - Unique ID creation  
✅ **Input Validation** - Name and email validation  
✅ **Status Tracking** - Sets initial "registered" status  
✅ **Flutter Compatible** - Matches Flutter model fields  

### Profile API Features:
✅ **Advanced Validation** - Phone, age, gender validation  
✅ **Status Management** - Updates to "authenticated"  
✅ **Flexible Updates** - Update specific fields only  
✅ **Statistics** - Completion rate tracking  
✅ **Age Verification** - Minimum 13 years old  

---

## 📱 Integration with Dashboard

Both APIs are integrated into the dashboard:

1. **Quick Add User** button uses `UserRegistrationAPI.registerUser()`
2. **Complete Profile** button uses `UserProfileAPI.completeProfile()`
3. **Statistics** use both APIs for comprehensive data
4. **User Cards** show status-based actions

The dashboard automatically switches between APIs based on user status, providing a seamless two-step user creation experience.
