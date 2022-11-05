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
    var inSearchMode = false //using this to determine whether we are searching, based on that we will tell our program which array to look at for our CV
    
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.sizeToFit()
        bar.delegate = self
        bar.tintColor = .white
        return bar
    }()
    
    private lazy var infoView: InfoView = {
        let view = InfoView()
        view.delegate = self
        return view
    }()
    
    private lazy var blurEffect: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismissInfoView)))
        return view
    }()
    
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
        showSearchButton(shouldShow: true)
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        collectionView.register(PokedexCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        view.addSubview(infoView)
        infoView.setDimesions(height: view.frame.width , width: view.frame.width - 64)
        infoView.centerX(inView: view)
        infoView.centerY(inView: view, contstant: 44)
        infoView.isHidden = true
        infoView.alpha = 0
        infoView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        
        view.insertSubview(blurEffect, belowSubview: infoView)
        blurEffect.anchor(top: view.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        blurEffect.isHidden = true
        blurEffect.alpha = 0
        
        
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
    
    @objc private func handleDismissInfoView(){
        dismssInfoView(pokemon: nil)
    }
    
    private func dismssInfoView(pokemon: Pokemon?){
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.infoView.alpha = 0
            self.infoView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.blurEffect.alpha = 0
            
        } completion: { _ in
            self.infoView.isHidden = true
            self.blurEffect.isHidden = true
        }
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
        //Passing in the pokemon at the celll into our infoView
        infoView.pokemon = pokemon[indexPath.item]
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.infoView.isHidden = false
            self.infoView.alpha = 1
            self.infoView.transform = .identity
            
            self.blurEffect.isHidden = false
            self.blurEffect.alpha = 1
        }

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
        dismssInfoView(pokemon: pokemon)

        //present moreInfoVC
        if let pokemon = pokemon{
            let moreInfoController = MoreInfoController(pokemon: pokemon)
            navigationController?.pushViewController(moreInfoController, animated: true)
        }
        
    }
    
    
}
//MARK: - UISearchBarDelegate
extension PokedexController: UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search(shouldShow: false)
        searchBar.text = nil
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //when the search icon is pressed
        print("search bar began editing")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //when cancel is pressed
        print("search bar did end editing")
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //filtering our pokemon array based on search text
        if searchText == "" || searchBar.text == nil{
            inSearchMode = false
            collectionView.reloadData()
            view.endEditing(true)
        }else{
            inSearchMode = true
            filteredPokemon = pokemon.filter({$0.name?.range(of: searchText.lowercased()) != nil})
            collectionView.reloadData()
//            filteredPokemon.forEach { pokemon in
//                filteredPokemon.append(pokemon)
//            }
            
        }
        print("Search text is: \(searchText)")
    }
}
