//
//  AllProductViewController.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 14.07.24.
//
import UIKit

class AllProductViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var products: [Product]
    private var sortedProducts: [Product]
    private var currentPage = 0
    private let itemsPerPage = 20
    private var sortCriteria: SortCriteria
    private let viewModel: ProductViewModel

    init(products: [Product], sortCriteria: SortCriteria, viewModel: ProductViewModel) {
        self.products = products
        self.sortCriteria = sortCriteria
        self.viewModel = viewModel
        self.sortedProducts = products
        super.init(nibName: nil, bundle: nil)
        sortProducts()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        setupNavigationItems()
    }

    // MARK: - Setup Methods
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
        let sortButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"), style: .plain, target: self, action: #selector(sortButtonTapped))
        navigationItem.rightBarButtonItem = sortButton
    }

    // MARK: - Sorting Methods
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
        sortedProducts = products.sorted(by: { (p1, p2) -> Bool in
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
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension AllProductViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let startIndex = currentPage * itemsPerPage
        let endIndex = min(startIndex + itemsPerPage, sortedProducts.count)
        return endIndex - startIndex
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell
        let startIndex = currentPage * itemsPerPage
        let product = sortedProducts[startIndex + indexPath.row]
        cell.configure(with: product, viewModel: viewModel)
        cell.delegate = self
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AllProductViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 150)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let startIndex = currentPage * itemsPerPage
        let selectedProduct = sortedProducts[startIndex + indexPath.row]
        let productDetailViewController = ProductDetailViewController(product: selectedProduct)
        navigationController?.pushViewController(productDetailViewController, animated: true)
    }
}

// MARK: - ProductSelectionDelegate
extension AllProductViewController: ProductSelectionDelegate {
    func didSelectProduct(_ product: Product) {
        let productDetailViewController = ProductDetailViewController(product: product)
        navigationController?.pushViewController(productDetailViewController, animated: true)
    }
}
