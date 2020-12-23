//
//  TranslateCoordinator.swift
//  Translative
//
//  Created by xdrond on 21.12.2020.
//

import UIKit

final class TranslateCoordinator {

    // MARK: - Private Properties
    private var dataProvider: ITranslateProvider
    private let presenter: UINavigationController

    private var translateView: UIViewController?
    private var pair: TranslationPair?
    private var pairID: UUID?

    // MARK: - Initializers
    init(dataProvider: ITranslateProvider,
         presenter: UINavigationController,
         pairID: UUID? = nil) {
        self.dataProvider = dataProvider
        self.presenter = presenter
        self.pairID = pairID
    }
}

extension TranslateCoordinator: Coordinator {
    func start() {
        self.dataProvider.delegate = self
        let translateView = TranslateUIViewController()

        // place for pass data to view.

        self.presenter.pushViewController(translateView, animated: true)
        self.translateView = translateView
    }
}

extension TranslateCoordinator: TranslateProviderDelegate {
    func translateRetrieved(pair: TranslationPair) {
        //place for reload view.
        // TODO: Temp delegate action
        print("Получен ответ делегатом: \(String(describing: pair.destinationText))")
    }
}
