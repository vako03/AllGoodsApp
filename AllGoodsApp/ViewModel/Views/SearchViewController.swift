//
//  SearchViewController.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 22.07.24.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private var searchBar: UISearchBar!
    private var collectionView: UICollectionView!
    private var products: [Product] = []
    private var viewModel = ProductViewModel()
    private var sortButton: UIBarButtonItem!
    private var sortCriteria: SortCriteria = .priceAscending

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSearchBar()
        setupCollectionView()
        setupNavigationItems()
    }

    private func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search for products"
        searchBar.inputAccessoryView = createToolbar()  // Add the toolbar to the search bar
        navigationItem.titleView = searchBar
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width - 20, height: 150)
        layout.minimumLineSpacing = 10
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupNavigationItems() {
        // Custom back button
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
        
        // Sort button
        sortButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"), style: .plain, target: self, action: #selector(sortButtonTapped))
        navigationItem.rightBarButtonItem = sortButton
    }

    private func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.items = [flexSpace, doneButton]
        return toolbar
    }

    @objc private func doneButtonTapped() {
        searchBar.resignFirstResponder()
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func sortButtonTapped() {
        let alertController = UIAlertController(title: "Sort By", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Price: Ascending", style: .default, handler: { _ in
            self.sortCriteria = .priceAscending
            self.sortProducts()
        }))
        alertController.addAction(UIAlertAction(title: "Price: Descending", style: .default, handler: { _ in
            self.sortCriteria = .priceDescending
            self.sortProducts()
        }))
        alertController.addAction(UIAlertAction(title: "Headline: A-Z", style: .default, handler: { _ in
            self.sortCriteria = .headlineAZ
            self.sortProducts()
        }))
        alertController.addAction(UIAlertAction(title: "Headline: Z-A", style: .default, handler: { _ in
            self.sortCriteria = .headlineZA
            self.sortProducts()
        }))
        alertController.addAction(UIAlertAction(title: "Discount", style: .default, handler: { _ in
            self.sortCriteria = .discount
            self.sortProducts()
        }))
        alertController.addAction(UIAlertAction(title: "Rating", style: .default, handler: { _ in
            self.sortCriteria = .rating
            self.sortProducts()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    private func sortProducts() {
        products.sort(by: { (p1, p2) -> Bool in
            switch sortCriteria {
            case .priceAscending:
                return p1.price < p2.price
            case .priceDescending:
                return p1.price > p2.price
            case .headlineAZ:
                return p1.title.lowercased() < p2.title.lowercased()
            case .headlineZA:
                return p1.title.lowercased() > p2.title.lowercased()
            case .discount:
                return p1.discountPercentage > p2.discountPercentage
            case .rating:
                return p1.rating > p2.rating
            }
        })
        collectionView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchProducts(with: searchText)
    }

    private func searchProducts(with query: String) {
        viewModel.fetchAllProducts { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.products = self?.viewModel.products.filter { $0.title.lowercased().contains(query.lowercased()) } ?? []
                    self?.sortProducts()
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print("Failed to fetch products:", error)
                }
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell
        let product = products[indexPath.row]
        cell.configure(with: product, viewModel: viewModel)
        cell.delegate = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProduct = products[indexPath.row]
        let productDetailViewController = ProductDetailViewController(product: selectedProduct)
        navigationController?.pushViewController(productDetailViewController, animated: true)
    }
}

extension SearchViewController: ProductSelectionDelegate {
    func didSelectProduct(_ product: Product) {
        let productDetailViewController = ProductDetailViewController(product: product)
        navigationController?.pushViewController(productDetailViewController, animated: true)
    }
}

enum SortCriteria {
    case priceAscending
    case priceDescending
    case headlineAZ
    case headlineZA
    case discount
    case rating
}
