//
//  BrandListViewController.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 13.07.24.
//
import UIKit

protocol BrandSelectionDelegate: AnyObject {
    func didSelectBrand(_ brand: String, products: [Product])
}

class BrandListViewController: UIViewController {
    private var brands: [String] = []
    private var tableView: UITableView!
    weak var delegate: BrandSelectionDelegate?
    private let viewModel: ProductViewModel

    init(viewModel: ProductViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Brands"
        setupTableView()
        fetchBrands()
    }

    private func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BrandCell")
        view.addSubview(tableView)
    }

    private func fetchBrands() {
        viewModel.fetchAllBrands { [weak self] result in
            switch result {
            case .success(let brands):
                self?.brands = brands
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch brands:", error)
            }
        }
    }
}

extension BrandListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brands.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BrandCell", for: indexPath)
        cell.textLabel?.text = brands[indexPath.row]
        return cell
    }
}

extension BrandListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBrand = brands[indexPath.row]
        viewModel.fetchProducts(forBrand: selectedBrand) { [weak self] result in
            switch result {
            case .success(let products):
                DispatchQueue.main.async {
                    self?.delegate?.didSelectBrand(selectedBrand, products: products)
                }
            case .failure(let error):
                print("Failed to fetch products:", error)
            }
        }
    }
}
