//
//  MyNFT.swift
//  FakeNFT
//
//  Created by Aleksandr Dugaev on 16.03.2025.
//

import UIKit

enum SortType: Int {
    case rating = 0, price, name
}

protocol MyNFTControllerProtocol: AnyObject {
    func reloadNFTs()
    func showError(message: String)
    func showLoading(_ isLoading: Bool)
    func updateEmptyState(isHidden: Bool)
    func updateSortIndicator(isHidden: Bool)
}

final class MyNFTController: UIViewController {
    
    // MARK: - Public Properties
    weak var delegate: EditProfileControllerDelegate?
    
    // MARK: - Private Properties
    private lazy var backButton: UIBarButtonItem = {
        let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
        let button = UIBarButtonItem(image: UIImage(systemName: "chevron.backward", withConfiguration: boldConfig),
                                     style: .plain,
                                     target: self,
                                     action: #selector(modalCloseButtonTapped))
        button.tintColor = UIColor.black
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 140
        tableView.register(MyNFTCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var sortButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "sort"), for: .normal)
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        button.addSubview(sortIndicator)
        
        NSLayoutConstraint.activate([
            sortIndicator.widthAnchor.constraint(equalToConstant: 10),
            sortIndicator.heightAnchor.constraint(equalToConstant: 10),
            sortIndicator.topAnchor.constraint(equalTo: button.topAnchor, constant: 2),
            sortIndicator.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -2)
        ])
        
        return button
    }()
    
    private lazy var sortIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private lazy var sortBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(customView: sortButton)
    }()
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "У вас ещё нет NFT"
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private var currentSortType: SortType = .rating
    private var presenter: MyNFTPresenterProtocol?
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentSortType = presenter?.getCurrentSortType() ?? .rating
        setupUI()
        presenter?.loadNFTs()
    }
    
    // MARK: - Public Methods
    func setPresenter(_ presenter: MyNFTPresenterProtocol) {
        self.presenter = presenter
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = UIColor.white
        navigationItem.title = NSLocalizedString("Profile.MyNFT.title", comment: "Мои NFT")
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = sortBarButtonItem
        
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func showSortMenu() {
        let alertController = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        
        let sortByPrice = UIAlertAction(title: "По цене" + (currentSortType == .price ? " 🔹" : ""), style: .default) { _ in
            self.presenter?.sortNFTs(by: .price)
            self.currentSortType = .price
        }
        
        let sortByRating = UIAlertAction(title: "По рейтингу" + (currentSortType == .rating ? " 🔹" : ""), style: .default) { _ in
            self.presenter?.sortNFTs(by: .rating)
            self.currentSortType = .rating
        }
        
        let sortByName = UIAlertAction(title: "По названию" + (currentSortType == .name ? " 🔹" : ""), style: .default) { _ in
            self.presenter?.sortNFTs(by: .name)
            self.currentSortType = .name
        }
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel)
        
        [sortByPrice, sortByRating, sortByName, cancelAction].forEach { alertController.addAction($0) }
        
        present(alertController, animated: true)
    }
    
    // MARK: - Actions
    @objc private func modalCloseButtonTapped() {
        if presenter?.isLikeUpdated() == true {
            UIBlockingProgressHUD.show()
            delegate?.didUpdateProfile()
            presenter?.setLikeUpdated(false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.dismiss(animated: true)
            }
        } else {
            self.dismiss(animated: true)
        }
    }
    
    @objc private func sortButtonTapped() {
        print("Нажата кнопка сортировки")
        showSortMenu()
    }
}

// MARK: - UITableViewDataSource
extension MyNFTController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getNFTsCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyNFTCell = tableView.dequeueReusableCell()
        guard let nft = presenter?.getNFT(at: indexPath.row),
              let isLiked = presenter?.nftIsLiked(nft: nft)
        else { return cell }
        
        cell.configure(nft: nft, isLiked: isLiked)
        cell.delegate = self
        return cell
    }
}

// MARK: - UITableViewDataSource
extension MyNFTController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nft = presenter?.getNFT(at: indexPath.row)
        print("Выбран NFT \(String(describing: nft?.name)) с рейтингом \(String(describing: nft?.rating)) ⭐️")
    }
}

extension MyNFTController: MyNFTControllerProtocol {
    func reloadNFTs() {
        tableView.reloadData()
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }
    
    func showLoading(_ isLoading: Bool) {
        isLoading ? UIBlockingProgressHUD.show() : UIBlockingProgressHUD.dismiss()
    }
    
    func updateEmptyState(isHidden: Bool) {
        emptyLabel.isHidden = isHidden
        tableView.isHidden = !isHidden
    }
    
    func updateSortIndicator(isHidden: Bool) {
        sortIndicator.isHidden = isHidden
    }
}

extension MyNFTController: MyNFTCellDelegate {
    func didTaplikeButton(in cell: MyNFTCell, nftId: String) {
        presenter?.changeLike(nftId: nftId) { success in
            DispatchQueue.main.async {
                if success {
                    cell.updateLikeButton()
                } else {
                    self.showError(message: "Ошибка при изменении лайка")
                }
            }
        }
    }
}
