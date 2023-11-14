//
//  MovieTopRatedCollectionViewCell.swift
//  Netplix
//
//  Created by Octo Siswardhono on 11/11/23.
//

import UIKit

class MovieTopRatedCollectionViewCell: UICollectionViewCell {
    private lazy var containerView = setupContainerView()
    private lazy var containerImageView = setupContainerImageView()
    private lazy var imageView = setupImageView()
    private lazy var vStackView = setupVStackView()
    private lazy var titleLabel = setupTitleLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with model: ResultTopRated) {
        titleLabel.text = model.title
        imageView.setImage(with: model.backdropPath)
    }
}

private extension MovieTopRatedCollectionViewCell {
    func setupViews() {
        self.backgroundColor = .white
        containerImageView.addSubview(imageView)
        vStackView.addArrangedSubview(titleLabel)
        vStackView.addArrangedSubview(containerImageView)

        containerView.addSubview(vStackView)
        addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            vStackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            vStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            vStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            vStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: containerImageView.topAnchor, constant: 16),
            imageView.widthAnchor.constraint(equalToConstant: 64),
            imageView.heightAnchor.constraint(equalToConstant: 64),
            imageView.centerXAnchor.constraint(equalTo: vStackView.centerXAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: vStackView.centerXAnchor)
        ])
    }
    
    func setupContainerView() -> UIView {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }
    
    func setupContainerImageView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    func setupImageView() -> UIImageView {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.setContentHuggingPriority(.required, for: .horizontal)
        iv.setContentHuggingPriority(.required, for: .vertical)
        return iv
    }
    
    func setupVStackView() -> UIStackView {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alignment = .fill
        sv.distribution = .fillEqually
        sv.axis = .vertical
        return sv
    }
    
    func setupTitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.textAlignment = .center
        return label
    }
}


