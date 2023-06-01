//
//  PhotoViewController.swift
//  GetPhotoTestingApp
//
//  Created by Oleg Stepanov on 30.05.2023.
//

import UIKit

class PhotoViewController: UIViewController {

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .gray.withAlphaComponent(0.1)
        textField.clearButtonMode = .whileEditing
        textField.autocorrectionType = .no
        textField.placeholder = "Текст"
        textField.addTarget(self, action: #selector(didTextChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Generate image", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.5), for: .disabled)
        button.backgroundColor = .blue.withAlphaComponent(0.5)
        button.layer.cornerRadius = 8
        button.isEnabled = false
        button.addTarget(self, action: #selector(didTapSubmitButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add to favorites", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.5), for: .disabled)
        button.backgroundColor = .red.withAlphaComponent(0.5)
        button.layer.cornerRadius = 8
        button.isEnabled = false
        button.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchUpInside)
        return button
    }()
    
    var viewModel: PhotoViewModelProtocol
    
    init(viewModel: PhotoViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        textField.becomeFirstResponder()
    }
    
    @objc
    private func didTextChanged() {
        guard let text = textField.text else {
            submitButton.isEnabled = false
            return
        }
        submitButton.isEnabled = !text.isEmpty
    }
    
    @objc
    private func didTapSubmitButton() {
        guard let text = textField.text, text != viewModel.imageModel?.query  else { return }
        let textWOSpaces = text.replacingOccurrences(of: " ", with: "")
        setLoading(true)
        viewModel.fetchImage(imagePromt: textWOSpaces)
    }
    
    @objc
    private func didTapFavoriteButton() {
        guard let text = textField.text else { return }
        viewModel.saveToFavorite(query: text)
    }
}

extension PhotoViewController: PhotoViewInputProtocol {
    func setImage(withData data: Data?) {
        setLoading(false)
        guard let data else { return }
        favoriteButton.isEnabled = true
        imageView.image = UIImage(data: data)
    }
    
    func setError(withText text: String, type: AlertType) {
        setLoading(false)
        textField.text = ""
        submitButton.isEnabled = false
        showAlertWith(text: text, type: type)
    }
    
    func photoDidSaved() {
        showAlertWith(text: "Фотография добавлена в избранное", type: .positive)
    }
}

extension PhotoViewController {
    private func configureView() {
        view.backgroundColor = .white
        view.addSubviews([imageView, textField, submitButton, favoriteButton])
        navigationItem.title = "Generate photo"
        configureConstraints()
        setAccessibilities()
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            
            textField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            submitButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            submitButton.heightAnchor.constraint(equalToConstant: 44),
            
            favoriteButton.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 20),
            favoriteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            favoriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            favoriteButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setLoading(_ isLoading: Bool) {
        if isLoading {
            view.activityStartAnimating(backgroundColor: .black.withAlphaComponent(0.05))
        } else {
            view.activityStopAnimating()
        }
    }
    
    private func setAccessibilities() {
        textField.isAccessibilityElement = true
        textField.accessibilityIdentifier = "textField"
        textField.accessibilityValue = textField.text
        
        imageView.isAccessibilityElement = true
        imageView.accessibilityIdentifier = "imageView"
        imageView.accessibilityValue = "imageView"
        
        submitButton.isAccessibilityElement = true
        submitButton.accessibilityIdentifier = "submitButton"
        submitButton.accessibilityValue = "submitButton"
        
        favoriteButton.isAccessibilityElement = true
        favoriteButton.accessibilityIdentifier = "favoriteButton"
        favoriteButton.accessibilityValue = "favoriteButton"
    }
}
