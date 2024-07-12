//
//  MainViewController.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 04.07.24.
//

import UIKit
import SwiftUI

extension UIColor {
    static let customGreen = UIColor(red: 0x00 / 255.0, green: 0xCC / 255.0, blue: 0x96 / 255.0, alpha: 1.0)
}

final class MainViewController: UIViewController {
    var coordinator: AppCoordinator?
    var username: String?

    private let headerView = UIView()
    private let searchBar = UISearchBar()
    private var collectionView: UICollectionView!
    private var promotionCollectionView: UICollectionView!
    private let viewModel = ProductViewModel()
    private let playGameButton = CustomButton(title: "Play Game", action: { }) // Define the button but hide it later

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        fetchProducts()
    }

    private func setupUI() {
        // Setup Header View
        headerView.backgroundColor = .customGreen
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)

        // Setup Search Bar
        let nickname = username ?? "User"
        searchBar.placeholder = "Hi \(nickname), search for anything"
        searchBar.backgroundImage = UIImage() // Remove the background of the search bar
        searchBar.barTintColor = .white // Set the search bar background color to white
        searchBar.tintColor = .black // Set the search bar text and icons color to black
        searchBar.searchTextField.backgroundColor = .white // Ensure the search text field is also white
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(searchBar)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor), // Start from the top of the screen
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 120), // 120 points height

            searchBar.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -8),
            searchBar.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -5),
            searchBar.heightAnchor.constraint(equalToConstant: 44)
        ])

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

        view.addSubview(collectionView)
        view.addSubview(promotionCollectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: cellHeight), // Match cell height

            promotionCollectionView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            promotionCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            promotionCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            promotionCollectionView.heightAnchor.constraint(equalToConstant: view.frame.width * 0.375) // Match new PromotionCell height
        ])
    }

    private func fetchProducts() {
        viewModel.fetchAllProducts { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print("Failed to fetch products:", error)
                }
            }
        }
    }

    private func playGameButtonTapped() {
        // Placeholder for play game logic
    }

    private func showLoginAlert() {
        let alertController = UIAlertController(title: "Login Required", message: "Please login or register to play the game.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.coordinator?.showLogin()
        })
        present(alertController, animated: true, completion: nil)
    }

    @objc private func allCategoriesTapped() {
        let allCategoriesViewController = AllCategoriesViewController(categories: Array(viewModel.productsByCategory.keys))
        navigationController?.pushViewController(allCategoriesViewController, animated: true)
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
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return viewModel.productsByCategory.keys.count + 1 // Adding 1 for the AllCategoryCell
        } else {
            return 3 // Only 3 promotion items
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
                cell.configure(with: category, imageUrl: imageUrl)
                return cell
            }
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PromotionCell.identifier, for: indexPath) as! PromotionCell
            if indexPath.row == 0 {
                cell.configure(image: UIImage(named: "game"), topText: "DISCOUNTS", bottomText: " - MAX $300 ")
            } else if indexPath.row == 1 {
                cell.configure(image: UIImage(named: "brand"), topText: "Brands", bottomText: "MORE THAN 50 + ")
            } else if indexPath.row == 2 {
                cell.configure(image: UIImage(named: "supermarket"), topText: "FAST DELIVERY", bottomText: "35-50 Minutes ")
            }
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
                let categoryViewController = CategoryViewController(category: selectedCategory, products: products)
                navigationController?.pushViewController(categoryViewController, animated: true)
            }
        } else {
            if indexPath.row == 0 {
                navigateToTicTacToe()
            } else {
                print("Promotion \(indexPath.row + 1) tapped")
            }
        }
    }

    // Implement the delegate method to set the spacing for the first cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20 // Define the spacing between cells
    }
}
