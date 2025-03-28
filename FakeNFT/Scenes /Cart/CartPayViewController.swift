//
//  CartPayViewController.swift
//  FakeNFT
//
//  Created by Diliara Sadrieva on 25.03.2025.
//
import UIKit
import ProgressHUD
import Kingfisher

protocol CartPayViewControllerProtocol: AnyObject {
    var presenter: CartPayPresenterProtocol? { get set }
    var visibleCurrencies: [Currencies] { get set }
    func updateTable()
}

final class CartPayViewController: UIViewController & CartPayViewControllerProtocol {
    var presenter: CartPayPresenterProtocol? = CartPayPresenter(networkClient: DefaultNetworkClient())
    var num = 1
    var visibleCurrencies: [Currencies] = []
    private let navigationLabel: UILabel = {
        let label = UILabel()
        label.text = "Выберите способ оплаты"
        label.textColor = .blackDayText
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    private let currenciesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.allowsMultipleSelection = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CustomCellCollectionViewCart.self, forCellWithReuseIdentifier: CustomCellCollectionViewCart.reuseIdentifier)
        return collectionView
    }()
    private let payView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .segmentInactive
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 12
        return view
    }()
    private let payButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Cart.payPage.payButton", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = UIColor(named: "blackDayNight")
        button.layer.cornerRadius = 16
        button.setTitleColor(.backgroundColor, for: .normal)
        button.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
        return button
    }()
    private let agreementLabel: UILabel = {
        let label = UILabel()
        label.text = "Совершая покупку, вы соглашаетесь с условиями"
        label.textColor = .blackDayText
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    private let linkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Пользовательского соглашения", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        button.setTitleColor(.blueUniversal, for: .normal)
        button.addTarget(self, action: #selector(openWebView), for: .touchUpInside)
        return button
    }()
    
    @objc private func openWebView() {
        guard let url = URL(string: "https://yandex.ru/legal/practicum_termsofuse/") else { return }
        let webViewVC = WebViewController()
        webViewVC.loadURL(url)
        present(webViewVC, animated: true)
    }
    
    @objc private func cancelPay() {
        if ProgressHUD.areAnimationsEnabled {
            ProgressHUD.dismiss()
        }
        dismiss(animated: true)
    }
    
    @objc private func payButtonTapped() {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureConstraits()
        presenter?.view = self
        fetchCurrency()
    }
    
    func updateTable() {
        currenciesCollectionView.reloadData()
    }
    
    private func fetchCurrency() {
        ProgressHUD.show()
        presenter?.getCurrencies { [weak self] items in
            guard let self = self else { return }
            switch items {
            case .success(let currencies):
                self.visibleCurrencies = currencies
            case .failure(let error):
                print(error)
            }
            updateTable()
            ProgressHUD.dismiss()
        }
    }
    
    private func configureView() {
        view.backgroundColor = .backgroundColor
        navigationItem.titleView = navigationLabel
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "BackButtonCart"), style: .plain, target: self, action: #selector(cancelPay))
        navigationItem.leftBarButtonItem?.tintColor = .blackDayText
        [currenciesCollectionView, payView].forEach {
            view.addSubview($0)
        }
        [agreementLabel,
         linkButton,
         payButton].forEach {
            payView.addSubview($0)
        }
        currenciesCollectionView.delegate = self
        currenciesCollectionView.dataSource = self
    }
    
    private func configureConstraits() {
        NSLayoutConstraint.activate([
            currenciesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            currenciesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            currenciesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            currenciesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            payView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            payView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            payView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            agreementLabel.leadingAnchor.constraint(equalTo: payView.leadingAnchor, constant: 16),
            agreementLabel.topAnchor.constraint(equalTo: payView.topAnchor, constant: 16),
            linkButton.leadingAnchor.constraint(equalTo: payView.leadingAnchor, constant: 16),
            linkButton.topAnchor.constraint(equalTo: agreementLabel.bottomAnchor),
            
            payButton.leadingAnchor.constraint(equalTo: payView.leadingAnchor, constant: 20),
            payButton.trailingAnchor.constraint(equalTo: payView.trailingAnchor, constant: -12),
            payButton.topAnchor.constraint(equalTo: linkButton.bottomAnchor, constant: 16),
            payButton.bottomAnchor.constraint(equalTo: payView.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            payButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

extension CartPayViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCurrencies.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCellCollectionViewCart.reuseIdentifier, for: indexPath) as? CustomCellCollectionViewCart else { return UICollectionViewCell()}
        let data = visibleCurrencies[indexPath.row]
        let url = URL(string: data.image)
        cell.imageViews.kf.setImage(with: url)
        cell.initCell(currencyLabel: data.name, titleLabel: data.title)
        return cell
    }
}

extension CartPayViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CustomCellCollectionViewCart {
            cell.layer.borderWidth = 1
            let color: UIColor = .blackDayText
            cell.layer.cornerRadius = 12
            cell.layer.borderColor = color.cgColor
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CustomCellCollectionViewCart {
            cell.layer.borderWidth = 0
            let color: UIColor = .blackDayText
            cell.layer.cornerRadius = 12
            cell.layer.borderColor = color.cgColor
        }
    }
}

extension CartPayViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let indentFromView: CGFloat = 16
        let indentBetweenCells: CGFloat = 7
        let width = (collectionView.bounds.width - indentBetweenCells - (indentFromView * 2)) / 2
        let height: CGFloat = 46
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}
