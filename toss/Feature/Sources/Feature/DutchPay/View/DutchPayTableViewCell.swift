import UIKit
import SnapKit
import Design
import Core

final public class DutchPayTableViewCell: UITableViewCell {
    static let identifier = "DutchPayTableViewCell"
    
    // MARK: - UI Components
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        return stack
    }()
    
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
    
    let statusLabel: UILabel = {
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
    
    lazy var progressButton: ProgressButton = {
        let button = ProgressButton(duration: 10) {
            self.requestAction?()
        }
        button.isHidden = true
        return button
    }()
    
    private var requestAction: (() -> Void)?
    
    private var animationStartTime: Date?
    private let totalDuration: TimeInterval = 10.0
        
    
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
        contentView.addSubview(initialsLabel)
        contentView.addSubview(mainStackView)
        contentView.addSubview(amountLabel)
        
        mainStackView.addArrangedSubview(horizontalStackView)
        mainStackView.addArrangedSubview(messageLabel)
        
        horizontalStackView.addArrangedSubview(nameLabel)
        horizontalStackView.addArrangedSubview(statusLabel)
        horizontalStackView.addArrangedSubview(progressButton)
        
        initialsLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalTo(horizontalStackView)
            $0.width.height.equalTo(30)
        }
        
        mainStackView.snp.makeConstraints {
            $0.leading.equalTo(initialsLabel.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        statusLabel.snp.makeConstraints {
            $0.width.equalTo(60)
        }
          
        progressButton.snp.makeConstraints {
            $0.height.equalTo(statusLabel)
        }
        
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        amountLabel.setContentHuggingPriority(.required, for: .horizontal)
        amountLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        statusLabel.setContentHuggingPriority(.required, for: .horizontal)
        statusLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        amountLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-100)
            $0.centerY.equalTo(nameLabel.snp.centerY)
        }
    }
    
    // MARK: - Configuration
    func configure(with participant: DutchParticipantModel, requestAction: (() -> Void)? = nil) {
        initialsLabel.text = String(participant.name.prefix(1))
        nameLabel.text = participant.name
        amountLabel.text = "\(participant.amount.formattedWithComma)원"
        statusLabel.text = participant.status.rawValue
        statusLabel.textColor = participant.status == .completed ? .black : .systemBlue
        messageLabel.text = participant.message
        
        // 상태에 따라 버튼과 라벨 표시 전환
        switch participant.status {
        case .completed:
            statusLabel.isHidden = false
            progressButton.isHidden = true
            progressButton.cancel()
            animationStartTime = nil
        case .requesting:
            statusLabel.isHidden = true
            progressButton.isHidden = false
            if let startTime = animationStartTime {
                let elapsedTime = Date().timeIntervalSince(startTime)
                if elapsedTime < totalDuration {
                    let progress = elapsedTime / totalDuration
                    progressButton.animate(from: progress)
                } else {
                    self.requestAction?()
                }
            } else {
                animationStartTime = Date()
                progressButton.animate(from: 0)
            }
        case .requested, .reRequest:
            statusLabel.isHidden = false
            progressButton.isHidden = true
            progressButton.cancel()
            animationStartTime = nil
        }
        self.requestAction = requestAction
    }
    
    // MARK: - Actions
    private func requestButtonTapped() {
        requestAction?()
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        progressButton.cancel()
        animationStartTime = nil
    }
}
