//
//  SearchAPI.swift
//  Crummy Map App
//
//  Created by Joe Crotchett on 6/21/21.
//

import Foundation

final class SearchAPI {
    private let session: URLSession
    private let baseURL = URL(string: "https://api.opencagedata.com")!
    private let key = "2da759455ed7444aa236e449b2cfa7e0"

    // Track the active task so it can be canceled if no longer needed
    // (e.g. user changes query while request is in progress)
    private var activeSearchTask: URLSessionDataTask?

    init(session: URLSession = .shared) {
        self.session = session
    }

    func search(for term: String, completion: @escaping (Result<SearchResponse, SearchError>) -> Void) {
        let url = baseURL.appendingPathComponent("geocode/v1/json")
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "key", value: key),
            URLQueryItem(name: "q", value: term)
        ]

        // The order of the responses is not guaranteed, so if a request is already in progress, we should
        // cancel it before starting a new one. This is especially important in low-bandwith environments.
        activeSearchTask?.cancel()
        
        let request = URLRequest(url: components.url!)
        activeSearchTask = perform(request: request, completion: parseResponse(completion: completion))
    }
    
    // MARK: Private
    
    private func parseResponse(completion: @escaping (Result<SearchResponse, SearchError>) -> Void) -> (Result<Data, SearchError>) -> Void {
        return { result in
            switch result {
            case .success(let data):
                do {
                    let jsonDecoder = JSONDecoder()
                    let object = try jsonDecoder.decode(SearchResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(object))
                    }
                } catch let decodingError as DecodingError {
                    DispatchQueue.main.async {
                        completion(.failure(.decodingError(decodingError)))
                    }
                }
                catch {
                    fatalError("Unhandled error raised.")
                }

            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    @discardableResult
    private func perform(request: URLRequest, completion: @escaping (Result<Data, SearchError>) -> Void) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error as NSError? {
                if error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled {
                    return
                }

                completion(.failure(.networkingError(error)))
                return
            }

            guard let http = response as? HTTPURLResponse, let data = data else {
                completion(.failure(.invalidResponse))
                return
            }

            switch http.statusCode {
            case 200:
                completion(.success(data))

            case 400...499:
                let body = String(data: data, encoding: .utf8)
                completion(.failure(.requestError(http.statusCode, body ?? "🤷‍♂️")))

            case 500...599:
                completion(.failure(.serverError))

            default:
                fatalError("Unhandled HTTP status code: \(http.statusCode)")
            }
        }
        
        task.resume()
        return task
    }
}

// MARK: - API Models

extension SearchAPI {
    
    // MARK: - Response
    
    struct SearchResponse : Decodable {
        let results: [PlaceSearchResult]
    }
    
    // MARK: - Result
    
    struct PlaceSearchResult: Codable {
        let annotations: Annotations
        let formatted: String
    }

    // MARK: - Annotations
    
    struct Annotations: Codable {
        let osm: Osm
  
        enum CodingKeys: String, CodingKey {
            case osm = "OSM"
        }
    }

    // MARK: - Osm
    
    struct Osm: Codable {
        let url: String
    }
}

// MARK: APIError

enum SearchError : Error {
    case networkingError(Error)
    case serverError // HTTP 5xx
    case requestError(Int, String) // HTTP 4xx
    case invalidResponse
    case decodingError(DecodingError)

    var localizedDescription: String {
        switch self {
        case .networkingError(let error): return "Error sending request: \(error.localizedDescription)"
        case .serverError: return "HTTP 500 Server Error"
        case .requestError(let status, let body): return "HTTP \(status)\n\(body)"
        case .invalidResponse: return "Invalid Response"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        }
    }
}
