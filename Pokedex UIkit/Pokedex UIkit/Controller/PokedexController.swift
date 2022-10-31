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
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        configureUI()
    }
    
    //MARK: - Helpers
    private func configureUI(){
        collectionView.backgroundColor = .white
        navigationController?.navigationBar.backgroundColor = .mainPink()
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
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
        return 6
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PokedexCell
        return cell
        
    }
}
