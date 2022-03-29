//
//  File.swift
//
//
//  Created by Kryštof Matěj on 07.01.2021.
//

import Foundation

public enum NetworkServiceMethod {
    case get
    case post
    case delete
    case patch
    case put
}

public struct NetworkResponse {
    public let statusCode: Int
    public let data: Data

    public init(statusCode: Int, data: Data) {
        self.statusCode = statusCode
        self.data = data
    }
}

public struct NetworkFileResponse {
    public let url: URL

    public init(url: URL) {
        self.url = url
    }
}

public protocol NetworkService {
    func execute(url: URL, method: NetworkServiceMethod, headers: [String: String], body: Data?) throws -> NetworkResponse
    func execute(url: URL) throws -> NetworkFileResponse
}

final class NetworkServiceImpl: NSObject, NetworkService, URLSessionDelegate {
    private lazy var session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())

    func execute(url: URL, method: NetworkServiceMethod, headers: [String: String], body: Data?) throws -> NetworkResponse {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = getMethodString(for: method)
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpBody = body
        let response = execute(request: urlRequest)

        if let data = response.data, let statusCode = response.statusCode {
            return NetworkResponse(statusCode: statusCode, data: data)
        } else if let error = response.error {
            throw ToolsError(description: "Network error: \(error)")
        } else {
            throw ToolsError(description: "Unknown network error")
        }
    }

    func execute(url: URL) throws -> NetworkFileResponse {
        let response = execute(fileUrl: url)

        if let resultUrl = response.url {
            return NetworkFileResponse(url: resultUrl)
        } else if let error = response.error {
            throw ToolsError(description: "File download error: \(error)")
        } else {
            throw ToolsError(description: "Unknown file network error")
        }
    }

    private func execute(request: URLRequest) -> NetworkServiceResponse {
        let semaphore = DispatchSemaphore(value: 0)
        var networkResponse = NetworkServiceResponse(statusCode: nil, data: nil, error: nil)

        let task = session.dataTask(with: request) { data, urlResponse, error in
            networkResponse.statusCode = (urlResponse as? HTTPURLResponse)?.statusCode
            networkResponse.data = data
            networkResponse.error = error
            semaphore.signal()
        }

        task.resume()
        semaphore.wait()
        return networkResponse
    }

    private func execute(fileUrl: URL) -> NetworkServiceDownloadResponse {
        let semaphore = DispatchSemaphore(value: 0)
        var response = NetworkServiceDownloadResponse(url: nil, error: nil)

        let task = session.downloadTask(with: fileUrl) { url, _, error in
            response = NetworkServiceDownloadResponse(url: url, error: error)
            semaphore.signal()
        }

        task.resume()
        semaphore.wait()
        return response
    }

    private func getMethodString(for method: NetworkServiceMethod) -> String {
        switch method {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .delete:
            return "DELETE"
        case .patch:
            return "PATCH"
        case .put:
            return "PUT"
        }
    }

    // MARK: - URLSessionDelegate

    func urlSession(_: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
}

private struct NetworkServiceResponse {
    public var statusCode: Int?
    public var data: Data?
    public var error: Error?
}

private struct NetworkServiceDownloadResponse {
    public var url: URL?
    public var error: Error?
}
