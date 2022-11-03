//
//  InfoView.swift
//  Pokedex UIkit
//
//  Created by Ali Eldeeb on 11/2/22.
//

import UIKit
import SDWebImage

protocol InfoViewDelegate: AnyObject{
    func presentMoreInfo()
}
class InfoView: UIView{
    //MARK: - Propeties
    var pokemon: Pokemon? {
        didSet{
            self.pokemonNameTitleLabel.text = pokemon?.name
            self.typeLabel.text = "Type: \(pokemon?.type ?? "x")"
            self.pokedexIdLabel.text = "Pokedex ID: \(pokemon?.id ?? 0)"
            if let height = pokemon?.height{
                self.heightLabel.text = "Height: \(Float(height) / 10.0) m"
            }
            
            if let weight = pokemon?.weight{
                self.weightLabel.text = "Weight: \(weight / 10) kg"
            }
            
            self.attackLabel.text = "Attack: \(pokemon?.attack ?? 0)"
            self.defenseLabel.text = "Defense: \(pokemon?.defense ?? 0)"
            if let imageUrlString = pokemon?.imageUrl{
                let url = URL(string: imageUrlString)
                self.pokemonImageView.sd_setImage(with: url)
            }
        }
    }
    
    var delegate: InfoViewDelegate?
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainPink()
        return view
    }()
    private lazy var pokemonNameTitleLabel: UILabel = {
        let label = UILabel().makeLabel(withText: "", textColor: .white, withFont: UIFont.systemFont(ofSize: 16))
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
        let label = UILabel().makeLabel(withText: "Type: ", textColor: .mainPink(), withFont: UIFont.systemFont(ofSize: 16))
        return label
    }()
    
    private lazy var pokedexIdLabel: UILabel = {
        let label = UILabel().makeLabel(withText: "Pokedex ID: ", textColor: .mainPink(), withFont: UIFont.systemFont(ofSize: 16))
        return label
    }()

    
    private lazy var heightLabel: UILabel = {
        let label = UILabel().makeLabel(withText: "Height: ", textColor: .mainPink(), withFont: UIFont.systemFont(ofSize: 16))
        return label
    }()
    
    private lazy var weightLabel: UILabel = {
        let label = UILabel().makeLabel(withText: "Weight: ", textColor: .mainPink(), withFont: UIFont.systemFont(ofSize: 16))
        return label
    }()
    
    private lazy var attackLabel: UILabel = {
        let label = UILabel().makeLabel(withText: "Attack: ", textColor: .mainPink(), withFont: UIFont.systemFont(ofSize: 16))
        return label
    }()
    
    private lazy var defenseLabel: UILabel = {
        let label = UILabel().makeLabel(withText: "Defense: ", textColor: .mainPink(), withFont: UIFont.systemFont(ofSize: 16))
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
    
    
    //MARK: - Selectors
    @objc private func handleMoreInfoTapped(){
        delegate?.presentMoreInfo()
    }
}
