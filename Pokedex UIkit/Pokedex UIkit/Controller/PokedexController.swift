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
    
    private lazy var infoView: InfoView = {
        let view = InfoView()
        view.delegate = self
        return view
    }()
    
    private lazy var blurEffect: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismissInfoView)))
        return view
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        configureUI()
        fetchPokemon()
        print(view.frame.width)
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
    
    //MARK: - Selectors
    @objc private func handleSearchTapped(){
        print("Searching")
    }
    
    @objc private func handleDismissInfoView(){
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.infoView.alpha = 0
            self.infoView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
            self.blurEffect.alpha = 0
            
        } completion: { _ in
            self.infoView.isHidden = true
            self.blurEffect.isHidden = true
        }
        

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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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

extension PokedexController: InfoViewDelegate{
    func presentMoreInfo() {
        //present moreInfoVC
        let moreInfoController = MoreInfoController()
        navigationController?.pushViewController(moreInfoController, animated: true)
    }
    
    
}
