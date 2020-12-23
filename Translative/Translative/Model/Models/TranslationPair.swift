//
//  TranslationPair.swift
//  Translative
//
//  Created by xdrond on 21.12.2020.
//

import Foundation

final class TranslationPair {

    private(set) var uuid = UUID()

    let sourceLanguage: Language?
    var sourceText: String {
        willSet {
            if self.sourceText != newValue {
                self.uuid = UUID()
            }
        }
    }

    let destinationLanguage: Language
    var destinationText: String?

    init(sourceText: String,
         sourceLanguage: Language? = nil,
         destinationLanguage: Language,
         destinationText: String? = nil) {
        self.sourceLanguage = sourceLanguage
        self.sourceText = sourceText
        self.destinationLanguage = destinationLanguage
        self.destinationText = destinationText
    }
}

extension TranslationPair: Equatable {
    public static func == (lhs: TranslationPair, rhs: TranslationPair) -> Bool {
        if lhs.sourceText == rhs.sourceText,
           lhs.destinationLanguage == rhs.destinationLanguage,
           lhs.sourceLanguage == rhs.sourceLanguage {
            return true
        } else { return false }
    }
}
