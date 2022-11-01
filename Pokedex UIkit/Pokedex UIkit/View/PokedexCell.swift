//
//  PokedexCell.swift
//  Pokedex UIkit
//
//  Created by Ali Eldeeb on 10/30/22.
//

import UIKit

class PokedexCell: UICollectionViewCell{
    //MARK: - Properties
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .systemGroupedBackground
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "magicmouse.fill")
        return iv
    }()
    
    private lazy var nameContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainPink()
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
}
