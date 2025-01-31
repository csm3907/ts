//
//  DutchPayCommercialCell.swift
//  Feature
//
//  Created by 최승민 on 1/31/25.
//

import UIKit
import SnapKit

final class DutchPayCommercialCell: UITableViewCell {
    static let identifier = "DutchPayCommercialCell"
    
    private let messageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "토스 공동계좌를 개설해 보세요"
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        contentView.addSubview(messageContainerView)
        messageContainerView.addSubview(messageLabel)
        
        messageContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        
        messageLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }
    }
}

private extension UILabel {
    convenience init(text: String) {
        self.init()
        self.text = text
        self.font = .systemFont(ofSize: 20, weight: .bold)
    }
}
