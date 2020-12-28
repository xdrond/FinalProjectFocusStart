//
//  TranslateCoordinator.swift
//  Translative
//
//  Created by xdrond on 21.12.2020.
//

import UIKit

protocol TranslationDelegate: AnyObject {
    func translationNeeded()
}

final class TranslateCoordinator {

    // MARK: - Private Properties
    private var dataProvider: ITranslateProvider
    private let presenter: UINavigationController

    // TODO: Подумать над опциональностью, часто приходится раскрывать.
    private var translateView: TranslateUIViewController?
    private var pair: TranslationPair?
    private var pairID: UUID?

    // MARK: - Private methods
    /**
     Отдаёт пару по ID от координатора выше по иерархии.
     Если координатор при создании не получил ID свыше,
     метод создаст пустую пару Ru-En.
     */
    private func getPair(uuid: UUID?) -> TranslationPair {
        if let uuid = uuid {
            if let pair = self.dataProvider.getPair(uuid: uuid) { return pair }
        }
        let newPair = TranslationPair(sourceText: "",
                                      sourceLanguage: .ru,
                                      destinationLanguage: .en,
                                      destinationText: nil)
        return newPair
    }

    // MARK: - Initializers
    init(dataProvider: ITranslateProvider,
         presenter: UINavigationController,
         pairID: UUID? = nil) {
        self.dataProvider = dataProvider
        self.presenter = presenter
        self.pairID = pairID
    }
}

// MARK: - Coordinator
extension TranslateCoordinator: Coordinator {
    func start() {
        self.dataProvider.delegate = self

        let pair = self.getPair(uuid: self.pairID)
        self.pair = pair
        let translateView = TranslateUIViewController(sourceLanguage: pair.sourceLanguage?.rawValue,
                                                      destinationLanguage: pair.destinationLanguage.rawValue,
                                                      sourceText: pair.sourceText,
                                                      destinationText: pair.destinationText)
        translateView.translationDelegate = self

        self.presenter.pushViewController(translateView, animated: true)
        self.translateView = translateView
    }
}

// MARK: - TranslateProviderDelegate
extension TranslateCoordinator: TranslateProviderDelegate {
    func translateRetrieved(pair: TranslationPair) {
        guard let oldPair = self.pair else { return }
        guard let translateView = self.translateView else { return }
        translateView.sourceLanguage = oldPair.sourceLanguage?.rawValue
        translateView.destinationLanguage = oldPair.destinationLanguage.rawValue
        translateView.sourceText = oldPair.sourceText
        translateView.destinationText = oldPair.destinationText

        self.pair = pair
    }
}

// MARK: - TranslationDelegate
extension TranslateCoordinator: TranslationDelegate {
    func translationNeeded() {
        guard let newText = self.translateView?.sourceText else { return }
        guard let oldPair = self.pair else { return }
        oldPair.sourceText = newText
        self.dataProvider.addPair(pair: oldPair)
    }
}
