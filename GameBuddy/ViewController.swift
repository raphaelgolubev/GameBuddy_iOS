//
//  ViewController.swift
//  GameBuddy
//
//  Created by Рафаэль Голубев on 14.04.2024.

import UIKit

class SessionDelegate: NSObject, URLSessionDelegate {

}

class Networker {
    var delegate: SessionDelegate = .init()
    var session: URLSession

    init() {
        session = .init(configuration: .default, delegate: delegate, delegateQueue: nil)
    }

    func send(_ request: URLRequest) async {
        do {
            var (data, response) = try await session.data(for: request)

            let str = String(decoding: data, as: UTF8.self)
            print(str)
            print(response.url ?? "None")
            print((response as? HTTPURLResponse)?.statusCode ?? "None")

        } catch {
            print(error.localizedDescription)
        }
    }
}

struct RegisterIn: Codable {
    var email: String?
    var password: String?

    func toJSON() -> Data? {
        var encoder = JSONEncoder()
        let encoded: Data? = try? encoder.encode(self)

        return encoded
    }
}

class ViewController: UIViewController {

    var networkService: Networker = .init()

    lazy var testButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.configuration?.title = "Отправить"
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        view.backgroundColor = .systemYellow

        view.addSubview(testButton)
        NSLayoutConstraint.activate([
            testButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        testButton.addAction(.init(handler: { [weak self] _ in

            Task {
                var components: URLComponents = .init()
                components.scheme = "http"
                components.host = "192.168.1.101" // сюда нужно писать адрес макбука в локальной сети
                components.port = 8000
                components.path = "/api/v1/register/create"

                let encoded = components.url!.absoluteString
                let url = URL(string: encoded)!

                var request: URLRequest = .init(url: url)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "POST"
                request.httpBody = RegisterIn(email: "ios", password: "ios").toJSON()

                await self?.networkService.send(request)
            }

        }), for: .touchUpInside)
    }


}

