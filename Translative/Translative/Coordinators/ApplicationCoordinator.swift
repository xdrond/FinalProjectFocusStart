//
//  ApplicationCoordinator.swift
//  Translative
//
//  Created by xdrond on 21.12.2020.
//

import UIKit

final class ApplicationCoordinator {

    // MARK: - Private Properties
    private let dataProvider: ITranslateProvider = TranslateProvider.shared
    private let rootViewController = UINavigationController()

    private let window: UIWindow

    private lazy var translateCoordinator: Coordinator? = TranslateCoordinator(dataProvider: self.dataProvider,
                                                                                 presenter: self.rootViewController)

    // MARK: - Initializers
    init(window: UIWindow) {
        self.window = window
    }

}

extension ApplicationCoordinator: Coordinator {
    func start() {
        self.window.rootViewController = rootViewController
        self.translateCoordinator?.start()
        self.window.makeKeyAndVisible()
    }
}
