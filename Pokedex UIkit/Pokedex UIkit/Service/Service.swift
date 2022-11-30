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
    private let session: URLSession = URLSession(configuration: .default)
    private let images = NSCache<NSString, NSData>()
    
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
    
    func fetchImageData(pokemon: Pokemon, completion: @escaping(Data?, Error?) -> ()){
        guard let url = URL(string: pokemon.imageUrl) else{ return }
        
        if let imageData = images.object(forKey: url.absoluteString as NSString){
            completion(imageData as Data, nil)
            return
        }
        session.downloadTask(with: url) { localUrl, response, error in
            guard error == nil else{ fatalError(error!.localizedDescription) }
            guard let response = response as? HTTPURLResponse else{ return }
            guard(200...299).contains(response.statusCode) else{
                assertionFailure("Recieve improper server response")
                return
            }
            
            guard let localUrl = localUrl else{
                completion(nil, error)
                return
            }
            do{
                let safeData = try Data(contentsOf: localUrl)
                self.images.setObject(safeData as NSData, forKey: url.absoluteString as NSString)
                completion(safeData, nil)
            }catch let error{
                print(error)
            }
        }.resume()
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
