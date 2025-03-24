//
//  Untitled.swift
//  FakeNFT
//
//  Created by N L on 24.3.25..
//
import UIKit
import WebKit

final class StatisticsWebViewController: UIViewController, StatisticsWebViewProtocol {
    private let presenter: StatisticsWebViewPresenter?
    private var progressObserver: NSKeyValueObservation?
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressViewStyle = .default
        progressView.isHidden = true
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    init(presenter: StatisticsWebViewPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter?.attachView(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showProgressView()
        addSubViews()
        addConstraints()
        presenter?.loadWebsite()
    }
    
    func loadURL(_ url: URL) {
        webView.load(URLRequest(url: url))
    }
    
    private func showProgressView() {
        progressObserver = webView.observe(\.estimatedProgress, options: []) { [weak self] webView, change in
            guard let self = self else { return }
            let progress = Float(webView.estimatedProgress)
            self.progressView.isHidden = progress == 1.0
            self.progressView.progress = progress
        }
    }
    
    private func addSubViews() {
        view.addSubview(webView)
        view.addSubview(progressView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
