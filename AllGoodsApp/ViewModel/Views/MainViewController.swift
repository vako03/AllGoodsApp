//
//  MainViewController.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 04.07.24.
//
import UIKit
import SwiftUI

final class MainViewController: UIViewController {
    var coordinator: AppCoordinator?
    var username: String?

    private let welcomeLabel = UILabel()
    private var collectionView: UICollectionView!
    private let viewModel = ProductViewModel()
    private let allCategoriesCell = AllCategoryCell()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        fetchProducts()
    }

    private func setupUI() {
        welcomeLabel.text = "Hi, \(username ?? "User")"
        welcomeLabel.font = UIFont.systemFont(ofSize: 24)
        welcomeLabel.textAlignment = .center
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false

        let playGameButton = CustomButton(title: "Play Game") { [weak self] in
            self?.playGameButtonTapped()
        }

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cellWidth = (view.frame.width - 40) / 4 + 20 // Increase width by 20
        let cellHeight: CGFloat = 150 - 10 // Decrease height by 10
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        // Setup the fixed "All Categories" cell
        allCategoriesCell.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(allCategoriesTapped))
        allCategoriesCell.addGestureRecognizer(tapGesture)

        view.addSubview(welcomeLabel)
        view.addSubview(playGameButton)
        view.addSubview(allCategoriesCell)
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            playGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playGameButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),

            allCategoriesCell.topAnchor.constraint(equalTo: playGameButton.bottomAnchor, constant: 20),
            allCategoriesCell.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            allCategoriesCell.widthAnchor.constraint(equalToConstant: cellWidth),
            allCategoriesCell.heightAnchor.constraint(equalToConstant: cellHeight),

            collectionView.topAnchor.constraint(equalTo: playGameButton.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: allCategoriesCell.trailingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: cellHeight) // Match cell height
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
        if username == "Guest" {
            showLoginAlert()
        } else {
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
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.productsByCategory.keys.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell
        let category = Array(viewModel.productsByCategory.keys)[indexPath.row]
        let imageUrlString = viewModel.categoryImages[category]
        let imageUrl = URL(string: imageUrlString ?? "")
        cell.configure(with: category, imageUrl: imageUrl)
        return cell
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = Array(viewModel.productsByCategory.keys)[indexPath.row]
        let products = viewModel.productsByCategory[selectedCategory] ?? []
        let categoryViewController = CategoryViewController(category: selectedCategory, products: products)
        navigationController?.pushViewController(categoryViewController, animated: true)
    }
}
