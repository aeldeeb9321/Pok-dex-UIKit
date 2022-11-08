//
//  Service.swift
//  Pokedex UIkit
//
//  Created by Ali Eldeeb on 10/31/22.
//

import Foundation

class Service{
    //creating a shared instance of this class, its static so we make sure we only implement a single instance of this class so we dont have a bunch of api calls in our application since that could get messy, take up a lot of memory, calls could interupt each other or cause a lot of traffic in our application.
    static let shared = Service()
    let session: URLSession = URLSession(configuration: .default)
    
    let BASE_URL = URL(string: "https://pokedex-bb36f.firebaseio.com/pokemon.json")
    var idToPokemon = [Int: Pokemon]()
    func fetchPokemon(completion: @escaping ([Pokemon],[Int: Pokemon]) -> ()){
        
        if let url = BASE_URL{
            session.dataTask(with: URLRequest(url: url)) { data, response, error in
                if let error = error{
                    assertionFailure()
                    print("Failed to fetch data with error: \(error.localizedDescription)!")
                    return
                }
                
                guard let response = response as? HTTPURLResponse else{return}
                guard(200...299).contains(response.statusCode) else{
                    assertionFailure()
                    print("Invalid response status code recieved \(response.statusCode)")
                    return
                }
                
                guard let data = data?.parseData(removeString: "null,") else {return}
                let decoder = JSONDecoder()
                if let pokemonData = try? decoder.decode([Pokemon].self, from: data){
                    for pokemon in pokemonData{
                        if let pokeId = pokemon.id{
                            self.idToPokemon[pokeId] = pokemon
                        }
                    }
                    completion(pokemonData, self.idToPokemon)
                }
                
            }.resume()
        }
        
    }
}

extension Data{
    func parseData(removeString string: String) -> Data?{
        let dataAsString = String(data: self, encoding: .utf8)
        let parsedDataString = dataAsString?.replacingOccurrences(of: string, with: "")
        guard let data = parsedDataString?.data(using: .utf8) else{return nil}
        return data
    }
}
