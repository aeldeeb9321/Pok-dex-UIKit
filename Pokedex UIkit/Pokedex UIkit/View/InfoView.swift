//
//  InfoView.swift
//  Pokedex UIkit
//
//  Created by Ali Eldeeb on 11/2/22.
//

import UIKit
import SDWebImage

protocol InfoViewDelegate: AnyObject{
    func presentMoreInfo(withPokemon pokemon: Pokemon?)
}  
class InfoView: UIView{
    //MARK: - Propeties
    var pokemon: Pokemon? {
        didSet{
            guard let pokemon = pokemon else{return}
            guard let type = pokemon.type else{return}
            guard let defense = pokemon.defense else{return}
            guard let attack = pokemon.attack else{return}
            guard let id = pokemon.id else{return}
            guard let height = pokemon.height else{return}
            guard let weight = pokemon.weight else{return}
            
            self.containerView.backgroundColor = pokemon.backgroundColor
            self.moreInfoButton.backgroundColor = pokemon.backgroundColor
            self.pokemonNameTitleLabel.text = pokemon.name?.capitalized
            self.typeLabel.textColor = pokemon.backgroundColor
            self.pokedexIdLabel.textColor = pokemon.backgroundColor
            configLabel(label: typeLabel, title: "Type: ", details: type.capitalized)
            configLabel(label: pokedexIdLabel, title: "Pokedex ID: ", details: "\(id)")
            configLabel(label: attackLabel, title: "Attack: ", details: "\(attack)")
            configLabel(label: defenseLabel, title: "Defense: ", details: "\(defense)")
            configLabel(label: heightLabel, title: "Height: ", details: "\(Float(height) / 10.0) m")
            configLabel(label: weightLabel, title: "Weight: ", details: "\(weight / 10) kg")
            
            if let imageUrlString = pokemon.imageUrl{
                let url = URL(string: imageUrlString)
                self.pokemonImageView.sd_setImage(with: url)
            }

        }
    }
    
    var delegate: InfoViewDelegate?
    
    private lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var pokemonNameTitleLabel: UILabel = {
        let label = UILabel().makeLabel(textColor: .white, withFont: UIFont.systemFont(ofSize: 16))
        label.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        return label
    }()
    
    private lazy var pokemonImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.setDimesions(height: 75, width: 75)
        return iv
    }()
    
    private lazy var typeLabel: UILabel = {
        let label = UILabel().makeLabel(withFont: UIFont.systemFont(ofSize: 16))
        return label
    }()
    
    private lazy var pokedexIdLabel: UILabel = {
        let label = UILabel().makeLabel( withFont: UIFont.systemFont(ofSize: 16))
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
    
    private lazy var moreInfoButton: UIButton = {
        let button = UIButton().makeButton(withTitle: "View More Info", titleColor: .white, buttonColor: .mainPink(), isRounded: true)
        button.addTarget(self, action: #selector(handleMoreInfoTapped), for: .touchUpInside)
        button.setContentHuggingPriority(.required, for: .vertical)
        return button
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCellComponents()
        layer.cornerRadius = 5
        layer.masksToBounds = true
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    private func configureCellComponents(){
        addSubview(containerView)
//        containerView.centerX(inView: self)
        containerView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor)
        containerView.addSubview(pokemonNameTitleLabel)
        containerView.heightAnchor.constraint(equalToConstant: 55).isActive = true
        pokemonNameTitleLabel.centerX(inView: containerView)
        pokemonNameTitleLabel.centerY(inView: containerView)
        addSubview(pokemonImageView)
        pokemonImageView.centerX(inView: self)
        pokemonImageView.anchor(top: containerView.bottomAnchor, paddingTop: 5)
        let infoStack = UIStackView(arrangedSubviews: [typeLabel, pokedexIdLabel, heightLabel, weightLabel, attackLabel, defenseLabel, moreInfoButton])
        infoStack.axis = .vertical
        infoStack.spacing = 5
        infoStack.distribution = .fillEqually
        infoStack.alignment = .center
        addSubview(infoStack)
        infoStack.anchor(top: pokemonImageView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, paddingTop: 5,paddingBottom: 5)
    }
    
    private func configLabel(label: UILabel, title: String, details: String){
        let attributedText = NSMutableAttributedString(string: title, attributes: [.font : UIFont.boldSystemFont(ofSize: 16), .foregroundColor: pokemon?.backgroundColor ?? .mainPink()])
        
        attributedText.append(NSAttributedString(string: details, attributes: [.font : UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.label]))
        
        label.attributedText = attributedText
    }
    //MARK: - Selectors
    @objc private func handleMoreInfoTapped(){
        //making sure the pokemon exists
        guard let pokemon = self.pokemon else{return}
        delegate?.presentMoreInfo(withPokemon: pokemon)
    }
}
