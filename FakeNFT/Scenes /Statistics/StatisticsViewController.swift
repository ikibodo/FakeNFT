//
//  StatisticsViewController.swift
//  FakeNFT
//
//  Created by N L on 20.3.25..
//
import UIKit

final class StatisticsViewController: UIViewController {
    private let servicesAssembly: ServicesAssembly
    
    private let statisticsUserService = StatisticsUserService()
    private var users: [StatisticsUser] = []
    private var currentSortCriteria: SortCriteria = .rating
    
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
        loadUserStatistics()
        applySavedSorting()
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
    
    private func loadUserStatistics() {
        statisticsUserService.fetchUsers { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    self?.users = users
                    self?.applySavedSorting()
                    self?.sortUsers()
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Ошибка загрузки пользователей: \(error.localizedDescription)")
                }
            }
        }
    }

    func applySavedSorting() {
            currentSortCriteria = UserDefaultsManager.shared.loadSortCriteria()
            sortUsers()
        }

        func sortUsers() {
            switch currentSortCriteria {
            case .name:
                users.sort {
                    $0.name.trimmingCharacters(in: .whitespacesAndNewlines)
                    < $1.name.trimmingCharacters(in: .whitespacesAndNewlines)
                }
            case .rating:
                users.sort {
                    (Double($0.rating) ?? -Double.greatestFiniteMagnitude) >
                    (Double($1.rating) ?? -Double.greatestFiniteMagnitude)
                }
            }
        }

    @objc private func didSortButtonTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        
        let sortByNameAction = UIAlertAction(title: "По имени", style: .default) { [weak self] _ in
            self?.currentSortCriteria = .name
            self?.sortUsers()
            self?.tableView.reloadData()
            UserDefaultsManager.shared.saveSortCriteria(.name)
        }
        
        let sortByRatingAction = UIAlertAction(title: "По рейтингу", style: .default) { [weak self] _ in
            self?.currentSortCriteria = .rating
            self?.sortUsers()
            self?.tableView.reloadData()
            UserDefaultsManager.shared.saveSortCriteria(.rating)
        }
        
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel)
        
        alertController.addAction(sortByNameAction)
        alertController.addAction(sortByRatingAction)
        alertController.addAction(cancelAction)
        
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
