//
//  WebViewController.swift
//  FakeNFT
//
//  Created by Diliara Sadrieva on 25.03.2025.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {
    private let webView = WKWebView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }
    private func setupWebView() {
        webView.frame = view.bounds
        view.addSubview(webView)
    }
    func loadURL(_ url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
