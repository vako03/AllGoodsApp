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

class AllProductViewController: UIViewController {
    private var products: [Product]
    private let sortCriteria: SortCriteria
    private var currentPage: Int = 1
    private var totalPages: Int {
        return (products.count + 19) / 20
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 300)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 3
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private let paginationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    init(products: [Product], sortCriteria: SortCriteria) {
        self.products = products
        self.sortCriteria = sortCriteria
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        view.addSubview(paginationStackView)
        setupConstraints()
        setupPaginationButtons()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: paginationStackView.topAnchor),
            
            paginationStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            paginationStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            paginationStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            paginationStackView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupPaginationButtons() {
        paginationStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let totalPages = self.totalPages
        
        for page in 1...totalPages {
            let button = UIButton(type: .system)
            button.setTitle("\(page)", for: .normal)
            button.tag = page
            button.addTarget(self, action: #selector(pageButtonTapped(_:)), for: .touchUpInside)
            paginationStackView.addArrangedSubview(button)
        }
    }
    
    @objc private func pageButtonTapped(_ sender: UIButton) {
        currentPage = sender.tag
        collectionView.reloadData()
    }
}

extension AllProductViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let startIndex = (currentPage - 1) * 20
        let endIndex = min(startIndex + 20, products.count)
        return endIndex - startIndex
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let startIndex = (currentPage - 1) * 20
        let endIndex = min(startIndex + 20, products.count)
        let product = products[startIndex + indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell
        cell.configure(with: product)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let startIndex = (currentPage - 1) * 20
        let product = products[startIndex + indexPath.row]
        let productDetailViewController = ProductDetailViewController(product: product)
        navigationController?.pushViewController(productDetailViewController, animated: true)
    }
}

   
