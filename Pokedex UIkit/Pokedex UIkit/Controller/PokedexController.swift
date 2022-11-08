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
    private var filteredPokemon = [Pokemon]()
    private var pokeDict = [Int: Pokemon]()
//    private var evolutionImages = [
    var inSearchMode = false //using this to determine whether we are searching, based on that we will tell our program which array to look at for our CV
    
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.sizeToFit()
        bar.delegate = self
        bar.tintColor = .white
        return bar
    }()
    
   
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        configureUI()
        fetchPokemon()
    }

    //MARK: - API
    
    private func fetchPokemon(){
        Service.shared.fetchPokemon { pokemon, pokeDict  in
            self.pokemon = pokemon
            self.pokeDict = pokeDict
            DispatchQueue.main.async {
                //if you dont do this your cv will be blank since the cv is initialized before the network call is complete
                self.collectionView.reloadData()
            }
            
        }
    }
    
    //MARK: - Helpers
    private func configureUI(){
        collectionView.backgroundColor = .white
        navigationItem.title = "Pokédex"
        showSearchButton(shouldShow: true)
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        collectionView.register(PokedexCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        
        
        
    }
    
    private func showSearchButton(shouldShow: Bool){
        if shouldShow{
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleSearchTapped))
        }else{
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    private func search(shouldShow: Bool){
        showSearchButton(shouldShow: !shouldShow)
        searchBar.showsCancelButton = true
        navigationItem.titleView = shouldShow ? searchBar: nil
    }
    //MARK: - Selectors
    @objc private func handleSearchTapped(){
        search(shouldShow: true)
        searchBar.becomeFirstResponder()
    }
    
}

//MARK: - CV datasource and delegate methods
extension PokedexController{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inSearchMode ? filteredPokemon.count: pokemon.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PokedexCell
        cell.pokemon = inSearchMode ? filteredPokemon[indexPath.item]: pokemon[indexPath.item]
        cell.backgroundColor = .systemGroupedBackground
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Passing in the pokemon at the cell into our infoView
        let selectedPokemon = inSearchMode ? filteredPokemon[indexPath.item]: pokemon[indexPath.item]
        let infoViewController = InfoViewController(delegate: self, pokemon: selectedPokemon)
        //since we are handling animations we are making it false
        present(infoViewController, animated: false)
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

//MARK: - InfoViewDelegate
extension PokedexController: InfoViewDelegate{
    func presentMoreInfo(withPokemon pokemon: Pokemon?) {
        dismiss(animated: false)
        guard let pokemon = pokemon else{return}
        var pokemonDict = [Int: String]()
        for evolution in pokemon.evolutionChain ?? []{
            if let id = evolution.getId{
               pokemonDict[id] = pokeDict[id]?.imageUrl
            }
            
        }
        //present moreInfoVC
        let moreInfoController = MoreInfoController(pokeEvolutions: pokemonDict, pokemon: pokemon)
        
        
        
        navigationController?.pushViewController(moreInfoController, animated: true)
        
    }
    
    
}
//MARK: - UISearchBarDelegate
extension PokedexController: UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search(shouldShow: false)
        searchBar.text = nil
        inSearchMode = false
        collectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //filtering our pokemon array based on search text
        if searchText == "" || searchBar.text == nil{
            inSearchMode = false
            collectionView.reloadData()
            view.endEditing(true)
        }else{
            inSearchMode = true
            
            // Filtering pokemon who meet the requirement of their name containing the search text
            filteredPokemon = pokemon.filter({$0.name?.range(of: searchText.lowercased()) != nil})
            collectionView.reloadData()
        }
    }
}
