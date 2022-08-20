//
//  CellCollectionViewCell.swift
//  Challenge
//
//  Created by Fernando on 18/08/22.
//

import UIKit

class CellCollectionViewCell: UICollectionViewCell {
    //MARK: - UI Property
    static let identifier = "\(CellCollectionViewCell.self)"
    private var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    //MARK: - initialiser
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        contentView.layer.cornerRadius = 10
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(information: NewReponse) {
        self.titleLabel.text = information.title
        self.image.image = UIImage()
        self.authorLabel.text = information.authors
        self.descriptionLabel.text = information.description
    }
}

extension CellCollectionViewCell: CodeView {
    //MARK: - Setup constraints 
    func setupComponents() {
        contentView.addSubview(image)
        contentView.addSubview(authorLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
    }

    func setupConstraints() {
        setupConstraintsImageView()
        setupConstrainsAuthorLabel()
        setupConstraintsTitleLabel()
        setupConstraintsDescriptionLabel()
        
    }
    
    private func setupConstraintsImageView() {
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 20),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -20),
            image.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func setupConstrainsAuthorLabel() {
        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: image.bottomAnchor,constant: 5),
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 32),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -32)
        ])
    }
    
    private func setupConstraintsTitleLabel() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor,constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -32)
        ])
    }
    
    private func setupConstraintsDescriptionLabel() {
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 32),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -32)
        ])
    }
}
