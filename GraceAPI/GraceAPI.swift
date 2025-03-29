//
//  GraceAPI.swift
//  GraceAPI
//
//  Created by Shafee Rehman on 29/03/2025.
//

public class GAPICaller {
    
    private let urlPath: String
    
    public init(urlPath: String) {
        self.urlPath = urlPath
    }
    
    public func request<T: Codable>(
        responseType: T.Type,
        method: HTTPMethod = .GET,
        additionalHeaders: [String: String]? = nil,
        requestBody: Codable? = nil,
        requiresAuth: Bool = false
    ) async -> Result<T, APIError> {
        
        guard let url = URL(string: urlPath) else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        var headers: [String: String] = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        if let additionalHeaders = additionalHeaders {
            for (key, value) in additionalHeaders {
                headers[key] = value
            }
        }
        
        if requiresAuth, let token = TokenManager.shared.getToken() {
            headers["Authorization"] = "Bearer \(token)"
        }
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        if method != .GET, let requestBody {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            guard let encodedJson = try? encoder.encode(requestBody) else {
                return .failure(.unknown)
            }
            request.httpBody = encodedJson
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 401:
                    TokenManager.shared.clearAuthToken()
                    return .failure(.unauthorized)
                case 400...499:
                    if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                        return .failure(.clientError(errorResponse))
                    }
                    return .failure(.unknown)
                case 500...599:
                    return .failure(.serverError)
                default:
                    break
                }
            }
            
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return .success(decodedResponse)
            
        } catch {
            if (error as NSError).domain == NSURLErrorDomain {
                return .failure(.networkFailure)
            } else {
                return .failure(.decodingError)
            }
        }
    }
}

// Enum to represent HTTP methods
public enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
    case PATCH
}

public enum APIError: Error {
    case invalidURL
    case unauthorized
    case clientError(ErrorResponse)
    case serverError
    case networkFailure
    case decodingError
    case unknown
}
