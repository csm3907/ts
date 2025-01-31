//
//  ViewController.swift
//  Feature
//
//  Created by 최승민 on 1/31/25.
//

import Combine
import UIKit
import SnapKit

public class ViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: DutchPayViewModel
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: DutchPayDataSource!
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(DutchPayTableViewCell.self, forCellReuseIdentifier: DutchPayTableViewCell.identifier)
        table.register(DutchPayHeaderCell.self, forCellReuseIdentifier: DutchPayHeaderCell.identifier)
        return table
    }()
    
    // MARK: - Initialization
    public init() {
        self.viewModel = DutchPayViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureDataSource()
        applyInitialSnapshot()
        bind()
        
        viewModel.fetchDutchPayData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "더치페이"
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.remakeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureDataSource() {
        dataSource = DutchPayDataSource(
            tableView: tableView,
            cellProvider: { /*[weak self] */ tableView, indexPath, item in
                switch item {
                case .header(_): // Header Section
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: DutchPayHeaderCell.identifier,
                        for: indexPath
                    ) as? DutchPayHeaderCell else {
                        return UITableViewCell()
                    }
                    
                    cell.configure(
                        date: Date(timeIntervalSince1970: 1554513840),
                        completedAmount: 158000,
                        totalAmount: 220000,
                        message: "김철수: 💸💸👍👍👻👻👻 우리 오늘 모임 즐거웠다~~~ 돈 다 나에게도 주즈아~~"
                    )
                    return cell
                    
                case .participant(let participant): // Main Section
                    guard let cell = tableView.dequeueReusableCell(
                            withIdentifier: DutchPayTableViewCell.identifier,
                            for: indexPath
                          ) as? DutchPayTableViewCell else {
                        return UITableViewCell()
                    }
                    cell.configure(with: participant)
                    return cell
                }
            }
        )
    }
    
    private func applyInitialSnapshot() {
        var snapshot = DutchPaySnapshot()
        snapshot.appendSections([.header, .main])
        snapshot.appendItems([.header(DutchPayHeaderInfo())], toSection: .header)
        
        let participants = [
            DutchPayParticipant(name: "김철수", amount: 32500, status: .completed, message: nil),
            DutchPayParticipant(name: "김진규", amount: 32500, status: .completed, message: "🔫🔫🔫"),
            DutchPayParticipant(name: "이예성", amount: 20000, status: .requested, message: nil),
            DutchPayParticipant(name: "강남구", amount: 10000, status: .completed, message: nil),
            DutchPayParticipant(name: "이영희", amount: 20000, status: .requested, message: nil),
            DutchPayParticipant(name: "박민철", amount: 10000, status: .completed, message: "오늘 정말 즐거웠어요. 맛있는 식사였습니다. 감사...")
        ]
        
        snapshot.appendItems(participants.map{ DutchPayItem.participant($0)}, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func bind() {
        
    }
}
