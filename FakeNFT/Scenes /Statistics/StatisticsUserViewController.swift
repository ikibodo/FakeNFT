//
//  Untitled.swift
//  FakeNFT
//
//  Created by N L on 22.3.25..
//
import UIKit

final class StatisticsUserViewController: UIViewController, StatisticsUserViewProtocol {
    private var presenter: StatisticsUserPresenter?
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .segmentActive
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()
    
    init(presenter: StatisticsUserPresenter) {
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
        presenter?.loadUserData()
    }
    
    func updateUserInfo(_ user: StatisticsUser) {
        // TODO
    }
    
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        guard (navigationController?.navigationBar) != nil else { return }
        
        let buttonContainer = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        buttonContainer.addSubview(button)
        button.frame = buttonContainer.bounds
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    @objc private func didTapButton() {
        navigationController?.popViewController(animated: true)
    }
}
