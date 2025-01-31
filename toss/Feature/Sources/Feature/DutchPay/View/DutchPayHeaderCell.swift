import UIKit
import SnapKit

final class DutchPayHeaderCell: UITableViewCell {
    static let identifier = "DutchPayHeaderCell"
    
    // MARK: - UI Components
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let amountStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        return stack
    }()
    
    private let completedAmountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let totalAmountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let messageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
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
        [dateLabel, amountStackView, messageContainerView].forEach {
            contentView.addSubview($0)
        }
        
        [completedAmountLabel, UILabel(text: "원 완료 / 총 "), totalAmountLabel, UILabel(text: "원")].forEach {
            amountStackView.addArrangedSubview($0)
        }
        
        messageContainerView.addSubview(messageLabel)
        
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        amountStackView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
        }
        
        messageContainerView.snp.makeConstraints {
            $0.top.equalTo(amountStackView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        messageLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }
    }
    
    // MARK: - Configuration
    func configure(date: Date, completedAmount: Int, totalAmount: Int, message: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일 HH:mm"
        dateLabel.text = dateFormatter.string(from: date)
        
        completedAmountLabel.text = "\(completedAmount.formattedWithComma)"
        totalAmountLabel.text = "\(totalAmount.formattedWithComma)"
        messageLabel.text = message
    }
}

private extension UILabel {
    convenience init(text: String) {
        self.init()
        self.text = text
        self.font = .systemFont(ofSize: 20, weight: .bold)
    }
} 
