//
//  OrderViewController.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 23.07.24.
//

import UIKit

class OrderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var orders: [Order] = []

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(OrderCell.self, forCellReuseIdentifier: OrderCell.identifier)
        return tableView
    }()
    
    private let noOrdersImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "empty_order")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let noOrdersLabel: UILabel = {
        let label = UILabel()
        label.text = "No Orders Yet"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .gray
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "My Orders"
        
        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)
        view.addSubview(noOrdersImageView)
        view.addSubview(noOrdersLabel)
        
        setupConstraints()
        loadOrders()
    }

    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        noOrdersImageView.translatesAutoresizingMaskIntoConstraints = false
        noOrdersLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            noOrdersImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noOrdersImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            noOrdersImageView.widthAnchor.constraint(equalToConstant: 150),
            noOrdersImageView.heightAnchor.constraint(equalToConstant: 150),
            
            noOrdersLabel.topAnchor.constraint(equalTo: noOrdersImageView.bottomAnchor, constant: 10),
            noOrdersLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            noOrdersLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func loadOrders() {
        orders = SharedStorage.shared.getOrders()
        tableView.reloadData()
        updateEmptyState()
    }

    private func updateEmptyState() {
        let isEmpty = orders.isEmpty
        tableView.isHidden = isEmpty
        noOrdersImageView.isHidden = !isEmpty
        noOrdersLabel.isHidden = !isEmpty
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderCell.identifier, for: indexPath) as? OrderCell else {
            return UITableViewCell()
        }
        cell.configure(with: orders[indexPath.row])
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
