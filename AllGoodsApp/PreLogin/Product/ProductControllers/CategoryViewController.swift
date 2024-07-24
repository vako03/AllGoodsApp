//
//  CategoryViewController.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 12.07.24.
//

import UIKit

protocol ProductSelectionDelegate: AnyObject {
    func didSelectProduct(_ product: Product)
}

class CategoryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ProductSelectionDelegate {
    private var collectionView: UICollectionView!
    private var products: [Product]
    private var category: String
    private let viewModel: ProductViewModel

    init(category: String, products: [Product], viewModel: ProductViewModel) {
        self.category = category
        self.products = products
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUIForFavoriteChanges(_:)), name: .favoritesUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateUIForCartChanges(_:)), name: .cartUpdated, object: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = category
        view.backgroundColor = .white
        setupCollectionView()
    }

    // MARK: - UI Setup
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: view.frame.width - 20, height: 150)
        
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

    // MARK: - UICollectionViewDataSource
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

    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 150)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProduct = products[indexPath.row]
        let productDetailViewController = ProductDetailViewController(product: selectedProduct)
        navigationController?.pushViewController(productDetailViewController, animated: true)
    }

    // MARK: - ProductSelectionDelegate
    func didSelectProduct(_ product: Product) {
        let productDetailViewController = ProductDetailViewController(product: product)
        navigationController?.pushViewController(productDetailViewController, animated: true)
    }

    // MARK: - Notification Handlers
    @objc private func updateUIForFavoriteChanges(_ notification: Notification) {
        guard let productId = notification.object as? Int else { return }
        if let index = products.firstIndex(where: { $0.id == productId }) {
            let indexPath = IndexPath(item: index, section: 0)
            collectionView.reloadItems(at: [indexPath])
        }
    }

    @objc private func updateUIForCartChanges(_ notification: Notification) {
        guard let productId = notification.object as? Int else { return }
        if let index = products.firstIndex(where: { $0.id == productId }) {
            let indexPath = IndexPath(item: index, section: 0)
            collectionView.reloadItems(at: [indexPath])
        }
    }
}
