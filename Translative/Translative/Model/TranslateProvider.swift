//
//  TranslateProvider.swift
//  Translative
//
//  Created by xdrond on 21.12.2020.
//

import Foundation.NSUUID

protocol ITranslateProvider {
    var delegate: TranslateProviderDelegate? { get set }
    func addPair(pair: TranslationPair)

    func getPair(uuid: UUID) -> TranslationPair?
}

protocol TranslateProviderDelegate: AnyObject {
    func translateRetrieved(pair: TranslationPair)
}

final class TranslateProvider {

    // MARK: - Public Properties
    static var shared: TranslateProvider = { return TranslateProvider() }()

    weak var delegate: TranslateProviderDelegate?

    // MARK: - Private Properties
    private var cashedPairs: [UUID: TranslationPair] = [:]

    private let networkManager = NetworkManager()

    // MARK: - Private methods
    private func getNewTranslation(pair: TranslationPair) {
        self.networkManager.getTranslation(quote: pair.sourceText,
                                           source: pair.sourceLanguage,
                                           target: pair.destinationLanguage) { translation, error in
            if let error = error {
                assertionFailure("Network error: \(error)")
                return
            }
            guard let translatedText = translation?.translatedText else { return }
            pair.destinationText = translatedText
            DispatchQueue.main.async {
                self.delegate?.translateRetrieved(pair: pair)
            }
        }
    }

    // MARK: - Private initializer
    private init() {}
}

extension TranslateProvider: ITranslateProvider {
    // TODO: Возможно не очень подходящее название для метода.
    // MARK: - Public methods
    func addPair(pair: TranslationPair) {

        if let cashedPair = self.cashedPairs[pair.uuid] {
            if cashedPair.destinationText != nil {
                // TODO: Кэширование сейчас не работает
                self.delegate?.translateRetrieved(pair: cashedPair)
                return
            }
        } else {
            self.cashedPairs[pair.uuid] = pair
            self.getNewTranslation(pair: pair)
        }
    }

    func getPair(uuid: UUID) -> TranslationPair? {
        if let cashedPair = self.cashedPairs[uuid] {
            return cashedPair
        } else {
            return nil
        }
    }

}
