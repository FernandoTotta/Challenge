//
//  HeaderCollectionReusableView.swift
//  Challenge
//
//  Created by Fernando on 18/08/22.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    //MARK: - Property 
    
    static let identifier = "\(HeaderCollectionReusableView.self)"
    
    private var titleLabel : UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        return title
    }()
    
    //MARK: - Initialiser
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupHeader(title: NewTitle) {
        self.titleLabel.text = title.title
    }
}

extension HeaderCollectionReusableView: CodeView {
    //MARK: - Setup constraints
    
    func setupComponents() {
        addSubview(titleLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
