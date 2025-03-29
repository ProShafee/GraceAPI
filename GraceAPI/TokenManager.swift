//
//  TokenManager.swift
//  GraceAPI
//
//  Created by Shafee Rehman on 29/03/2025.
//

import Foundation

public class TokenManager {
    
    // Singleton pattern
    public static let shared = TokenManager()
    
    private init() {}
    
    private let tokenKey = "authToken"
    
    // Save token (replaces existing token if necessary)
    public func saveToken(_ token: String) {
        // Convert the token to Data
        guard let data = token.data(using: .utf8) else { return }
        
        // Define the query to save the token
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: tokenKey,
            kSecValueData: data
        ]
        
        // Delete any existing item before adding the new one (if present)
        SecItemDelete(query as CFDictionary)
        
        // Add the new item to the keychain
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status != errSecSuccess {
            print("Error saving token: \(status)")
        }
    }
    
    // Retrieve token
    public func getToken() -> String? {
        // Define the query to retrieve the token
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: tokenKey,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess, let data = result as? Data, let token = String(data: data, encoding: .utf8) {
            return token
        }
        
        return nil
    }
    
    // Clear the token from the keychain (logout)
    public func clearAuthToken() {
        // Define the query to delete the token
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: tokenKey
        ]
        
        // Delete the token from the keychain
        let status = SecItemDelete(query as CFDictionary)
        
        if status != errSecSuccess {
            print("Error clearing token: \(status)")
        }
    }
}
