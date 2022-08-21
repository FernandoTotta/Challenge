//
//  NewsDetailsViewController.swift
//  Challenge
//
//  Created by Fernando on 21/08/22.
//

import UIKit

class NewsDetailsViewController: UIViewController {

    private var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private var publishedAt: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .thin)
        return label
    }()
    
    private var content: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = true
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private var information: FormattedResponse
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title =  information.indexer.title
    }

    init(information: FormattedResponse) {
        self.information = information
        super.init(nibName: nil, bundle: nil)
        setup()
        self.loadImage(url: information.imageName)
        publishedAt.text = information.publishedAt
        content.text = information.content
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadImage(url: URL) {
        spinner.startAnimating()
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.spinner.stopAnimating()
                        self.imageView.image = image
                        self.view.addSubview(self.publishedAt)
                        self.view.addSubview(self.content)
                        self.setupConstraintsContent()
                        self.setupConstraintsPublishAt()
                    }
                }
            }
        }
    }
}

extension NewsDetailsViewController: CodeView {
    func setupComponents() {
        view.addSubview(imageView)
        imageView.addSubview(spinner)
    }
    
    func setupConstraints() {
        setupConstraintsImageView()
        setupConstraintsSpinner()
    }
    
    private func setupConstraintsImageView() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 350)
        ])
    }
    
    private func setupConstraintsSpinner() {
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }
    
    private func setupConstraintsPublishAt() {
        NSLayoutConstraint.activate([
            publishedAt.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            publishedAt.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            publishedAt.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupConstraintsContent() {
        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: publishedAt.bottomAnchor, constant: 10),
            content.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            content.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            content.heightAnchor.constraint(equalToConstant: 400)
            
        ])
    }

   
}
