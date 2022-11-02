//
//  PokedexController.swift
//  Pokedex UIkit
//
//  Created by Ali Eldeeb on 10/30/22.
//

import UIKit

private let reuseIdentifier = "cvID"

class PokedexController: UICollectionViewController{
    //MARK: - Properties
    private var pokemon = [Pokemon]()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        configureUI()
        fetchPokemon()
    }

    //MARK: - API
    
    private func fetchPokemon(){
        Service.shared.fetchPokemon { (pokemon) in
            self.pokemon = pokemon
            DispatchQueue.main.async {
                //if you dont do this your cv will be blank since the cv is initialized before the network call is complete
                self.collectionView.reloadData()
            }
            
        }
        print(pokemon.count)
    }
    
    //MARK: - Helpers
    private func configureUI(){
        collectionView.backgroundColor = .white
        navigationItem.title = "Pokédex"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(handleSearchTapped))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        collectionView.register(PokedexCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    //MARK: - Selectors
    @objc private func handleSearchTapped(){
        print("Searching")
    }
}
//MARK: - Extension
extension PokedexController{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemon.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PokedexCell
        cell.pokemon = pokemon[indexPath.item]
        cell.backgroundColor = .systemGroupedBackground
        return cell
        
    }
}

//MARK: - CollectionViewLayout
extension PokedexController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 32, left: 8, bottom: 8, right: 8)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 36) / 3
        return CGSize(width: width, height: width)
    }
}
