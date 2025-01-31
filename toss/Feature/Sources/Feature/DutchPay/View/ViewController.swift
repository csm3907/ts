//
//  ViewController.swift
//  Feature
//
//  Created by 최승민 on 1/31/25.
//

import UIKit
import SnapKit
import Combine

public class ViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: DutchPayViewModel = .init()
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: DutchPayDataSource!
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(DutchPayTableViewCell.self, forCellReuseIdentifier: DutchPayTableViewCell.identifier)
        table.register(DutchPayHeaderCell.self, forCellReuseIdentifier: DutchPayHeaderCell.identifier)
        return table
    }()
    
    // MARK: - Enum & Model
    enum Section {
        case header
        case main
    }
    
    // MARK: - Initialization
    public init() {
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
    
    // MARK: - Binding
    private func bind() {
        // Error 바인딩
        viewModel.error
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                self?.showAlert(message: errorMessage)
            }
            .store(in: &cancellables)
            
        // Snapshot 바인딩
        viewModel.snapshot
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] snapshot in
                self?.applySnapshot(snapshot)
            }
            .store(in: &cancellables)
    }
    
    private func applySnapshot(_ snapshot: DutchPaySnapshot) {
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - Private Methods
    private func configureDataSource() {
        dataSource = DutchPayDataSource(
            tableView: tableView,
            cellProvider: { [weak self] tableView, indexPath, item in
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
                    cell.configure(with: participant)
                    return cell
                }
            }
        )
        
        var snapshot = DutchPaySnapshot()
        snapshot.appendSections([.header, .main])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: "오류",
            message: message,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(
            title: "확인",
            style: .default
        )
        
        alert.addAction(okAction)
        present(alert, animated: true)
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
}
