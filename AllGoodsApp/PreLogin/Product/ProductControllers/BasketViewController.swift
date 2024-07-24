//
//  BasketViewController.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 09.07.24.
//

import UIKit
import SwiftUI
import FirebaseAuth

class BasketViewController: UIViewController {
    var coordinator: AppCoordinator?
    private let viewModel = ProductViewModel()
    private var collectionView: UICollectionView!
    private var cartProducts: [CartProduct] = []

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var collectionViewHeightConstraint: NSLayoutConstraint!

    private let titleLabel = UILabel()
    private let productCountLabel = UILabel()
    private let sumPriceLabel = UILabel()
    private let discountLabel = UILabel()
    private let totalLabel = UILabel()
    private let checkoutButton = UIButton(type: .system)
    private let paymentDetailsStack = UIStackView()

    private let emptyCartView = UIView()
    private let emptyCartIcon = UIImageView(image: UIImage(named: "empty-cart"))
    private let emptyCartLabel = UILabel()

    private var loadingIndicator: UIActivityIndicatorView!  

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Basket"
        
        setupScrollView()
        setupEmptyCartView()
        setupCollectionView()
        setupPaymentDetailsView()
        setupLoadingIndicator()
        fetchCartItems()
        setupNotificationObservers()
    }

    // MARK: - UI Setup
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupEmptyCartView() {
        emptyCartView.translatesAutoresizingMaskIntoConstraints = false
        emptyCartIcon.contentMode = .scaleAspectFit
        emptyCartIcon.translatesAutoresizingMaskIntoConstraints = false

        emptyCartLabel.text = "Your cart is empty"
        emptyCartLabel.font = UIFont.systemFont(ofSize: 18)
        emptyCartLabel.textColor = .gray
        emptyCartLabel.textAlignment = .center
        emptyCartLabel.translatesAutoresizingMaskIntoConstraints = false

        emptyCartView.addSubview(emptyCartIcon)
        emptyCartView.addSubview(emptyCartLabel)
        contentView.addSubview(emptyCartView)

        NSLayoutConstraint.activate([
            emptyCartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emptyCartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emptyCartView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 100),
            
            emptyCartIcon.centerXAnchor.constraint(equalTo: emptyCartView.centerXAnchor),
            emptyCartIcon.topAnchor.constraint(equalTo: emptyCartView.topAnchor),
            emptyCartIcon.widthAnchor.constraint(equalToConstant: 100),
            emptyCartIcon.heightAnchor.constraint(equalToConstant: 100),
            
            emptyCartLabel.topAnchor.constraint(equalTo: emptyCartIcon.bottomAnchor, constant: 16),
            emptyCartLabel.leadingAnchor.constraint(equalTo: emptyCartView.leadingAnchor),
            emptyCartLabel.trailingAnchor.constraint(equalTo: emptyCartView.trailingAnchor),
            
            emptyCartLabel.bottomAnchor.constraint(equalTo: emptyCartView.bottomAnchor)
        ])
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width, height: 150)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(BasketProductCell.self, forCellWithReuseIdentifier: BasketProductCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(collectionView)
        
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 0)
        collectionViewHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    private func setupPaymentDetailsView() {
        titleLabel.text = "Payment"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        productCountLabel.font = UIFont.systemFont(ofSize: 16)
        productCountLabel.textColor = .black
        productCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        sumPriceLabel.font = UIFont.systemFont(ofSize: 16)
        sumPriceLabel.textColor = .black
        sumPriceLabel.textAlignment = .right
        sumPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        discountLabel.font = UIFont.systemFont(ofSize: 16)
        discountLabel.textColor = .black
        discountLabel.textAlignment = .right
        discountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        totalLabel.font = UIFont.boldSystemFont(ofSize: 16)
        totalLabel.textColor = .black
        totalLabel.textAlignment = .right
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let productCountSumPriceStack = UIStackView(arrangedSubviews: [productCountLabel, sumPriceLabel])
        productCountSumPriceStack.axis = .horizontal
        productCountSumPriceStack.distribution = .fill
        productCountSumPriceStack.alignment = .fill
        productCountSumPriceStack.translatesAutoresizingMaskIntoConstraints = false
        
        let discountStack = createPaymentDetailStack(title: "Discount:", valueLabel: discountLabel)
        let totalStack = createPaymentDetailStack(title: "Total price:", valueLabel: totalLabel, isBold: true)
        
        paymentDetailsStack.axis = .vertical
        paymentDetailsStack.spacing = 16
        paymentDetailsStack.translatesAutoresizingMaskIntoConstraints = false
        paymentDetailsStack.addArrangedSubview(titleLabel)
        paymentDetailsStack.addArrangedSubview(productCountSumPriceStack)
        paymentDetailsStack.addArrangedSubview(createSeparator())
        paymentDetailsStack.addArrangedSubview(discountStack)
        paymentDetailsStack.addArrangedSubview(createSeparator())
        paymentDetailsStack.addArrangedSubview(totalStack)
        contentView.addSubview(paymentDetailsStack)
        
        checkoutButton.setTitle("Checkout", for: .normal)
        checkoutButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        checkoutButton.backgroundColor = .black
        checkoutButton.setTitleColor(.white, for: .normal)
        checkoutButton.layer.cornerRadius = 25
        checkoutButton.addTarget(self, action: #selector(checkoutButtonTapped), for: .touchUpInside)
        checkoutButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(checkoutButton)
        
        NSLayoutConstraint.activate([
            paymentDetailsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            paymentDetailsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            paymentDetailsStack.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            
            checkoutButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            checkoutButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkoutButton.topAnchor.constraint(equalTo: paymentDetailsStack.bottomAnchor, constant: 16),
            checkoutButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            checkoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            productCountLabel.leadingAnchor.constraint(equalTo: productCountSumPriceStack.leadingAnchor),
            sumPriceLabel.trailingAnchor.constraint(equalTo: productCountSumPriceStack.trailingAnchor)
        ])
        
        paymentDetailsStack.isHidden = true
        checkoutButton.isHidden = true
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

    private func setupLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true

        view.addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // MARK: - Data Fetching
    private func fetchCartItems() {
        loadingIndicator.startAnimating()
        viewModel.fetchAllProducts { [weak self] result in
            DispatchQueue.main.async {
                self?.loadingIndicator.stopAnimating()
                switch result {
                case .success:
                    self?.cartProducts = self?.viewModel.getCartProducts() ?? []
                    self?.collectionView.reloadData()
                    self?.updateCollectionViewHeight()
                    self?.updatePaymentDetails()
                case .failure(let error):
                    print("Failed to fetch products:", error)
                }
            }
        }
    }

    private func updateCollectionViewHeight() {
        let itemCount = cartProducts.count
        let itemHeight: CGFloat = 150.0
        let totalHeight = CGFloat(itemCount) * itemHeight
        collectionViewHeightConstraint.constant = totalHeight

        if itemCount == 0 {
            emptyCartView.isHidden = false
            collectionView.isHidden = true
            paymentDetailsStack.isHidden = true
            checkoutButton.isHidden = true
        } else {
            emptyCartView.isHidden = true
            collectionView.isHidden = false
            paymentDetailsStack.isHidden = false
            checkoutButton.isHidden = false
        }
    }

    private func updatePaymentDetails() {
        let productCount = cartProducts.reduce(0) { $0 + $1.quantity }
        let sumPrice = cartProducts.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
        let discount = cartProducts.reduce(0) { $0 + (($1.product.price * $1.product.discountPercentage / 100) * Double($1.quantity)) }
        let total = sumPrice - discount
        
        productCountLabel.text = "Products (\(productCount))"
        sumPriceLabel.text = "$\(String(format: "%.2f", sumPrice))"
        discountLabel.text = String(format: "$%.2f", discount)
        totalLabel.text = String(format: "$%.2f", total)
    }

    // MARK: - Notifications
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollectionView), name: .cartUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollectionView), name: .favoritesUpdated, object: nil)
    }

    @objc private func reloadCollectionView(notification: Notification) {
        DispatchQueue.main.async {
            self.cartProducts = self.viewModel.getCartProducts()
            self.collectionView.reloadData()
            self.updateCollectionViewHeight()
            self.updatePaymentDetails()
        }
    }

    @objc private func checkoutButtonTapped() {
        guard let currentUser = Auth.auth().currentUser, currentUser.displayName != "Guest" else {
            coordinator?.showLoginAlert()
            return
        }
        let nickname = currentUser.displayName ?? "Guest"
        let email = currentUser.email ?? ""
        
        let contactInformationView = ContactInformationView(nickname: nickname, email: email, cartProducts: cartProducts)
        let hostingController = UIHostingController(rootView: contactInformationView)
        navigationController?.pushViewController(hostingController, animated: true)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UICollectionViewDataSource
extension BasketViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cartProducts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BasketProductCell.identifier, for: indexPath) as! BasketProductCell
        let cartProduct = cartProducts[indexPath.row]
        cell.configure(with: cartProduct, viewModel: viewModel)
        cell.delegate = self
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension BasketViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cartProduct = cartProducts[indexPath.row]
        let productDetailViewController = ProductDetailViewController(product: cartProduct.product)
        navigationController?.pushViewController(productDetailViewController, animated: true)
    }
}

// MARK: - BasketProductCellDelegate
extension BasketViewController: BasketProductCellDelegate {
    func didUpdateQuantity(for product: Product, quantity: Int) {
        if let index = cartProducts.firstIndex(where: { $0.product.id == product.id }) {
            cartProducts[index].quantity = quantity
            collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
            updateCollectionViewHeight()
            updatePaymentDetails()
        }
    }

    func didRemoveProduct(_ product: Product) {
        if let index = cartProducts.firstIndex(where: { $0.product.id == product.id }) {
            viewModel.toggleCart(productId: product.id)
            cartProducts.remove(at: index)
            collectionView.performBatchUpdates({
                collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
            }, completion: { _ in
                NotificationCenter.default.post(name: .cartUpdated, object: product.id)
                self.updateCollectionViewHeight()
                self.updatePaymentDetails()
            })
        }
    }
}
