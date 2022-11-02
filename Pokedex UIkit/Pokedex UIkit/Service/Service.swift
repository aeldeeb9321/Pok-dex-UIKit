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
    
    func fetchPokemon(completion: @escaping ([Pokemon]) -> ()){
        var pokemonArray: [Pokemon] = []
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
                
                if let data = data{
                    do{
                        guard let resultArray = try JSONSerialization.jsonObject(with: data, options: []) as? [AnyObject] else{return}
                        //our for loop iterates through each element, we take all the data, parse it into a dictionary and parse it accordingly. .enumerated gives us access to that key parameter
                        for (key,result) in resultArray.enumerated(){
                            //casting the information as a dictionary that is type String:AnyObject
                            if let dictionary = result as? [String: AnyObject]{
                                let pokemon = Pokemon(id: key, dictionary: dictionary)
                                pokemonArray.append(pokemon)
                            }
                            completion(pokemonArray)
                        }
                    }catch let error{
                        print("Failed to create json with error: \(error.localizedDescription)")
                    }
                    
                }
            }.resume()
        }
        
    }
}
