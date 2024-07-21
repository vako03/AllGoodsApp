//
//  AllCategoriesViewController.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 11.07.24.
//
//
import UIKit

protocol CategorySelectionDelegate: AnyObject {
    func didSelectCategory(_ category: String, products: [Product])
}

class AllCategoriesViewController: UIViewController {
    private let categories: [String]
    private var tableView: UITableView!
    weak var delegate: CategorySelectionDelegate?
    private let viewModel: ProductViewModel

    init(categories: [String], viewModel: ProductViewModel) {
        self.categories = categories.sorted()
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "All Categories"
        setupTableView()
    }

    private func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryCell")
        view.addSubview(tableView)
    }
}

extension AllCategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.capitalized
        cell.imageView?.image = UIImage(named: "placeholder") // Replace with actual category image
        return cell
    }
}

extension AllCategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.row]
        viewModel.fetchProducts(for: selectedCategory) { [weak self] result in
            switch result {
            case .success(let products):
                DispatchQueue.main.async {
                    let productListVC = ProductListViewController(category: selectedCategory, products: products, viewModel: self?.viewModel ?? ProductViewModel())
                    productListVC.delegate = self?.delegate as? ProductSelectionDelegate // Set the delegate
                    self?.navigationController?.pushViewController(productListVC, animated: true)
                }
            case .failure(let error):
                print("Failed to fetch products:", error)
                // Show an error message to the user if needed
            }
        }
    }
}
