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
    private var noFavoritesImageView: UIImageView!
    private var noFavoritesLabel: UILabel!

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Favourite"
        setupCollectionView()
        setupNoFavoritesView()
        fetchFavorites()
        setupNotificationObservers()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - UI Setup
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width, height: 150)
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

    private func setupNoFavoritesView() {
        noFavoritesImageView = UIImageView(image: UIImage(named: "file"))
        noFavoritesImageView.contentMode = .scaleAspectFit
        noFavoritesImageView.translatesAutoresizingMaskIntoConstraints = false

        noFavoritesLabel = UILabel()
        noFavoritesLabel.text = "No Favorites Yet"
        noFavoritesLabel.textAlignment = .center
        noFavoritesLabel.textColor = .gray
        noFavoritesLabel.font = UIFont.systemFont(ofSize: 18)
        noFavoritesLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(noFavoritesImageView)
        view.addSubview(noFavoritesLabel)

        NSLayoutConstraint.activate([
            noFavoritesImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noFavoritesImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            noFavoritesImageView.widthAnchor.constraint(equalToConstant: 200),
            noFavoritesImageView.heightAnchor.constraint(equalToConstant: 200),
            
            noFavoritesLabel.topAnchor.constraint(equalTo: noFavoritesImageView.bottomAnchor, constant: 10),
            noFavoritesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    // MARK: - Data Fetching
    private func fetchFavorites() {
        viewModel.fetchAllProducts { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.favoriteProducts = self?.viewModel.getFavoriteProducts() ?? []
                    self?.updateUI()
                }
            case .failure(let error):
                print("Failed to fetch products:", error)
            }
        }
    }

    private func updateUI() {
        collectionView.reloadData()
        let hasFavorites = !favoriteProducts.isEmpty
        noFavoritesImageView.isHidden = hasFavorites
        noFavoritesLabel.isHidden = hasFavorites
    }

    // MARK: - Notification Setup
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollectionView), name: .favoritesUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollectionView), name: .cartUpdated, object: nil)
    }

    @objc private func reloadCollectionView(notification: Notification) {
        DispatchQueue.main.async {
            self.favoriteProducts = self.viewModel.getFavoriteProducts()
            self.updateUI()
        }
    }
}

// MARK: - UICollectionViewDataSource
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

// MARK: - UICollectionViewDelegate
extension FavouriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = favoriteProducts[indexPath.row]
        let productDetailViewController = ProductDetailViewController(product: product)
        navigationController?.pushViewController(productDetailViewController, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FavouriteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 150)
    }
}

// MARK: - ProductSelectionDelegate
extension FavouriteViewController: ProductSelectionDelegate {
    func didSelectProduct(_ product: Product) {
        let productDetailViewController = ProductDetailViewController(product: product)
        navigationController?.pushViewController(productDetailViewController, animated: true)
    }
}
