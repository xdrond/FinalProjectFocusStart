//
//  TranslateUIView.swift
//  Translative
//
//  Created by xdrond on 21.12.2020.
//

import UIKit

protocol ITranslateUIView: AnyObject {
    var textViewDelegate: UITextViewDelegate? { get set }

    var sourceText: String? { get }
    var destinationText: String? { get set }
}

final class TranslateUIView: UIView {

    // MARK: - Public properties
    weak var textViewDelegate: UITextViewDelegate? {
        didSet { self.topTextview.delegate = self.textViewDelegate }
    }

    // MARK: - Private properties
    private lazy var topTextview = UITextView()
    // TODO: Вероятно, стоит заменить на UILabel
    private lazy var bottomTextView = UITextView()

    // MARK: - Layout constraints
    private lazy var topTextViewConstraints = [
        self.topTextview.topAnchor.constraint(equalTo: safeArea.topAnchor,
                                                 constant: Layout.textViewsOffset),
        self.topTextview.leftAnchor.constraint(equalTo: safeArea.leftAnchor,
                                                  constant: Layout.textViewsOffset),
        self.topTextview.rightAnchor.constraint(equalTo: safeArea.rightAnchor,
                                                   constant: -Layout.textViewsOffset),
        self.topTextview.heightAnchor.constraint(equalTo: safeArea.heightAnchor,
                                                    multiplier: Layout.textViewHeightRelation)
    ]

    private lazy var bottomTextViewConstraints = [
        self.bottomTextView.topAnchor.constraint(equalTo: self.topTextview.bottomAnchor,
                                                      constant: Layout.textViewsOffset),
        self.bottomTextView.leftAnchor.constraint(equalTo: safeArea.leftAnchor,
                                                       constant: Layout.textViewsOffset),
        self.bottomTextView.rightAnchor.constraint(equalTo: safeArea.rightAnchor,
                                                        constant: -Layout.textViewsOffset),
        self.bottomTextView.heightAnchor.constraint(equalTo: safeArea.heightAnchor,
                                                         multiplier: Layout.textViewHeightRelation)
    ]

    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()

        self.setupLayout()
        self.setupAppearance()
        //self.setupNotificationCenter()
    }

}

extension TranslateUIView: ITranslateUIView {

    var sourceText: String? { self.topTextview.text }

    var destinationText: String? {
        get { self.bottomTextView.text }
        set { self.bottomTextView.text = newValue }
    }

}

// MARK: - Layout
private extension TranslateUIView {

    enum Layout {
        static let textViewsOffset: CGFloat = 16.0
        static let textViewHeightRelation: CGFloat = 0.24
    }

    var safeArea: UILayoutGuide { self.safeAreaLayoutGuide }

    func addSubviewWithoutTAMIC(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
    }

    func setupLayout() {
        self.topTextViewLayout(view: self.topTextview)
        self.bottomTextViewLayout(view: self.bottomTextView)
    }

    func topTextViewLayout(view: UIView) {
        self.addSubviewWithoutTAMIC(view)
        NSLayoutConstraint.activate(self.topTextViewConstraints)
    }

    func bottomTextViewLayout(view: UIView) {
        self.addSubviewWithoutTAMIC(view)
        NSLayoutConstraint.activate(self.bottomTextViewConstraints)
    }

}

// MARK: - Appearance
private extension TranslateUIView {

    enum Appearance {
        static let roundingRadius: CGFloat = 8.0
        static let fontSize: CGFloat = 16.0
    }

    func setupAppearance() {
        self.setupViewAppearance()

        self.topTextViewAppearance(textView: self.topTextview)
        self.bottomTextViewAppearance(textView: self.bottomTextView)
        // TODO: Temp text content in views:
        topTextview.text = "Привет"
        bottomTextView.text = "Hello"
    }

    func setupViewAppearance() {
        self.backgroundColor = .systemBackground
    }

    func topTextViewAppearance(textView: UITextView) {
        textView.backgroundColor = .systemGray

        textView.textColor = .systemGray6
        textView.font = .systemFont(ofSize: Appearance.fontSize)

        textView.layer.cornerRadius = Appearance.roundingRadius
        textView.clipsToBounds = true

    }

    func bottomTextViewAppearance(textView: UITextView) {
        textView.backgroundColor = .systemGray6

        textView.isEditable = false
        textView.textColor = .systemGray
        textView.font = .systemFont(ofSize: Appearance.fontSize)

        textView.layer.cornerRadius = Appearance.roundingRadius
        textView.clipsToBounds = true
    }

}
