//
//  MoreInfoController.swift
//  Pokedex UIkit
//
//  Created by Ali Eldeeb on 11/2/22.
//

import UIKit

class MoreInfoController: UIViewController{
    //MARK: - Properties
    var pokeEvolutions = [Int: String]()
    var pokemon: Pokemon
    
    init(pokeEvolutions: [Int : String], pokemon: Pokemon) {
        
        self.pokeEvolutions = pokeEvolutions
        self.pokemon = pokemon
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var pokemonImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.setDimesions(height: 100, width: 100)
        return iv
    }()
    
    private lazy var pokemonDescription: UILabel = {
        let label = UILabel().makeLabel(textColor: .label, withFont: UIFont.systemFont(ofSize: 16))
        return label
    }()
    
    private lazy var typeLabel: UILabel = {
        let label = UILabel().makeLabel(withFont: UIFont.systemFont(ofSize: 16))
        return label
    }()
    
    private lazy var pokedexIdLabel: UILabel = {
        let label = UILabel().makeLabel(withFont: UIFont.systemFont(ofSize: 16))
        return label
    }()

    
    private lazy var heightLabel: UILabel = {
        let label = UILabel().makeLabel(withFont: UIFont.systemFont(ofSize: 16))
        return label
    }()
    
    private lazy var weightLabel: UILabel = {
        let label = UILabel().makeLabel(withFont: UIFont.systemFont(ofSize: 16))
        return label
    }()
    
    private lazy var attackLabel: UILabel = {
        let label = UILabel().makeLabel(withFont: UIFont.systemFont(ofSize: 16))
        return label
    }()
    
    private lazy var defenseLabel: UILabel = {
        let label = UILabel().makeLabel(withFont: UIFont.systemFont(ofSize: 16))
        return label
    }()
    
    private lazy var evoLabel: UILabel = {
        let label = UILabel().makeLabel(withText: "Evolution Chain:", textColor: .white, withFont: UIFont.boldSystemFont(ofSize: 18))
        return label
    }()
    
    private lazy var evolutionStack: UIStackView = {
        let evolutionStack = UIStackView(arrangedSubviews: [])
        evolutionStack.axis = .horizontal
        evolutionStack.spacing = 80
        evolutionStack.distribution = .fillProportionally
        
        return evolutionStack
    }()
    private lazy var evolutionView: UIView = {
        let view = UIView()
        view.addSubview(evoLabel)
        view.backgroundColor = pokemon.backgroundColor
        evoLabel.centerY(inView: view)
        evoLabel.centerX(inView: view)
        view.setDimesions(height: 50, width: 0)
        return view
    }()
    
    private func evoImageView() -> UIImageView{
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.setDimesions(height: 120, width: 120)
        return iv
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        configureViewComponents()
        setupLabels()
        configureEvolutionChain()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backgroundColor = pokemon.backgroundColor
    }
    
    //MARK: - Helpers
    private func configureEvolutionChain(){
        for evolution in pokemon.evolutionChain ?? []{
            guard let id = evolution.getId else{return}
            if let imageUrlString = pokeEvolutions[id]{
                let url = URL(string: imageUrlString)
                let imageView = evoImageView()
                imageView.sd_setImage(with: url)
                evolutionStack.addArrangedSubview(imageView)
            }
        }
    }
    
    private func setupLabels(){
        guard let type = pokemon.type else{return}
        guard let defense = pokemon.defense else{return}
        guard let attack = pokemon.attack else{return}
        guard let id = pokemon.id else{return}
        guard let height = pokemon.height else{return}
        guard let weight = pokemon.weight else{return}
        guard let description = pokemon.description else{return}
        
        self.pokemonDescription.text = description
        
        configLabel(label: typeLabel, title: "Type: ", details: type.capitalized)
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
    private func configureViewComponents(){
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .white
        view.addSubview(pokemonImageView)
        pokemonImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, paddingTop: 45, paddingLeading: 8)
        view.addSubview(pokemonDescription)
        pokemonDescription.centerY(inView: pokemonImageView)
        pokemonDescription.anchor(leading: pokemonImageView.trailingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 45, paddingLeading: 16, paddingTrailing: 4)
        
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
        hStatStack.spacing = 15
        view.addSubview(hStatStack)
        hStatStack.anchor(top: pokemonDescription.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 35, paddingLeading: 12, paddingTrailing: 3)
   
        
        view.addSubview(evolutionView)
        evolutionView.anchor(top: hStatStack.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 25)
        
        
        view.addSubview(evolutionStack)
        evolutionStack.anchor(top: evolutionView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 35, paddingLeading: 32, paddingTrailing: 32)
        
    }
    
    private func configLabel(label: UILabel, title: String, details: String){
        let attributedText = NSMutableAttributedString(string: title, attributes: [.font : UIFont.boldSystemFont(ofSize: 16), .foregroundColor: pokemon.backgroundColor])
        
        attributedText.append(NSAttributedString(string: details, attributes: [.font : UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.label]))
        
        label.attributedText = attributedText
    }
}
