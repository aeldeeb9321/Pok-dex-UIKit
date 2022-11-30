//
//  Pokemon.swift
//  Pokedex UIkit
//
//  Created by Ali Eldeeb on 10/31/22.
//

import UIKit

struct Pokemon: Codable{
    let name: String?
    let imageUrl: String
    let id: Int?
    let weight: Int?
    let height: Int?
    let defense: Int?
    let attack: Int?
    let description: String?
    let type: String?
    let baseExperience: Int?
    let evolutionChain: [Evolution]?
    
    var backgroundColor: UIColor{
        switch type{
        case "fire": return .mainPink()
        case "water": return .systemBlue
        case "poison": return .systemGreen
        case "electric": return .systemYellow
        case "psychic": return .systemPurple
        case "normal": return .systemGray
        case "ground": return .systemOrange
        case "flying": return .systemTeal
        case "fairy": return .systemPink
        default: return .systemIndigo
        }
    }

}

struct Evolution: Codable{
    let id: String
    let name: String
    
    var getId: Int?{
        return Int(id)
    }
}
