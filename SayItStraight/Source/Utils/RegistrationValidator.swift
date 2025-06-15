//
//  RegistrationValidator.swift
//  SayItStraight
//
//  Created by Zack Boutchyard on 6/8/25.
//

import Foundation

struct RegistrationValidator {
    static func validate(username: String, password: String, confirmPassword: String) -> [String] {
        var errors: [String] = []

        // Username must not be empty
        if username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("Username cannot be empty.")
        }

        // Username must be at least 3 characters
        if username.count < 3 {
            errors.append("Username must be at least 3 characters long.")
        }

        // Password must not be empty
        if password.isEmpty {
            errors.append("Password cannot be empty.")
        }

        // Password length
        if password.count < 8 {
            errors.append("Password must be at least 8 characters long.")
        }

        // Password complexity checks
        let hasUppercase: Bool = password.range(of: "[A-Z]", options: .regularExpression) != nil
        let hasNumber: Bool = password.range(of: "[0-9]", options: .regularExpression) != nil
        let hasSpecialChar: Bool = password.range(of: "[^A-Za-z0-9]", options: .regularExpression) != nil

        if !hasUppercase {
            errors.append("Password must contain at least one uppercase letter.")
        }
        if !hasNumber {
            errors.append("Password must contain at least one number.")
        }
        if !hasSpecialChar {
            errors.append("Password must contain at least one special character.")
        }

        // Confirm password match
        if password != confirmPassword {
            errors.append("Passwords do not match.")
        }

        return errors
    }
}
