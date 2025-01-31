import UIKit
import SnapKit

final public class DutchPayTableViewCell: UITableViewCell {
    static let identifier = "DutchPayTableViewCell"
    
    // MARK: - UI Components
    private let initialsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.systemBlue.cgColor
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .right
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .right
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 1
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
        [initialsLabel, nameLabel, amountLabel, statusLabel, messageLabel].forEach {
            contentView.addSubview($0)
        }
        
        initialsLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(30) // 원형이 되도록 너비와 높이를 동일하게 설정
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(initialsLabel.snp.trailing).offset(12)
            $0.top.equalToSuperview().offset(12)
        }
        
        amountLabel.snp.makeConstraints {
            $0.trailing.equalTo(statusLabel.snp.leading).offset(-12)
            $0.centerY.equalToSuperview()
        }
        
        statusLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(50)
        }
        
        messageLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel)
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.trailing.equalTo(amountLabel.snp.leading).offset(-8)
            $0.bottom.equalToSuperview().offset(-12)
        }
    }
    
    // MARK: - Configuration
    func configure(with participant: DutchParticipantModel) {
        initialsLabel.text = String(participant.name.prefix(1))
        nameLabel.text = participant.name
        amountLabel.text = "\(participant.amount.formattedWithComma)원"
        statusLabel.text = participant.status.rawValue
        statusLabel.textColor = participant.status == .completed ? .black : .systemBlue
        messageLabel.text = participant.message
    }
}

// MARK: - Helper
extension Int {
    var formattedWithComma: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
} 
