//
//  MainViewController.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 04.07.24.
//
import UIKit

final class MainViewController: UIViewController {
    var coordinator: AppCoordinator?
    var username: String?

    private let categoryViewModel = CategoryViewModel()
    
    private let welcomeLabel = CustomLabel(text: "", fontSize: 24, alignment: .center)

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search headphone"
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()

    private let categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    private let featuredProductsLabel: UILabel = {
        let label = UILabel()
        label.text = "Featured Products"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()

    private let featuredProductsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FeaturedProductCell.self, forCellWithReuseIdentifier: "FeaturedProductCell")
        collectionView.isScrollEnabled = false
        return collectionView
    }()

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        fetchCategories()
    }

    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20

        stackView.addArrangedSubview(welcomeLabel)
        stackView.addArrangedSubview(searchBar)
        stackView.addArrangedSubview(categoriesCollectionView)
        stackView.addArrangedSubview(featuredProductsLabel)
        stackView.addArrangedSubview(featuredProductsCollectionView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            categoriesCollectionView.heightAnchor.constraint(equalToConstant: 100),
            featuredProductsCollectionView.heightAnchor.constraint(equalToConstant: 600) // Adjust based on content
        ])

        if let username = username {
            welcomeLabel.text = "Hi, \(username)"
        }

        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self

        featuredProductsCollectionView.delegate = self
        featuredProductsCollectionView.dataSource = self
    }

    private func fetchCategories() {
        categoryViewModel.fetchCategories { [weak self] in
            DispatchQueue.main.async {
                self?.categoriesCollectionView.reloadData()
            }
        }
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoriesCollectionView {
            return categoryViewModel.categories.count
        } else {
            return 10 // Number of featured products
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoriesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            let category = categoryViewModel.categories[indexPath.item]
            cell.configure(with: category.name)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedProductCell", for: indexPath) as! FeaturedProductCell
            cell.configure(with: "Product \(indexPath.item + 1)")
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoriesCollectionView {
            let category = categoryViewModel.categories[indexPath.item]
            let productListVC = ProductListViewController(categoryURL: category.url)
            navigationController?.pushViewController(productListVC, animated: true)
        }
    }
}
