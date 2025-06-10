// User Profile API - Step 2: Profile Completion
class UserProfileAPI {
    constructor() {
        this.supabaseUrl = 'https://rpmzykoxqnbozgdoqbpc.supabase.co';
        this.supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJwbXp5a294cW5ib3pnZG9xYnBjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDE5Mjc5NzEsImV4cCI6MjAxNzUwMzk3MX0.3GwG8YQKwZSWfGgTBEEA47YZAZ-Nr4HiirYPWiZtpZ0';
        this.apiUrl = `${this.supabaseUrl}/rest/v1`;
        this.headers = {
            'apikey': this.supabaseKey,
            'Authorization': `Bearer ${this.supabaseKey}`,
            'Content-Type': 'application/json',
            'Prefer': 'return=representation'
        };
    }

    /**
     * Validate profile data
     * @param {Object} profileData - Profile data to validate
     * @returns {Object} Validation result
     */
    validateProfileData(profileData) {
        const errors = [];
        const warnings = [];

        // Phone number validation
        if (profileData.phone_number && !this.isValidPhoneNumber(profileData.phone_number)) {
            errors.push('Invalid phone number format');
        }

        // Country code validation
        if (profileData.country_code && !this.isValidCountryCode(profileData.country_code)) {
            errors.push('Invalid country code format (should start with +)');
        }

        // Date of birth validation
        if (profileData.dob && !this.isValidDate(profileData.dob)) {
            errors.push('Invalid date of birth format');
        }

        // Age validation (must be at least 13 years old)
        if (profileData.dob && !this.isValidAge(profileData.dob)) {
            errors.push('User must be at least 13 years old');
        }

        // Gender validation
        if (profileData.gender && !['male', 'female', 'other'].includes(profileData.gender.toLowerCase())) {
            errors.push('Gender must be male, female, or other');
        }

        // User coins validation
        if (profileData.user_coins !== undefined && (isNaN(profileData.user_coins) || profileData.user_coins < 0)) {
            errors.push('User coins must be a non-negative number');
        }

        // Warnings for optional but recommended fields
        if (!profileData.phone_number) {
            warnings.push('Phone number not provided');
        }

        if (!profileData.gender) {
            warnings.push('Gender not specified');
        }

        return {
            isValid: errors.length === 0,
            errors: errors,
            warnings: warnings
        };
    }

    /**
     * Check if phone number is valid
     * @param {string} phoneNumber - Phone number to validate
     * @returns {boolean} Is phone number valid
     */
    isValidPhoneNumber(phoneNumber) {
        // Basic phone number validation (can be enhanced)
        const phoneRegex = /^\+?[\d\s\-\(\)]{7,15}$/;
        return phoneRegex.test(phoneNumber);
    }

    /**
     * Check if country code is valid
     * @param {string} countryCode - Country code to validate
     * @returns {boolean} Is country code valid
     */
    isValidCountryCode(countryCode) {
        const countryCodeRegex = /^\+\d{1,4}$/;
        return countryCodeRegex.test(countryCode);
    }

    /**
     * Check if date is valid
     * @param {string} dateString - Date string to validate
     * @returns {boolean} Is date valid
     */
    isValidDate(dateString) {
        const date = new Date(dateString);
        return date instanceof Date && !isNaN(date);
    }

