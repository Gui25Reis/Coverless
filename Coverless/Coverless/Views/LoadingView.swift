//
//  LoadingView.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 29/09/21.
//

import UIKit

final class LoadingView: UIView {
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        var spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    init(designSystem: DesignSystem) {
        super.init(frame: .zero)
        backgroundColor = designSystem.palette.backgroundPrimary
        loadingIndicator.color = designSystem.palette.accent
        addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        isAccessibilityElement = true
        accessibilityTraits = .staticText
        accessibilityLabel = "Loading books"
        start()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start() {
        loadingIndicator.startAnimating()
    }
    
    func stop() {
        loadingIndicator.stopAnimating()
    }
}

#if(DEBUG)
import SwiftUI

struct LoadingView_Preview: PreviewProvider {
    static var previews: some View {
        AnyViewRepresentable(LoadingView(designSystem: DefaultDesignSystem()))
    }
}

#endif
