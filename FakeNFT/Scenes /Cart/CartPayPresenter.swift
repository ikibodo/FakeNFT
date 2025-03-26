//
//  CartPayPresenter.swift
//  FakeNFT
//
//  Created by Diliara Sadrieva on 25.03.2025.
//
import UIKit

protocol CartPayPresenterProtocol {
    var visibleCurrencies: [Currencies] { get set }
    var view: CartPayViewControllerProtocol? { get set }
    func getCurrencies(completion: @escaping (Result<[Currencies], Error>) -> Void)
}
final class CartPayPresenter: CartPayPresenterProtocol {
    weak var view: CartPayViewControllerProtocol?
    var visibleCurrencies: [Currencies] = []
    private let networkClient: DefaultNetworkClient
    init(networkClient: DefaultNetworkClient) {
        self.networkClient = networkClient
    }
    func getCurrencies(completion: @escaping (Result<[Currencies], Error>) -> Void) {
        let url = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/currencies")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("9f1db4ef-0d17-4eac-bbab-a57cbf3521a3", forHTTPHeaderField: "X-Practicum-Mobile-Token")
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            do {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else { return }
                let currencies = try JSONDecoder().decode([Currencies].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(currencies))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    private func saveItems(items: [Currencies]) {
        visibleCurrencies = items
    }
}
