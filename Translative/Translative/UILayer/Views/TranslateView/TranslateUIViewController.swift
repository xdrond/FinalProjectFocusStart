//
//  TranslateUIViewController.swift
//  Translative
//
//  Created by xdrond on 21.12.2020.
//

import UIKit

@objc protocol SwitchingLanguageDelegate: AnyObject {
    func inputModeDidChange(_ notification: Notification)
}

final class TranslateUIViewController: UIViewController {

    // MARK: - Public properties
    // TODO: Возможно стоит хранить здесь экземпляр типа TranslationPair,
    // потому что часто таскаются данные модели между вью и презентором,
    // а разбираются на составляющие только здесь.
    var sourceLanguage: String? {
        didSet { self.setupNavigationBar() }
    }
    var destinationLanguage: String {
        didSet { self.setupNavigationBar() }
    }

    var sourceText: String?
    var destinationText: String? {
        didSet { self.translateView?.destinationText = self.destinationText }
    }

    weak var translationDelegate: TranslationDelegate?

    // MARK: - Private properties
    private lazy var translateView: ITranslateUIView? = TranslateUIView()
    private var requestTimer: Timer?

    private var primaryLang: String? = "ru-RU"
    private var isFirstEditing: Bool = true

    // MARK: - Initializer
    init(sourceLanguage: String? = nil,
         destinationLanguage: String,
         sourceText: String,
         destinationText: String? = nil) {

        self.sourceLanguage = sourceLanguage
        self.destinationLanguage = destinationLanguage
        self.sourceText = sourceText
        self.destinationText = destinationText

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func loadView() {
        self.translateView?.textViewDelegate = self
        self.translateView?.switchingLanguageDelegate = self
        self.view = (self.translateView as? UIView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.view.backgroundColor = .white
    }

}

// MARK: - Appearance
private extension TranslateUIViewController {

    func setupNavigationBar() {
        if let sourceLanguage = self.sourceLanguage {
            self.navigationItem.title = "\(sourceLanguage.capitalized) - \(self.destinationLanguage.capitalized)"
        } else {
            self.navigationItem.title = " \(self.destinationLanguage.capitalized) "
        }
    }

}

// MARK: - UITextViewDelegate
extension TranslateUIViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        self.sourceText = textView.text

        self.requestTimer?.invalidate()
        self.requestTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            // TODO: Стоит добавить визуальное отображение процесса загрузки.
            self.translationDelegate?.translationNeeded()
        })
    }

}

// MARK: -
extension TranslateUIViewController: SwitchingLanguageDelegate {

    @objc func inputModeDidChange(_ notification: Notification) {
        print("Пришло уведомление \(notification)")
        guard let userInfo = notification.userInfo?["UITextInputFromInputModeKey"] as? UITextInputMode else { return }
        guard let lang = userInfo.primaryLanguage else { return }

        print("Старый язык \(lang), новый язык \(self.primaryLang!)")
//        if !self.isFirstEditing {
//            self.layoutIfNeeded()
//            UIView.animate(withDuration: 0.4,
//                           delay: 0.0,
//                           options: [.curveEaseInOut, .allowUserInteraction],
//                           animations: {
//                            swap(&self.topTextview.text, &self.bottomTextView.text)
//                            swap(&self.topTextview.backgroundColor, &self.bottomTextView.backgroundColor)
//                            self.layoutIfNeeded()
//                           },
//                           completion: nil)
//        }
        self.primaryLang = lang
        if self.isFirstEditing { self.isFirstEditing = false }
    }

}
