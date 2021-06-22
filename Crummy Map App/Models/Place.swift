//
//  Place.swift
//  Crummy Map App
//
//  Created by Joe Crotchett on 6/21/21.
//

import UIKit

struct Place {
    var address: String
    var mapURL: URL?
    
    var country: String? {
        address.components(separatedBy: ", ").last
    }
    
    var streetAddress: String {
        var terms = address.components(separatedBy: ", ")
        terms.removeLast()
        return terms.joined(separator: ", ")
    }
    
    var city: String? {
        address.components(separatedBy: ", ").first
    }
}

// MARK: Corruption layer (used to prevent any possible OpenGate Geocoder API wonkinessfrom affecting the rest of the app)

extension Place {
    init(searchResult: SearchAPI.PlaceSearchResult) {
        self.init(
            address: String(searchResult.formatted),
            mapURL: URL(string: searchResult.annotations.osm.url)
        )
    }
}
