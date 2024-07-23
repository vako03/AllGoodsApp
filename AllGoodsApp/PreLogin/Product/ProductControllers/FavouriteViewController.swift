//
//  FavouriteViewController.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 09.07.24.
//

import UIKit

class FavouriteViewController: UIViewController {
    var coordinator: AppCoordinator?
    private let viewModel = ProductViewModel()
    private var collectionView: UICollectionView!
    private var favoriteProducts: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Favourite"
        setupCollectionView()
        fetchFavorites()
        setupNotificationObservers()
    }

    private func setupCollectionView() {
        let layout = SeparatorLine()

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func fetchFavorites() {
        viewModel.fetchAllProducts { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.favoriteProducts = self?.viewModel.getFavoriteProducts() ?? []
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch products:", error)
            }
        }
    }

    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollectionView), name: .favoritesUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollectionView), name: .cartUpdated, object: nil)
    }

    @objc private func reloadCollectionView(notification: Notification) {
        DispatchQueue.main.async {
            self.favoriteProducts = self.viewModel.getFavoriteProducts()
            self.collectionView.reloadData()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension FavouriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteProducts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell
        let product = favoriteProducts[indexPath.row]
        cell.configure(with: product, viewModel: viewModel)
        cell.delegate = self
        return cell
    }
}

extension FavouriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = favoriteProducts[indexPath.row]
        let productDetailViewController = ProductDetailViewController(product: product)
        navigationController?.pushViewController(productDetailViewController, animated: true)
    }
}

extension FavouriteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 150)
    }
}

extension FavouriteViewController: ProductSelectionDelegate {
    func didSelectProduct(_ product: Product) {
        let productDetailViewController = ProductDetailViewController(product: product)
        navigationController?.pushViewController(productDetailViewController, animated: true)
    }
}
