//
//  HomeTableHeaderViewCell.swift
//  Netplix
//
//  Created by Octo Siswardhono on 11/11/23.
//

import UIKit

class HomeTableHeaderViewCell: UITableViewHeaderFooterView {

    let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

}
