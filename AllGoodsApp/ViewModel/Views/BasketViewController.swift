//
//  BasketViewController.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 09.07.24.
//

import UIKit

class BasketViewController: UIViewController {
    var coordinator: AppCoordinator?
    private let viewModel = ProductViewModel()
    private var collectionView: UICollectionView!
    private var cartProducts: [(product: Product, quantity: Int)] = []

    // Stack View Elements
    private let totalPriceLabel = UILabel()
    private let discountLabel = UILabel()
    private let finalPriceLabel = UILabel()
    private let checkoutButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Basket"
        setupCollectionView()
        setupStackView()
        fetchCartItems()
        setupNotificationObservers()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width, height: 150)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(BasketProductCell.self, forCellWithReuseIdentifier: BasketProductCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -150) // Adjust this constant to add space
        ])
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [totalPriceLabel, discountLabel, finalPriceLabel, checkoutButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        checkoutButton.setTitle("Checkout", for: .normal)
        checkoutButton.backgroundColor = .black
        checkoutButton.setTitleColor(.white, for: .normal)
        checkoutButton.layer.cornerRadius = 10
        checkoutButton.addTarget(self, action: #selector(checkoutButtonTapped), for: .touchUpInside)
    }

    @objc private func checkoutButtonTapped() {
        // Handle checkout logic
    }

    private func fetchCartItems() {
        viewModel.fetchAllProducts { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    let cartProductIds = self?.viewModel.getCartProducts() ?? []
                    self?.cartProducts = cartProductIds.map { ($0, 1) }  // Initialize all quantities to 1
                    self?.collectionView.reloadData()
                    self?.updateStackView()
                }
            case .failure(let error):
                print("Failed to fetch products:", error)
            }
        }
    }

    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollectionView), name: .cartUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollectionView), name: .favoritesUpdated, object: nil)
    }

    @objc private func reloadCollectionView(notification: Notification) {
        DispatchQueue.main.async {
            let cartProductIds = self.viewModel.getCartProducts()
            self.cartProducts = cartProductIds.map { ($0, 1) }  // Initialize all quantities to 1
            self.collectionView.reloadData()
            self.updateStackView()
        }
    }

    private func updateStackView() {
        let totalQuantity = cartProducts.reduce(0) { $0 + $1.quantity }
        let totalPrice = cartProducts.reduce(0) { $0 + $1.product.price * Double($1.quantity) }
        let totalDiscount = cartProducts.reduce(0) { $0 + ($1.product.price * $1.product.discountPercentage / 100) * Double($1.quantity) }
        let finalPrice = totalPrice - totalDiscount

        totalPriceLabel.text = "Products (\(totalQuantity))  \(totalPrice.currencyString)"
        discountLabel.text = "Discount  -\(totalDiscount.currencyString)"
        finalPriceLabel.text = "Total price  \(finalPrice.currencyString)"
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension BasketViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cartProducts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BasketProductCell.identifier, for: indexPath) as! BasketProductCell
        let cartProduct = cartProducts[indexPath.row]
        cell.configure(with: cartProduct.product, viewModel: viewModel, quantity: cartProduct.quantity)
        cell.delegate = self
        return cell
    }
}

extension BasketViewController: BasketProductCellDelegate {
    func didUpdateQuantity(for product: Product, quantity: Int) {
        if let index = cartProducts.firstIndex(where: { $0.product.id == product.id }) {
            cartProducts[index].quantity = quantity
        }
        updateStackView()
    }

    func didRemoveProduct(_ product: Product) {
        viewModel.toggleCart(productId: product.id)
        cartProducts.removeAll { $0.product.id == product.id }
        collectionView.reloadData()
        updateStackView()
        NotificationCenter.default.post(name: .cartUpdated, object: product.id)
    }
}

private extension Double {
    var currencyString: String {
        return String(format: "%.2f", self)
    }
}
