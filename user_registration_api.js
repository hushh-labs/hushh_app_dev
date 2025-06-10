// User Registration API - Step 1: Basic User Creation
class UserRegistrationAPI {
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
     * Generate unique Hushh ID
     * @returns {string} Generated hushh_id
     */
    generateHushhId() {
        return 'hushh_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
    }

    /**
     * Validate basic user data
     * @param {Object} userData - User data to validate
     * @returns {Object} Validation result
     */
    validateBasicUserData(userData) {
        const errors = [];

        if (!userData.first_name || userData.first_name.trim().length < 2) {
            errors.push('First name must be at least 2 characters long');
        }

        if (!userData.email || !this.isValidEmail(userData.email)) {
            errors.push('Valid email is required');
        }

        return {
            isValid: errors.length === 0,
            errors: errors
        };
    }

    /**
     * Check if email is valid
     * @param {string} email - Email to validate
     * @returns {boolean} Is email valid
     */
    isValidEmail(email) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }

    /**
     * Prepare basic user data for registration
     * @param {Object} formData - Form data from frontend
     * @returns {Object} Prepared user data
     */
    prepareBasicUserData(formData) {
        const currentDateTime = new Date().toISOString();
        
        return {
            // Core identification
            hushh_id: this.generateHushhId(),
            
            // Basic personal information
            first_name: formData.first_name?.trim() || null,
            last_name: formData.last_name?.trim() || null,
            email: formData.email?.trim().toLowerCase() || '',
            
            // Platform usage flags (matching Flutter model)
            is_hushh_app_user: true,
            is_hushh_button_user: false,
            is_browser_companion_user: false,
            is_hushh_vibe_user: false,
            
            // Settings and status
            private_mode: false,
            onboard_status: 'registered', // Initial status
            role: 'user',
            
            // Timestamps
            creationtime: currentDateTime,
            
            // GPT and token management (default values)
            gpt_token_usage: 500000, // DEFAULT_GPT_TOKEN_PER_MONTH
            last_used_token_date_time: currentDateTime,
            
            // Default values
            user_coins: 0,
            conversations: [],
            demographic_card_questions: [],
            hushh_id_card_questions: [],
            
            // Null fields that will be filled in profile completion
            phone_number: null,
            country_code: null,
            gender: null,
            dob: null,
            selected_reason_for_using_hushh: null,
            avatar: null,
            fcm_token: null,
            profile_video: null,
            dob_updated_at: null
        };
    }

    /**
     * Register a new user (Step 1)
     * @param {Object} formData - User registration data
     * @returns {Promise<Object>} Registration result
     */
    async registerUser(formData) {
        try {
            // Validate input data
            const validation = this.validateBasicUserData(formData);
            if (!validation.isValid) {
                return {
                    success: false,
                    error: validation.errors.join(', '),
                    code: 'VALIDATION_ERROR'
                };
            }

            // Check if email already exists
            const emailCheck = await this.checkEmailExists(formData.email);
            if (emailCheck.exists) {
                return {
                    success: false,
                    error: 'Email already exists. Please use a different email.',
                    code: 'EMAIL_EXISTS'
                };
            }

            // Prepare user data
            const userData = this.prepareBasicUserData(formData);

            // Create user in database
            const response = await fetch(`${this.apiUrl}/users`, {
                method: 'POST',
                headers: this.headers,
                body: JSON.stringify(userData)
            });

            if (!response.ok) {
                const errorData = await response.json();
                throw new Error(errorData.message || `HTTP error! status: ${response.status}`);
            }

            const newUser = await response.json();
            const createdUser = Array.isArray(newUser) ? newUser[0] : newUser;

            return {
                success: true,
                data: {
                    user: createdUser,
                    hushh_id: createdUser.hushh_id,
                    status: 'registered',
                    next_step: 'profile_completion'
                },
                message: 'User registered successfully! Profile completion is pending.',
                code: 'USER_REGISTERED'
            };

        } catch (error) {
            console.error('Registration error:', error);
            return {
                success: false,
                error: error.message || 'Failed to register user',
                code: 'REGISTRATION_ERROR'
            };
        }
    }

    /**
     * Check if email already exists
     * @param {string} email - Email to check
     * @returns {Promise<Object>} Check result
     */
    async checkEmailExists(email) {
        try {
            const response = await fetch(
                `${this.apiUrl}/users?email=eq.${encodeURIComponent(email.toLowerCase())}&select=hushh_id,email`,
                {
                    method: 'GET',
                    headers: this.headers
                }
            );

            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            const users = await response.json();
            return {
                exists: users.length > 0,
                user: users.length > 0 ? users[0] : null
            };

        } catch (error) {
            console.error('Email check error:', error);
            return { exists: false, user: null };
        }
    }

    /**
     * Get user by hushh_id
     * @param {string} hushhId - User's hushh_id
     * @returns {Promise<Object>} User data
     */
    async getUserById(hushhId) {
        try {
            const response = await fetch(
                `${this.apiUrl}/users?hushh_id=eq.${encodeURIComponent(hushhId)}&select=*`,
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

            return {
                success: true,
                data: users[0],
                code: 'USER_FOUND'
            };

        } catch (error) {
            console.error('Get user error:', error);
            return {
                success: false,
                error: error.message || 'Failed to fetch user',
                code: 'FETCH_ERROR'
            };
        }
    }

    /**
     * Get all registered users (basic info only)
     * @param {Object} filters - Optional filters
     * @returns {Promise<Object>} Users list
     */
    async getRegisteredUsers(filters = {}) {
        try {
            let url = `${this.apiUrl}/users?onboard_status=eq.registered&select=hushh_id,first_name,last_name,email,creationtime,onboard_status`;
            
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
                code: 'USERS_FETCHED'
            };

        } catch (error) {
            console.error('Get registered users error:', error);
            return {
                success: false,
                error: error.message || 'Failed to fetch registered users',
                code: 'FETCH_ERROR'
            };
        }
    }
}

// Export for use in other files
if (typeof module !== 'undefined' && module.exports) {
    module.exports = UserRegistrationAPI;
}

// Global instance for browser usage
if (typeof window !== 'undefined') {
    window.UserRegistrationAPI = UserRegistrationAPI;
}