    /**
     * Check if age is valid (at least 13 years old)
     * @param {string} dobString - Date of birth string
     * @returns {boolean} Is age valid
     */
    isValidAge(dobString) {
        const dob = new Date(dobString);
        const today = new Date();
        const age = today.getFullYear() - dob.getFullYear();
        const monthDiff = today.getMonth() - dob.getMonth();
        
        if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < dob.getDate())) {
            return age - 1 >= 13;
        }
        
        return age >= 13;
    }

    /**
     * Prepare profile data for update
     * @param {Object} formData - Form data from frontend
     * @returns {Object} Prepared profile data
     */
    prepareProfileData(formData) {
        const profileData = {};

        // Only include fields that are provided and not empty
        if (formData.phone_number && formData.phone_number.trim()) {
            profileData.phone_number = formData.phone_number.trim();
        }

        if (formData.country_code && formData.country_code.trim()) {
            profileData.country_code = formData.country_code.trim();
        }

        if (formData.gender && formData.gender.trim()) {
            profileData.gender = formData.gender.toLowerCase().trim();
        }

        if (formData.dob && formData.dob.trim()) {
            profileData.dob = formData.dob.trim();
            profileData.dob_updated_at = new Date().toISOString();
        }

        if (formData.selected_reason_for_using_hushh && formData.selected_reason_for_using_hushh.trim()) {
            profileData.selected_reason_for_using_hushh = formData.selected_reason_for_using_hushh.trim();
        }

        // User coins (default to 100 if not provided)
        if (formData.user_coins !== undefined && formData.user_coins !== '') {
            profileData.user_coins = parseInt(formData.user_coins) || 100;
        } else {
            profileData.user_coins = 100;
        }

        // Platform usage flags (can be updated during profile completion)
        if (formData.is_hushh_button_user !== undefined) {
            profileData.is_hushh_button_user = Boolean(formData.is_hushh_button_user);
        }

        if (formData.is_browser_companion_user !== undefined) {
            profileData.is_browser_companion_user = Boolean(formData.is_browser_companion_user);
        }

        if (formData.is_hushh_vibe_user !== undefined) {
            profileData.is_hushh_vibe_user = Boolean(formData.is_hushh_vibe_user);
        }

        // Update onboard status to authenticated
        profileData.onboard_status = 'authenticated';

        return profileData;
    }

    /**
     * Check if user exists and is in registered status
     * @param {string} hushhId - User's hushh_id
     * @returns {Promise<Object>} User check result
     */
    async checkUserForProfileCompletion(hushhId) {
        try {
            const response = await fetch(
                `${this.apiUrl}/users?hushh_id=eq.${encodeURIComponent(hushhId)}&select=hushh_id,first_name,last_name,email,onboard_status,creationtime`,
                {
                    method: 'GET',
                    headers: this.headers
                }
            );

            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            const users = await response.json();
            
            if (users.length === 0) {
                return {
                    success: false,
                    error: 'User not found',
                    code: 'USER_NOT_FOUND'
                };
            }

            const user = users[0];

            if (user.onboard_status === 'authenticated') {
                return {
                    success: false,
                    error: 'User profile is already completed',
                    code: 'PROFILE_ALREADY_COMPLETED',
                    data: user
                };
            }

            if (user.onboard_status !== 'registered') {
                return {
                    success: false,
                    error: 'User is not in registered status',
                    code: 'INVALID_STATUS',
                    data: user
                };
            }

            return {
                success: true,
                data: user,
                code: 'USER_READY_FOR_PROFILE_COMPLETION'
            };

        } catch (error) {
            console.error('User check error:', error);
            return {
                success: false,
                error: error.message || 'Failed to check user status',
                code: 'CHECK_ERROR'
            };
        }
    }

    /**
     * Complete user profile (Step 2)
     * @param {string} hushhId - User's hushh_id
     * @param {Object} formData - Profile completion data
     * @returns {Promise<Object>} Profile completion result
     */
    async completeProfile(hushhId, formData) {
        try {
            // Check if user exists and is eligible for profile completion
            const userCheck = await this.checkUserForProfileCompletion(hushhId);
            if (!userCheck.success) {
                return userCheck;
            }

            // Validate profile data
            const validation = this.validateProfileData(formData);
            if (!validation.isValid) {
                return {
                    success: false,
                    error: validation.errors.join(', '),
                    warnings: validation.warnings,
                    code: 'VALIDATION_ERROR'
                };
            }

            // Prepare profile data
            const profileData = this.prepareProfileData(formData);

            // Update user profile in database
            const response = await fetch(
                `${this.apiUrl}/users?hushh_id=eq.${encodeURIComponent(hushhId)}`,
                {
                    method: 'PATCH',
                    headers: this.headers,
                    body: JSON.stringify(profileData)
                }
            );

            if (!response.ok) {
                const errorData = await response.json();
                throw new Error(errorData.message || `HTTP error! status: ${response.status}`);
            }

            const updatedUser = await response.json();
            const completedUser = Array.isArray(updatedUser) ? updatedUser[0] : updatedUser;

            return {
                success: true,
                data: {
                    user: completedUser,
                    hushh_id: hushhId,
                    status: 'authenticated',
                    completed_fields: Object.keys(profileData),
                    profile_completion_date: new Date().toISOString()
                },
                message: 'Profile completed successfully! User is now fully authenticated.',
                warnings: validation.warnings,
                code: 'PROFILE_COMPLETED'
            };

        } catch (error) {
            console.error('Profile completion error:', error);
            return {
                success: false,
                error: error.message || 'Failed to complete profile',
                code: 'PROFILE_COMPLETION_ERROR'
            };
        }
    }

    /**
     * Update specific profile fields
     * @param {string} hushhId - User's hushh_id
     * @param {Object} updateData - Fields to update
     * @returns {Promise<Object>} Update result
     */
    async updateProfileFields(hushhId, updateData) {
        try {
            // Validate update data
            const validation = this.validateProfileData(updateData);
            if (!validation.isValid) {
                return {
                    success: false,
                    error: validation.errors.join(', '),
                    warnings: validation.warnings,
                    code: 'VALIDATION_ERROR'
                };
            }

            // Prepare update data (don't change onboard_status)
            const profileData = this.prepareProfileData(updateData);
            delete profileData.onboard_status; // Don't change status during field updates

            // Update user profile in database
            const response = await fetch(
                `${this.apiUrl}/users?hushh_id=eq.${encodeURIComponent(hushhId)}`,
                {
                    method: 'PATCH',
                    headers: this.headers,
                    body: JSON.stringify(profileData)
                }
            );

            if (!response.ok) {
                const errorData = await response.json();
                throw new Error(errorData.message || `HTTP error! status: ${response.status}`);
            }

            const updatedUser = await response.json();
            const user = Array.isArray(updatedUser) ? updatedUser[0] : updatedUser;

            return {
                success: true,
                data: {
                    user: user,
                    hushh_id: hushhId,
                    updated_fields: Object.keys(profileData),
                    update_date: new Date().toISOString()
                },
                message: 'Profile fields updated successfully!',
                warnings: validation.warnings,
                code: 'PROFILE_UPDATED'
            };

        } catch (error) {
            console.error('Profile update error:', error);
            return {
                success: false,
                error: error.message || 'Failed to update profile',
                code: 'PROFILE_UPDATE_ERROR'
            };
        }
    }

    /**
     * Get all authenticated users (completed profiles)
     * @param {Object} filters - Optional filters
     * @returns {Promise<Object>} Users list
     */
    async getAuthenticatedUsers(filters = {}) {
        try {
            let url = `${this.apiUrl}/users?onboard_status=eq.authenticated&select=*`;
            
            if (filters.search) {
                const searchTerm = encodeURIComponent(filters.search);
                url += `&or=(first_name.ilike.*${searchTerm}*,last_name.ilike.*${searchTerm}*,email.ilike.*${searchTerm}*)`;
            }

            url += '&order=creationtime.desc';

            if (filters.limit) {
                url += `&limit=${filters.limit}`;
            }

            const response = await fetch(url, {
                method: 'GET',
                headers: this.headers
            });

            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            const users = await response.json();
            
            return {
                success: true,
                data: users,
                count: users.length,
                code: 'AUTHENTICATED_USERS_FETCHED'
            };

        } catch (error) {
            console.error('Get authenticated users error:', error);
            return {
                success: false,
                error: error.message || 'Failed to fetch authenticated users',
                code: 'FETCH_ERROR'
            };
        }
    }

    /**
     * Get profile completion statistics
     * @returns {Promise<Object>} Statistics
     */
    async getProfileStats() {
        try {
            const response = await fetch(
                `${this.apiUrl}/users?select=onboard_status,user_coins,gender,phone_number,dob`,
                {
                    method: 'GET',
                    headers: this.headers
                }
            );

            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            const users = await response.json();
            
            const stats = {
                total_users: users.length,
                registered_users: users.filter(u => u.onboard_status === 'registered').length,
                authenticated_users: users.filter(u => u.onboard_status === 'authenticated').length,
                users_with_phone: users.filter(u => u.phone_number).length,
                users_with_dob: users.filter(u => u.dob).length,
                users_with_gender: users.filter(u => u.gender).length,
                total_coins: users.reduce((sum, u) => sum + (u.user_coins || 0), 0),
                completion_rate: users.length > 0 ? 
                    (users.filter(u => u.onboard_status === 'authenticated').length / users.length * 100).toFixed(2) : 0
            };

            return {
                success: true,
                data: stats,
                code: 'STATS_FETCHED'
            };

        } catch (error) {
            console.error('Get profile stats error:', error);
            return {
                success: false,
                error: error.message || 'Failed to fetch profile statistics',
                code: 'STATS_ERROR'
            };
        }
    }
}

// Export for use in other files
if (typeof module !== 'undefined' && module.exports) {
    module.exports = UserProfileAPI;
}

// Global instance for browser usage
if (typeof window !== 'undefined') {
    window.UserProfileAPI = UserProfileAPI;
}
