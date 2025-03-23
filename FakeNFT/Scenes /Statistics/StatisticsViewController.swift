//
//  StatisticsViewController.swift
//  FakeNFT
//
//  Created by N L on 20.3.25..
//
import UIKit

final class StatisticsViewController: UIViewController, StatisticsViewProtocol {
    private let servicesAssembly: ServicesAssembly
    private var presenter: StatisticsPresenter?
    private var users: [StatisticsUser] = []
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Sort"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didSortButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.tableHeaderView = UIView(frame: .zero)
        tableView.register(StatisticsCell.self, forCellReuseIdentifier: StatisticsCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
        self.presenter = StatisticsPresenter(view: self, statisticsUserService: servicesAssembly.statisticsUserService)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubViews()
        addConstraints()
        setupNavigationBar()
        presenter?.viewDidLoad()
    }
    
    func showUsers(_ users: [StatisticsUser]) {
        self.users = users
        tableView.reloadData()
    }
    
    func showError(_ message: String) {
        print(message)
    }
    
    private func addSubViews() {
        view.addSubview(tableView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        guard (navigationController?.navigationBar) != nil else { return }
        
        let buttonContainer = UIView(frame: CGRect(x: 0, y: 0, width: 42, height: 42))
        buttonContainer.addSubview(button)
        button.frame = buttonContainer.bounds
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    @objc private func didSortButtonTapped() {
        let alertController = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "По имени", style: .default) { _ in
            self.presenter?.didSelectSorting(criteria: .name)
        })
        alertController.addAction(UIAlertAction(title: "По рейтингу", style: .default) { _ in
            self.presenter?.didSelectSorting(criteria: .rating)
        })
        alertController.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
        present(alertController, animated: true)
    }
}

extension StatisticsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StatisticsCell.identifier, for: indexPath) as? StatisticsCell else { return UITableViewCell() }
        let user = users[indexPath.row]
        cell.configure(user, index: indexPath.row + 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        88
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedUser = users[indexPath.row]
        let userVC = StatisticsUserViewController()
        userVC.user = selectedUser
        userVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(userVC, animated: true)
    }
}
