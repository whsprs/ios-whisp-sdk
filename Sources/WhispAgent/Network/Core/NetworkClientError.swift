import Foundation

enum NetworkClientError: Error {
   case invalidURL
   case invalidResponse
   case httpError(statusCode: Int, data: Data)
}
