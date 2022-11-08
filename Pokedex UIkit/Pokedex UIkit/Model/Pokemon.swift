//
//  Pokemon.swift
//  Pokedex UIkit
//
//  Created by Ali Eldeeb on 10/31/22.
//

import UIKit

struct Pokemon: Codable{
    var name: String?
    var imageUrl: String?
    var id: Int?
    var weight: Int?
    var height: Int?
    var defense: Int?
    var attack: Int?
    var description: String?
    var type: String?
    var baseExperience: Int?
    var evolutionChain: [Evolution]?

}

struct Evolution: Codable{
    let id: String
    let name: String
    
    var getId: Int?{
        return Int(id)
    }
}
