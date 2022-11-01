//
//  Service.swift
//  Pokedex UIkit
//
//  Created by Ali Eldeeb on 10/31/22.
//

import Foundation

class Service{
    static let shared = Service()
    let session: URLSession = URLSession(configuration: .default)
  
    let BASE_URL = URL(string: "https://pokedex-bb36f.firebaseio.com/pokemon.json")
    
    func fetchPokemon(){
        if let url = BASE_URL{
            session.dataTask(with: URLRequest(url: url)) { data, response, error in
                if let error = error{
                    assertionFailure()
                    print("Error: \(error.localizedDescription)!")
                    return
                }
                
                guard let response = response as? HTTPURLResponse else{return}
                guard(200...299).contains(response.statusCode) else{
                    assertionFailure()
                    print("Invalid response status code recieved \(response.statusCode)")
                    return
                }
                
                if let data = data{
                    let decoder = JSONDecoder()
                    let PokemonData = try? decoder.decode([Pokemon].self, from: data)
                }
            }
        }
        
    }
}
