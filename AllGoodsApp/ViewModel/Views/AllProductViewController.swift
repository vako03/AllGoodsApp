//
//  AllProductViewController.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 14.07.24.
//
import UIKit

enum SortCriteria {
    case discount
    case rating
}

class AllProductViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ProductSelectionDelegate {
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
        self.sortedProducts = products.sorted(by: { (p1, p2) -> Bool in
            switch sortCriteria {
            case .discount:
                return p1.discountPercentage > p2.discountPercentage
            case .rating:
                return p1.rating > p2.rating
            }
        })
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
    }

    private func setupCollectionView() {
        let layout = LineFlowLayout()

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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 150)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let startIndex = currentPage * itemsPerPage
        let selectedProduct = sortedProducts[startIndex + indexPath.row]
        let productDetailViewController = ProductDetailViewController(product: selectedProduct)
        navigationController?.pushViewController(productDetailViewController, animated: true)
    }

    func didSelectProduct(_ product: Product) {
        let productDetailViewController = ProductDetailViewController(product: product)
        navigationController?.pushViewController(productDetailViewController, animated: true)
    }

    // Implement pagination logic if necessary
}
