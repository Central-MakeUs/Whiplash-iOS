//
//  PlaceResponseDTO.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/3/25.
//

import Foundation

struct PlaceResponseDTO: Decodable {
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    
    init(name: String,
         address: String,
         latitude: Double,
         longitude: Double) {
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
    
}

extension PlaceResponseDTO {
    
    var toDomain: Place {
        .init(name: name,
              address: address,
              latitude: latitude,
              longitude: longitude)
    }
    
}
