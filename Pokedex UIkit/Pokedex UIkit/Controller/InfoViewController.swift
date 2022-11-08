//
//  InfoViewController.swift
//  Pokedex UIkit
//
//  Created by Ali Eldeeb on 11/7/22.
//

import UIKit

class InfoViewController: UIViewController{
    //MARK: - Properties
    weak var delegate: InfoViewDelegate?
    
    
    init(delegate: InfoViewDelegate, pokemon: Pokemon){
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.infoView.pokemon = pokemon
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var infoView: InfoView = {
        let view = InfoView()
        view.delegate = delegate
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
        super.viewDidLoad()
        isModalInPresentation = false
        
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.infoView.isHidden = false
            self.infoView.alpha = 1
            self.infoView.transform = .identity
            
            self.blurEffect.isHidden = false
            self.blurEffect.alpha = 1
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    private func configureUI(){
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
    
    
    
    
    private func dismssInfoView(pokemon: Pokemon?){
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.infoView.alpha = 0
            self.infoView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.blurEffect.alpha = 0
            
        } completion: { _ in
//            self.infoView.isHidden = true
//            self.blurEffect.isHidden = true
            self.dismiss(animated: false)
        }
    }
    
    //MARK: - Selectors
    @objc private func handleDismissInfoView(){
        dismssInfoView(pokemon: nil)
    }
}
