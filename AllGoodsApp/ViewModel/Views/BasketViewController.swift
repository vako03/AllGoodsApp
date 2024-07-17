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
    private var cartProducts: [Product] = []

    // Payment details UI elements
    private let titleLabel = UILabel()
    private let productCountSumPriceLabel = UILabel()
    private let discountLabel = UILabel()
    private let totalLabel = UILabel()
    private let checkoutButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Basket"
        setupCollectionView()
        setupPaymentDetailsView()
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
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200)
        ])
    }

    private func setupPaymentDetailsView() {
        // Title label
        titleLabel.text = "Payment"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Product count and sum price label
        productCountSumPriceLabel.font = UIFont.systemFont(ofSize: 16)
        productCountSumPriceLabel.textColor = .black
        productCountSumPriceLabel.translatesAutoresizingMaskIntoConstraints = false

        // Discount label
        discountLabel.font = UIFont.systemFont(ofSize: 16)
        discountLabel.textColor = .black
        discountLabel.textAlignment = .right
        discountLabel.translatesAutoresizingMaskIntoConstraints = false

        // Total label
        totalLabel.font = UIFont.boldSystemFont(ofSize: 16)
        totalLabel.textColor = .black
        totalLabel.textAlignment = .right
        totalLabel.translatesAutoresizingMaskIntoConstraints = false

        // Stacks and separators
        let productCountSumPriceStack = createPaymentDetailStack(title: "", valueLabel: productCountSumPriceLabel)
        let discountStack = createPaymentDetailStack(title: "Discount:", valueLabel: discountLabel)
        let totalStack = createPaymentDetailStack(title: "Total price:", valueLabel: totalLabel, isBold: true)

        let paymentDetailsStack = UIStackView(arrangedSubviews: [titleLabel, productCountSumPriceStack, createSeparator(), discountStack, createSeparator(), totalStack])
        paymentDetailsStack.axis = .vertical
        paymentDetailsStack.spacing = 16
        paymentDetailsStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(paymentDetailsStack)

        // Checkout button
        checkoutButton.setTitle("Checkout", for: .normal)
        checkoutButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        checkoutButton.backgroundColor = .black
        checkoutButton.setTitleColor(.white, for: .normal)
        checkoutButton.layer.cornerRadius = 25
        checkoutButton.addTarget(self, action: #selector(checkoutButtonTapped), for: .touchUpInside)
        checkoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(checkoutButton)

        NSLayoutConstraint.activate([
            paymentDetailsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            paymentDetailsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            paymentDetailsStack.bottomAnchor.constraint(equalTo: checkoutButton.topAnchor, constant: -16),

            checkoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            checkoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            checkoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            checkoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func createPaymentDetailStack(title: String, valueLabel: UILabel, isBold: Bool = false) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = isBold ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        valueLabel.font = isBold ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 16)
        valueLabel.textColor = .black
        valueLabel.textAlignment = .right
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false

        return stack
    }

    private func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = .lightGray
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return separator
    }

    private func fetchCartItems() {
        viewModel.fetchAllProducts { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.cartProducts = self?.viewModel.getCartProducts() ?? []
                    self?.collectionView.reloadData()
                    self?.updatePaymentDetails()
                }
            case .failure(let error):
                print("Failed to fetch products:", error)
            }
        }
    }

    private func updatePaymentDetails() {
        let productCount = cartProducts.count
        let sumPrice = cartProducts.reduce(0) { $0 + $1.price }
        let discount = cartProducts.reduce(0) { $0 + ($1.price * $1.discountPercentage / 100) }
        let total = sumPrice - discount

        productCountSumPriceLabel.text = "Products (\(productCount))   $\(String(format: "%.2f", sumPrice))"
        discountLabel.text = String(format: "$%.2f", discount)
        totalLabel.text = String(format: "$%.2f", total)
    }

    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollectionView), name: .cartUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollectionView), name: .favoritesUpdated, object: nil)
    }

    @objc private func reloadCollectionView(notification: Notification) {
        DispatchQueue.main.async {
            self.cartProducts = self.viewModel.getCartProducts()
            self.collectionView.reloadData()
            self.updatePaymentDetails()
        }
    }

    @objc private func checkoutButtonTapped() {
        // Navigate to the checkout page
        let checkoutViewController = CheckoutViewController()
        navigationController?.pushViewController(checkoutViewController, animated: true)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension BasketViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cartProducts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BasketProductCell.identifier, for: indexPath) as! BasketProductCell
        let product = cartProducts[indexPath.row]
        cell.configure(with: product, viewModel: viewModel)
        cell.delegate = self
        return cell
    }
}

extension BasketViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = cartProducts[indexPath.row]
        let productDetailViewController = ProductDetailViewController(product: product)
        navigationController?.pushViewController(productDetailViewController, animated: true)
    }
}

extension BasketViewController: ProductSelectionDelegate {
    func didSelectProduct(_ product: Product) {
        let productDetailViewController = ProductDetailViewController(product: product)
        navigationController?.pushViewController(productDetailViewController, animated: true)
    }
}

extension BasketViewController: BasketProductCellDelegate {
    func didUpdateQuantity(for product: Product, quantity: Int) {
        // Handle quantity update logic here if necessary
        updatePaymentDetails()
    }

    func didRemoveProduct(_ product: Product) {
        if let index = cartProducts.firstIndex(where: { $0.id == product.id }) {
            viewModel.toggleCart(productId: product.id)
            cartProducts.remove(at: index)
            collectionView.performBatchUpdates({
                collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
            }, completion: { _ in
                NotificationCenter.default.post(name: .cartUpdated, object: product.id)
                self.updatePaymentDetails()
            })
        }
    }
}
