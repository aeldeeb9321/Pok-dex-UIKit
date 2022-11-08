//
//  PokedexCell.swift
//  Pokedex UIkit
//
//  Created by Ali Eldeeb on 10/30/22.
//

import UIKit
import SDWebImage

class PokedexCell: UICollectionViewCell{
    //MARK: - Properties
    var pokemon: Pokemon? {
        didSet{
            pokemonLabel.text = pokemon?.name?.capitalized
            if let imageUrlString = pokemon?.imageUrl{
                let url = URL(string: imageUrlString)
                imageView.sd_setImage(with: url)
            }
            nameContainerView.backgroundColor = pokemon?.backgroundColor
        }
    }
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .systemGroupedBackground
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var nameContainerView: UIView = {
        let view = UIView()
        view.addSubview(pokemonLabel)
        pokemonLabel.centerX(inView: view)
        pokemonLabel.centerY(inView: view)
        return view
    }()
    private lazy var pokemonLabel: UILabel = {
        let label = UILabel().makeLabel(withText: "Bulbasaur", textColor: .white, withFont: UIFont.systemFont(ofSize: 16))
        return label
    }()
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    private func configureCell(){
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        addSubview(imageView)
        imageView.setDimesions(height: self.frame.height - 32, width: self.frame.height - 32)
        imageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor)
        addSubview(nameContainerView)
        nameContainerView.anchor(top:imageView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)

    }
    
    //MARK: - Selectors

}

