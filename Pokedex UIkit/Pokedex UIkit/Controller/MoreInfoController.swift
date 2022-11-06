//
//  MoreInfoController.swift
//  Pokedex UIkit
//
//  Created by Ali Eldeeb on 11/2/22.
//

import UIKit

class MoreInfoController: UIViewController{
    //MARK: - Properties
    var pokemon: Pokemon?{
        didSet{
            guard let pokemon = pokemon else{return}
            guard let type = pokemon.type else{return}
            guard let defense = pokemon.defense else{return}
            guard let attack = pokemon.attack else{return}
            guard let id = pokemon.id else{return}
            guard let height = pokemon.height else{return}
            guard let weight = pokemon.weight else{return}
            guard let description = pokemon.description else{return}
 
            self.pokemonDescription.text = description
            configLabel(label: typeLabel, title: "Type: ", details: type)
            configLabel(label: pokedexIdLabel, title: "Pokedex ID: ", details: "\(id)")
            configLabel(label: attackLabel, title: "Base Attack: ", details: "\(attack)")
            configLabel(label: defenseLabel, title: "Defense: ", details: "\(defense)")
            configLabel(label: heightLabel, title: "Height: ", details: "\(Float(height) / 10.0) m")
            configLabel(label: weightLabel, title: "Weight: ", details: "\(weight / 10) kg")
            navigationItem.title = pokemon.name?.capitalized
            
            if let imageUrlString = pokemon.imageUrl{
                let url = URL(string: imageUrlString)
                self.pokemonImageView.sd_setImage(with: url)
            }
        }
    }
    
    private lazy var pokemonImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.setDimesions(height: 75, width: 75)
        return iv
    }()
    
    private lazy var pokemonDescription: UILabel = {
        let label = UILabel().makeLabel(textColor: .label, withFont: UIFont.boldSystemFont(ofSize: 20))
        return label
    }()
    
    private lazy var typeLabel: UILabel = {
        let label = UILabel().makeLabel(textColor: .mainPink(), withFont: UIFont.systemFont(ofSize: 16))
        return label
    }()
    
    private lazy var pokedexIdLabel: UILabel = {
        let label = UILabel().makeLabel( textColor: .mainPink(), withFont: UIFont.systemFont(ofSize: 16))
        return label
    }()

    
    private lazy var heightLabel: UILabel = {
        let label = UILabel().makeLabel(textColor: .mainPink(), withFont: UIFont.systemFont(ofSize: 16))
        return label
    }()
    
    private lazy var weightLabel: UILabel = {
        let label = UILabel().makeLabel(textColor: .mainPink(), withFont: UIFont.systemFont(ofSize: 16))
        return label
    }()
    
    private lazy var attackLabel: UILabel = {
        let label = UILabel().makeLabel(textColor: .mainPink(), withFont: UIFont.systemFont(ofSize: 16))
        return label
    }()
    
    private lazy var defenseLabel: UILabel = {
        let label = UILabel().makeLabel(textColor: .mainPink(), withFont: UIFont.systemFont(ofSize: 16))
        return label
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        view.backgroundColor = .mainPink()
        configureViewComponents()
    }
    
    //MARK: - Helpers
    private func configureViewComponents(){
        view.backgroundColor = .white
        let imageDescriptionStack = UIStackView(arrangedSubviews: [pokemonImageView, pokemonDescription])
        imageDescriptionStack.axis = .horizontal
        imageDescriptionStack.spacing = 6
        imageDescriptionStack.distribution = .fillProportionally
        view.addSubview(imageDescriptionStack)
        imageDescriptionStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 5, paddingLeading: 20, paddingTrailing: 20)
        
        let statVStack1 = UIStackView(arrangedSubviews: [typeLabel, heightLabel, weightLabel])
        statVStack1.axis = .vertical
        statVStack1.spacing = 16
        statVStack1.distribution = .fillEqually
        
        let statVStack2 = UIStackView(arrangedSubviews: [defenseLabel, pokedexIdLabel, attackLabel])
        statVStack2.axis = .vertical
        statVStack2.spacing = 16
        statVStack2.distribution = .fillEqually
        let hStatStack = UIStackView(arrangedSubviews: [statVStack1, statVStack2])
        hStatStack.axis = .horizontal
        hStatStack.distribution = .fillEqually
        hStatStack.spacing = 10
        view.addSubview(hStatStack)
        hStatStack.anchor(top: imageDescriptionStack.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 5, paddingLeading: 12, paddingTrailing: 3)
    }
    
    private func configLabel(label: UILabel, title: String, details: String){
        let attributedText = NSMutableAttributedString(string: title, attributes: [.font : UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.mainPink()])
        
        attributedText.append(NSAttributedString(string: details, attributes: [.font : UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.label]))
        
        label.attributedText = attributedText
    }
}
