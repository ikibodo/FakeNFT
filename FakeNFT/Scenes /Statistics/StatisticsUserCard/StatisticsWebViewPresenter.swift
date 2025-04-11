//
//  Untitled.swift
//  FakeNFT
//
//  Created by N L on 24.3.25..
//
import Foundation

protocol StatisticsWebViewProtocol: AnyObject {
    func loadURL(_ url: URL)
}

final class StatisticsWebViewPresenter {
    private weak var view: StatisticsWebViewProtocol?
    private var websiteURL: String?
    
    init(websiteURL: String?) {
        self.websiteURL = websiteURL
    }
    
    func attachView(_ view: StatisticsWebViewController) {
        self.view = view
    }
    
    func getWebsiteURL() -> String? {
        return websiteURL
    }
    
    func loadWebsite() {
        guard let websiteURL = websiteURL, let url = URL(string: websiteURL) else {
            print("Некорректный URL")
            return
        }
        view?.loadURL(url)
    }
}
