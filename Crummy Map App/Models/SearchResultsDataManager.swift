//
//  SearchResultsDataManager.swift
//  Crummy Map App
//
//  Created by Joe Crotchett on 6/21/21.
//

import Foundation

final class SearchResultsDataManager {
    private let searchClient = SearchAPI()

    /**
    I'm using the `Repository` pattern here to hide away the details of how the search result
    data is retrieved. For this app, it's not absolutely necessary, since we're only pulling
    data from the API, but it's still a good pattern to have in place in the event that we
    wanted to scale the app, and persist data in a local data store, for example.
    */
    func search(for term: String, completion: @escaping (Result<[Place], SearchError>) -> Void) {
        searchClient.search(for: term) { result in
            switch result {
            case .success(let response):
                let searchResults = response.results.map(Place.init)
                completion(.success(searchResults))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

