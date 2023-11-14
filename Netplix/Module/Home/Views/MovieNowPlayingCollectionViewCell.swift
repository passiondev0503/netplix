//
//  MovieNowPlayingCollectionViewCell.swift
//  Netplix
//
//  Created by Octo Siswardhono on 11/11/23.
//

import UIKit

class MovieNowPlayingCollectionViewCell: UICollectionViewCell {
    
    private lazy var containerView = setupContainerView()
    private lazy var hStackView = setupHStackView()
    private lazy var containerImageView = setupContainerImageView()
    private lazy var imageView = setupImageView()
    private lazy var vStackView = setupVStackView()
    private lazy var titleLabel = setupTitleLabel()
    private lazy var descLabel = setupDescLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with model: ResultNowPlaying) {
        titleLabel.text = model.title
        descLabel.text = model.overview
        imageView.setImage(with: model.backdropPath)
    }
}

private extension MovieNowPlayingCollectionViewCell {
    func setupViews() {
        self.backgroundColor = .white
        containerImageView.addSubview(imageView)
        vStackView.addArrangedSubview(titleLabel)
        vStackView.addArrangedSubview(descLabel)
        hStackView.addArrangedSubview(containerImageView)
        hStackView.addArrangedSubview(vStackView)
        containerView.addSubview(hStackView)
        addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            hStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            hStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            hStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            hStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            imageView.centerYAnchor.constraint(equalTo: hStackView.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: hStackView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: vStackView.leadingAnchor, constant: -8)
            
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
    
    func setupHStackView() -> UIStackView {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alignment = .fill
        sv.distribution = .fill
        sv.axis = .horizontal
        return sv
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
        sv.alignment = .fill
        sv.distribution = .fill
        sv.axis = .vertical
        return sv
    }
    
    func setupTitleLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 2
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }
    
    func setupDescLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 5
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        return label
    }
}
