//
//  Untitled.swift
//  FakeNFT
//
//  Created by N L on 25.3.25..
//
import UIKit

final class StatisticsUserCollectionViewController: UIViewController, StatisticsUserCollectionProtocol {
    private let presenter: StatisticsUserCollectionPresenter?
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .segmentActive
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .segmentActive
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textAlignment = .left
        label.text = NSLocalizedString("Collection.Nft", comment: "")
        return label
    }()
    
    init(presenter: StatisticsUserCollectionPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter?.attachView(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
    }
    
    func showError(_ message: String) {
        print(message)
    }
    
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        guard (navigationController?.navigationBar) != nil else { return }
        navigationItem.titleView = titleLabel
        let buttonContainer = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        buttonContainer.addSubview(backButton)
        backButton.frame = buttonContainer.bounds
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
