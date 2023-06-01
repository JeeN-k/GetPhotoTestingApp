//
//  UIView+ErrorAlert.swift
//  GetPhotoTestingApp
//
//  Created by Oleg Stepanov on 31.05.2023.
//

import UIKit

extension UIViewController {
    func showAlertWith(text: String, type: AlertType) {
        let alert = AlertController()
        alert.modalTransitionStyle = .crossDissolve
        alert.modalPresentationStyle = .overCurrentContext
        alert.setup(with: text, type: type)
        present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            alert.dismiss(animated: true)
        }
    }
}

enum AlertType {
    case positive, negative, warning
}

final class AlertController: UIViewController {
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        return view
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray.withAlphaComponent(0.1)
        containerView.backgroundColor = .gray.withAlphaComponent(0.8)
        configureConstraints()
    }
    
    public func setup(with text: String, type: AlertType) {
        let image: UIImage?
        let tintColor: UIColor
        switch type {
        case .negative:
            image = UIImage(named: "x.square")
            tintColor = .red
        case .positive:
            image = UIImage(named: "checkmark.square")
            tintColor = .green
        case .warning:
            image = UIImage(named: "exclamationmark.square")
            tintColor = .yellow
        }
        imageView.image = image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = tintColor
        label.text = text
    }
    
    private func configureConstraints() {
        view.addSubview(containerView)
        containerView.addSubviews([label, imageView])
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            label.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            
            imageView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            imageView.widthAnchor.constraint(equalToConstant: 25),
            imageView.heightAnchor.constraint(equalToConstant: 25),
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])
    }
}
 
