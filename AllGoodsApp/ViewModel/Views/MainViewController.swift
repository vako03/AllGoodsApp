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
        layout.itemSize = CGSize(width: 150, height: 200)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(welcomeLabel)
        view.addSubview(playGameButton)
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            playGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playGameButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),

            collectionView.topAnchor.constraint(equalTo: playGameButton.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 200)
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
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.productsByCategory.keys.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell
        let category = Array(viewModel.productsByCategory.keys)[indexPath.row]
        let image = UIImage(named: "placeholder") // Replace with actual category image
        cell.configure(with: category, image: image)
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
