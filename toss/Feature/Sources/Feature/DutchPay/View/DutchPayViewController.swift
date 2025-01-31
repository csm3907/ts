//
//  DutchPayViewController.swift
//  Feature
//
//  Created by 최승민 on 1/31/25.
//

import Combine
import UIKit
import SnapKit

import Design

public class DutchPayViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: DutchPayViewModel
    private var dataSource: DutchPayDataSource!
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return refresh
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(DutchPayTableViewCell.self, forCellReuseIdentifier: DutchPayTableViewCell.identifier)
        table.register(DutchPayHeaderCell.self, forCellReuseIdentifier: DutchPayHeaderCell.identifier)
        table.refreshControl = refreshControl
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
            cellProvider: { [weak self] tableView, indexPath, item in
                guard let self else { return UITableViewCell() }
                switch item {
                case .header(let headerItem):
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: DutchPayHeaderCell.identifier,
                        for: indexPath
                    ) as? DutchPayHeaderCell else {
                        return UITableViewCell()
                    }
                    
                    let date = DateFormatter().date(from: headerItem.date) ?? Date()
                    cell.configure(
                        date: date,
                        completedAmount: headerItem.completedAmount,
                        totalAmount: headerItem.totalAmount,
                        message: headerItem.message
                    )
                    return cell
                    
                case .participant(let participant):
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: DutchPayTableViewCell.identifier,
                        for: indexPath
                    ) as? DutchPayTableViewCell else {
                        return UITableViewCell()
                    }
                    cell.configure(with: participant) { [weak self] in
                        guard let self else { return }
                        self.viewModel.requestPaymentDone(for: participant.id)
                    }
                    cell.statusLabel.touchPublisher
                        .sink { _ in
                            self.viewModel.requestPayment(for: participant.id)
                        }
                        .store(in: &self.cancellables)
                    return cell
                }
            }
        )
    }
    
    // MARK: - Actions
    @objc private func handleRefresh() {
        viewModel.fetchDutchPayData()
    }
    
    private func bind() {
        // Error 바인딩
        viewModel.error
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                self?.refreshControl.endRefreshing()
                self?.alert(title: "문제가 발생했습니다.", message: errorMessage)
            }
            .store(in: &cancellables)
        
        // Snapshot 바인딩
        viewModel.snapshot
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] snapshot in
                self?.refreshControl.endRefreshing()
                self?.dataSource.apply(snapshot, animatingDifferences: false)
            }
            .store(in: &cancellables)
    }
}
