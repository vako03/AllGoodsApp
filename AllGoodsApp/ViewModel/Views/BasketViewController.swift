//
//  BasketViewController.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 09.07.24.
//

import UIKit

class BasketViewController: UIViewController {
    var coordinator: AppCoordinator?
    private let viewModel = ProductViewModel()
    private var collectionView: UICollectionView!
    private var cartProducts: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Basket"
        setupCollectionView()
        fetchCartItems()
        setupNotificationObservers()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width, height: 150)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(BasketProductCell.self, forCellWithReuseIdentifier: BasketProductCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func fetchCartItems() {
        viewModel.fetchAllProducts { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.cartProducts = self?.viewModel.getCartProducts() ?? []
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch products:", error)
            }
        }
    }

    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollectionView), name: .cartUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollectionView), name: .favoritesUpdated, object: nil)
    }

    @objc private func reloadCollectionView(notification: Notification) {
        DispatchQueue.main.async {
            self.cartProducts = self.viewModel.getCartProducts()
            self.collectionView.reloadData()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension BasketViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cartProducts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BasketProductCell.identifier, for: indexPath) as! BasketProductCell
        let product = cartProducts[indexPath.row]
        cell.configure(with: product, viewModel: viewModel)
        cell.delegate = self
        return cell
    }
}

extension BasketViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = cartProducts[indexPath.row]
        let productDetailViewController = ProductDetailViewController(product: product)
        navigationController?.pushViewController(productDetailViewController, animated: true)
    }
}

extension BasketViewController: ProductSelectionDelegate {
    func didSelectProduct(_ product: Product) {
        let productDetailViewController = ProductDetailViewController(product: product)
        navigationController?.pushViewController(productDetailViewController, animated: true)
    }
}

extension BasketViewController: BasketProductCellDelegate {
    func didUpdateQuantity(for product: Product, quantity: Int) {
        // Handle quantity update logic here if necessary
    }

    func didRemoveProduct(_ product: Product) {
        viewModel.toggleCart(productId: product.id)
        cartProducts.removeAll { $0.id == product.id }
        collectionView.reloadData()
        NotificationCenter.default.post(name: .cartUpdated, object: product.id)
    }
}
