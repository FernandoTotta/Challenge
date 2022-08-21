//
//  CodeView.swift
//  Challenge
//
//  Created by Fernando on 18/08/22.
//

import Foundation
protocol CodeView: AnyObject {
    func setup()
    func setupComponents()
    func setupConstraints()
}

extension CodeView {
    func setup() {
        setupComponents()
        setupConstraints()
    }
}
