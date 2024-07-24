//
//  MainViewController.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 04.07.24.
//
import UIKit
import SwiftUI
import SDWebImage
import FirebaseAuth

class MainViewController: UIViewController {
    var coordinator: AppCoordinator?
    var username: String?

    private let headerView = UIView()
    private let searchBar = UISearchBar()
    private var collectionView: UICollectionView!
    private var promotionCollectionView: UICollectionView!
    private var featuredProductCollectionView: UICollectionView!
    private var ratedProductCollectionView: UICollectionView!
    private let viewModel = ProductViewModel()
    private let playGameButton: CustomButton
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let bestPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.text = "Best Price"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let bestRatingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.text = "Best Rating"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let seeMoreBestPriceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("See More >", for: .normal)
        button.tintColor = .black  // Set button text color to black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(seeMoreBestPriceTapped), for: .touchUpInside)
        return button
    }()

    private let seeMoreBestRatingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("See More >", for: .normal)
        button.tintColor = .black  // Set button text color to black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(seeMoreBestRatingTapped), for: .touchUpInside)
        return button
    }()

    init() {
        self.playGameButton = CustomButton(title: "Play Game") {
            // Action for play game button
        }
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupNotificationObservers()
        fetchProducts()
    }

    private func setupUI() {
        // Setup Header View
        headerView.backgroundColor = .systemGreen
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)

        // Setup Search Bar
        let nickname = username ?? "User"
        searchBar.placeholder = "Hi \(nickname), search for anything"
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage() // Remove the background of the search bar
        searchBar.barTintColor = .white // Set the search bar background color to white
        searchBar.tintColor = .black // Set the search bar text and icons color to black
        searchBar.searchTextField.backgroundColor = .white // Ensure the search text field is also white
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(searchBar)

        // Setup Black Line
        let blackLine = UIView()
        blackLine.backgroundColor = .black
        blackLine.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blackLine)

        // Setup Scroll View
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)

        // Setup Collection Views
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cellSpacing: CGFloat = 20 // Define the spacing between cells
        let cellWidth = (view.frame.width - 40 - cellSpacing) / 3 // Increase width
        let cellHeight: CGFloat = 130 // Reduce height
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumLineSpacing = cellSpacing // Set the spacing between cells
        layout.sectionInset = UIEdgeInsets(top: 0, left: cellSpacing, bottom: 0, right: cellSpacing) // Add left and right insets for spacing

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AllCategoryCell.self, forCellWithReuseIdentifier: AllCategoryCell.identifier)
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false // Hide the horizontal scroll indicator
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        let promotionLayout = UICollectionViewFlowLayout()
        promotionLayout.scrollDirection = .horizontal
        promotionLayout.itemSize = CGSize(width: view.frame.width * 0.375 * 1.5, height: view.frame.width * 0.375) // Swap width and height
        promotionLayout.minimumLineSpacing = cellSpacing
        promotionLayout.sectionInset = UIEdgeInsets(top: 0, left: cellSpacing, bottom: 0, right: cellSpacing)

        promotionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: promotionLayout)
        promotionCollectionView.dataSource = self
        promotionCollectionView.delegate = self
        promotionCollectionView.register(PromotionCell.self, forCellWithReuseIdentifier: PromotionCell.identifier)
        promotionCollectionView.showsHorizontalScrollIndicator = false
        promotionCollectionView.translatesAutoresizingMaskIntoConstraints = false

        let featuredLayout = UICollectionViewFlowLayout()
        featuredLayout.scrollDirection = .horizontal
        let newCellHeight: CGFloat = view.frame.width * 0.8 // Increased height
        featuredLayout.itemSize = CGSize(width: view.frame.width * 0.45, height: newCellHeight)
        featuredLayout.minimumLineSpacing = 20
        featuredLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

        featuredProductCollectionView = UICollectionView(frame: .zero, collectionViewLayout: featuredLayout)
        featuredProductCollectionView.dataSource = self
        featuredProductCollectionView.delegate = self
        featuredProductCollectionView.register(FeaturedProductCell.self, forCellWithReuseIdentifier: FeaturedProductCell.identifier)
        featuredProductCollectionView.showsHorizontalScrollIndicator = false
        featuredProductCollectionView.translatesAutoresizingMaskIntoConstraints = false

        // Setup new ImageView
        let PromoImageView = UIImageView()
        PromoImageView.translatesAutoresizingMaskIntoConstraints = false
        PromoImageView.backgroundColor = .lightGray // Set a background color to visualize the image view
        PromoImageView.contentMode = .scaleToFill
        PromoImageView.layer.cornerRadius = 15 // Set corner radius here
        PromoImageView.layer.masksToBounds = true // Ensure the corner radius is applied
        PromoImageView.image = UIImage(named: "FreeDelivery") // Set your image here

        // Setup RatedProductCollectionView
        let ratedLayout = UICollectionViewFlowLayout()
        ratedLayout.scrollDirection = .horizontal
        let ratedCellHeight: CGFloat = view.frame.width * 0.8 // Increased height
        ratedLayout.itemSize = CGSize(width: view.frame.width * 0.45, height: ratedCellHeight)
        ratedLayout.minimumLineSpacing = 20
        ratedLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

        ratedProductCollectionView = UICollectionView(frame: .zero, collectionViewLayout: ratedLayout)
        ratedProductCollectionView.dataSource = self
        ratedProductCollectionView.delegate = self
        ratedProductCollectionView.register(RatedProductCell.self, forCellWithReuseIdentifier: RatedProductCell.identifier)
        ratedProductCollectionView.showsHorizontalScrollIndicator = false
        ratedProductCollectionView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(collectionView)
        contentView.addSubview(promotionCollectionView)
        contentView.addSubview(bestPriceLabel)
        contentView.addSubview(seeMoreBestPriceButton)
        contentView.addSubview(featuredProductCollectionView)
        contentView.addSubview(PromoImageView)
        contentView.addSubview(bestRatingLabel)
        contentView.addSubview(seeMoreBestRatingButton)
        contentView.addSubview(ratedProductCollectionView)

        // Setup Constraints
        NSLayoutConstraint.activate([
            // HeaderView Constraints
            headerView.topAnchor.constraint(equalTo: view.topAnchor), // Start from the top of the screen
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 120), // 120 points height

            // SearchBar Constraints
            searchBar.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -8),
            searchBar.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -5),
            searchBar.heightAnchor.constraint(equalToConstant: 44),
            
            // Black Line Constraints
            blackLine.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            blackLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blackLine.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blackLine.heightAnchor.constraint(equalToConstant: 1),

            // ScrollView Constraints
            scrollView.topAnchor.constraint(equalTo: blackLine.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // ContentView Constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // CollectionView Constraints
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: cellHeight), // Match cell height

            // PromotionCollectionView Constraints
            promotionCollectionView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            promotionCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            promotionCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            promotionCollectionView.heightAnchor.constraint(equalToConstant: view.frame.width * 0.375), // Match new PromotionCell height

            // BestPriceLabel Constraints
            bestPriceLabel.topAnchor.constraint(equalTo: promotionCollectionView.bottomAnchor, constant: 20),
            bestPriceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            // SeeMoreBestPriceButton Constraints
            seeMoreBestPriceButton.centerYAnchor.constraint(equalTo: bestPriceLabel.centerYAnchor),
            seeMoreBestPriceButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            // FeaturedProductCollectionView Constraints
            featuredProductCollectionView.topAnchor.constraint(equalTo: bestPriceLabel.bottomAnchor, constant: 10),
            featuredProductCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            featuredProductCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            featuredProductCollectionView.heightAnchor.constraint(equalToConstant: newCellHeight), // Increased height for horizontal scroll

            // New ImageView Constraints
            PromoImageView.topAnchor.constraint(equalTo: featuredProductCollectionView.bottomAnchor, constant: 20),
            PromoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            PromoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            PromoImageView.heightAnchor.constraint(equalToConstant: 300),

            // BestRatingLabel Constraints
            bestRatingLabel.topAnchor.constraint(equalTo: PromoImageView.bottomAnchor, constant: 20),
            bestRatingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            // SeeMoreBestRatingButton Constraints
            seeMoreBestRatingButton.centerYAnchor.constraint(equalTo: bestRatingLabel.centerYAnchor),
            seeMoreBestRatingButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            // RatedProductCollectionView Constraints
            ratedProductCollectionView.topAnchor.constraint(equalTo: bestRatingLabel.bottomAnchor, constant: 10),
            ratedProductCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratedProductCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ratedProductCollectionView.heightAnchor.constraint(equalToConstant: ratedCellHeight),
            ratedProductCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50)
        ])

        playGameButton.addTarget(self, action: #selector(playGameButtonTapped), for: .touchUpInside)
    }

    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleFavoritesUpdated(_:)), name: .favoritesUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleCartUpdated(_:)), name: .cartUpdated, object: nil)
    }

    @objc private func handleFavoritesUpdated(_ notification: Notification) {
        guard let productId = notification.object as? Int else { return }
        updateCellButtons(for: productId)
    }

    @objc private func handleCartUpdated(_ notification: Notification) {
        guard let productId = notification.object as? Int else { return }
        updateCellButtons(for: productId)
    }

    private func updateCellButtons(for productId: Int) {
        let indexPaths = collectionView.indexPathsForVisibleItems
        for indexPath in indexPaths {
            if let cell = collectionView.cellForItem(at: indexPath) as? ProductCell, cell.product?.id == productId {
                cell.isFavorite = viewModel.isFavorite(productId: productId)
                cell.isAddedToCart = viewModel.isInCart(productId: productId)
            }
        }

        let featuredIndexPaths = featuredProductCollectionView.indexPathsForVisibleItems
        for indexPath in featuredIndexPaths {
            if let cell = featuredProductCollectionView.cellForItem(at: indexPath) as? FeaturedProductCell, cell.product?.id == productId {
                cell.isFavorite = viewModel.isFavorite(productId: productId)
                cell.isAddedToCart = viewModel.isInCart(productId: productId)
            }
        }

        let ratedIndexPaths = ratedProductCollectionView.indexPathsForVisibleItems
        for indexPath in ratedIndexPaths {
            if let cell = ratedProductCollectionView.cellForItem(at: indexPath) as? RatedProductCell, cell.product?.id == productId {
                cell.isFavorite = viewModel.isFavorite(productId: productId)
                cell.isAddedToCart = viewModel.isInCart(productId: productId)
            }
        }
    }

    private func fetchProducts() {
        viewModel.fetchAllProducts { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.collectionView.reloadData()
                    self?.promotionCollectionView.reloadData()
                    self?.featuredProductCollectionView.reloadData()
                    self?.ratedProductCollectionView.reloadData()
                case .failure(let error):
                    print("Failed to fetch products:", error)
                }
            }
        }
    }

    @objc private func playGameButtonTapped() {
        guard let currentUser = Auth.auth().currentUser, currentUser.displayName != "Guest" else {
                showLoginAlert()
            return
        }
        navigateToTicTacToe()
    }

    private func showLoginAlert() {
        let alert = UIAlertController(title: "Login Required", message: "Please log in to continue.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { [weak self] _ in
            self?.coordinator?.showLogin()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func allCategoriesTapped() {
        let allCategoriesViewController = AllCategoriesViewController(categories: Array(viewModel.productsByCategory.keys), viewModel: viewModel)
        navigationController?.pushViewController(allCategoriesViewController, animated: true)
    }

    private func allBrandsTapped() {
        let brandListViewController = BrandListViewController(viewModel: viewModel)
        brandListViewController.delegate = self
        navigationController?.pushViewController(brandListViewController, animated: true)
    }

    private func navigateToTicTacToe() {
        let viewModel = TicTacToeViewModel(username: username)
        viewModel.onGameEnded = {
            self.navigationController?.popViewController(animated: true)
        }
        viewModel.onPromoDismissed = {
            self.navigationController?.popViewController(animated: true)
        }
        let gameViewController = UIHostingController(rootView: TicTacToeGameView(viewModel: viewModel))
        navigationController?.pushViewController(gameViewController, animated: true)
    }

    @objc private func seeMoreBestPriceTapped() {
        let allProductsVC = AllProductViewController(products: viewModel.sortedProductsByDiscount(), sortCriteria: .discount, viewModel: viewModel)
        navigationController?.pushViewController(allProductsVC, animated: true)
    }

    @objc private func seeMoreBestRatingTapped() {
        let allProductsVC = AllProductViewController(products: viewModel.sortedProductsByRating(), sortCriteria: .rating, viewModel: viewModel)
        navigationController?.pushViewController(allProductsVC, animated: true)
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return viewModel.productsByCategory.keys.count + 1 // Adding 1 for the AllCategoryCell
        } else if collectionView == self.promotionCollectionView {
            return 3 // Only 3 promotion items
        } else if collectionView == self.ratedProductCollectionView {
            return viewModel.sortedProductsByRating().count // Filter products by rating
        } else {
            return viewModel.sortedProductsByDiscount().count // Number of featured products
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AllCategoryCell.identifier, for: indexPath) as! AllCategoryCell
                // Configure AllCategoryCell if needed
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell
                let category = Array(viewModel.productsByCategory.keys)[indexPath.row - 1] // Adjust index for AllCategoryCell
                let imageUrlString = viewModel.categoryImages[category]
                let imageUrl = URL(string: imageUrlString ?? "")
                cell.configure(with: category, imageUrl: imageUrl, viewModel: viewModel)
                return cell
            }
        } else if collectionView == self.promotionCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PromotionCell.identifier, for: indexPath) as! PromotionCell
            if indexPath.row == 0 {
                cell.configure(image: UIImage(named: "game"), topText: "DISCOUNTS", bottomText: " - MAX $300 ")
            } else if indexPath.row == 1 {
                cell.configure(image: UIImage(named: "brand"), topText: "Brands", bottomText: "MORE THAN 50 + ")
            } else if indexPath.row == 2 {
                cell.configure(image: UIImage(named: "supermarket"), topText: "FAST DELIVERY", bottomText: "35-50 Minutes ")
            }
            return cell
        } else if collectionView == self.ratedProductCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RatedProductCell.identifier, for: indexPath) as! RatedProductCell
            let product = viewModel.sortedProductsByRating()[indexPath.row]
            cell.configure(with: product, viewModel: viewModel)
            cell.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedProductCell.identifier, for: indexPath) as! FeaturedProductCell
            let product = viewModel.sortedProductsByDiscount()[indexPath.row]
            cell.configure(with: product, viewModel: viewModel)
            cell.delegate = self
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            if indexPath.row == 0 {
                allCategoriesTapped()
            } else {
                let selectedCategory = Array(viewModel.productsByCategory.keys)[indexPath.row - 1]
                let products = viewModel.productsByCategory[selectedCategory] ?? []
                let categoryViewController = CategoryViewController(category: selectedCategory, products: products, viewModel: viewModel)
                navigationController?.pushViewController(categoryViewController, animated: true)
            }
        } else if collectionView == self.promotionCollectionView {
            if indexPath.row == 0 {
                navigateToTicTacToe()
            } else if indexPath.row == 1 {
                allBrandsTapped()
            } else if indexPath.row == 2 {
                let expressViewController = ExpressViewController(viewModel: viewModel)
                navigationController?.pushViewController(expressViewController, animated: true)
            }
        } else {
            let selectedProduct = viewModel.products[indexPath.row]
            let productDetailViewController = ProductDetailViewController(product: selectedProduct)
            navigationController?.pushViewController(productDetailViewController, animated: true)
        }
    }

    // Implement the delegate method to set the spacing for the first cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }

    func collectionView(_ collectionView: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20 // Define the spacing between cells
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let searchVC = SearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
        return false
    }
}

extension MainViewController: ProductSelectionDelegate {
    func didSelectProduct(_ product: Product) {
        let productDetailViewController = ProductDetailViewController(product: product)
        navigationController?.pushViewController(productDetailViewController, animated: true)
    }
}

extension MainViewController: CategorySelectionDelegate {
    func didSelectCategory(_ category: String, products: [Product]) {
        let categoryViewController = CategoryViewController(category: category, products: products, viewModel: viewModel)
        navigationController?.pushViewController(categoryViewController, animated: true)
    }
}

extension MainViewController: BrandSelectionDelegate {
    func didSelectBrand(_ brand: String, products: [Product]) {
        let brandProductsVC = CategoryViewController(category: brand, products: products, viewModel: viewModel)
        navigationController?.pushViewController(brandProductsVC, animated: true)
    }
}
