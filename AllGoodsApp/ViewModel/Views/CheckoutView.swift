//
//  CheckoutView.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 20.07.24.
//

import SwiftUI
import Combine

struct CheckoutView: View {
    @State var email: String
    @State var phoneNumber: String
    @State var address: String
    @State private var cartProducts: [CartProduct] = []
    @State private var subtotal: Double = 0.0
    @State private var discount: Double = 0.0
    @State private var total: Double = 0.0
    @State private var promoCode: String = ""
    @State private var navigateToSuccess = false

    private let viewModel = ProductViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                userInfoSection
                cartSection
                paymentInformationSection
                promoCodeSection
                payButton
            }
            .padding()
        }
        .navigationTitle("Checkout")
        .onAppear(perform: fetchCartItems)
        .background(
            NavigationLink(destination: SuccessView(), isActive: $navigateToSuccess) {
                EmptyView()
            }
        )
    }

    private var userInfoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "person.fill")
                VStack(alignment: .leading) {
                    Text("RECEIVER")
                        .font(.headline)
                    Text("\(email), \(phoneNumber)")
                }
            }
            Divider()
            HStack {
                Image(systemName: "location.fill")
                VStack(alignment: .leading) {
                    Text("MY DELIVERY ADDRESS")
                        .font(.headline)
                    Text(address)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }

    private var cartSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("CART")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(cartProducts, id: \.product.id) { cartProduct in
                        ZStack(alignment: .bottomTrailing) {
                            if let url = URL(string: cartProduct.product.thumbnail) {
                                AsyncImage(url: url)
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(8)
                            }

                            Text("\(cartProduct.quantity)")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(5)
                                .background(Color.black)
                                .clipShape(Circle())
                                .offset(x: -5, y: -5)
                        }
                    }
                }
            }
            Divider()
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Products (\(cartProducts.reduce(0) { $0 + $1.quantity }))")
                    Spacer()
                    Text(String(format: "%.2f₾", subtotal))
                }
                HStack {
                    Text("Discount")
                    Spacer()
                    Text(String(format: "-%.2f₾", discount))
                }
                HStack {
                    Text("Delivery fee")
                    Spacer()
                    Text("0.00₾")
                        .foregroundColor(.red)
                }
                HStack {
                    Text("TOTAL PRICE")
                        .font(.headline)
                    Spacer()
                    Text(String(format: "%.2f₾", total))
                        .font(.headline)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }

    private var paymentInformationSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("PAYMENT INFORMATION")
                .font(.headline)

            HStack {
                Image("bankLogo") // Replace with your bank logo image
                    .resizable()
                    .frame(width: 40, height: 40)
                    .cornerRadius(8)
                VStack(alignment: .leading) {
                    Text("BANK OF GEORGIA")
                        .font(.headline)
                    Text("VISA / MASTERCARD / AMEX")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                Button(action: {
                    // Edit payment method action
                }) {
                    Image(systemName: "pencil")
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }

    private var promoCodeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Promo Code")
                .font(.headline)
            HStack {
                TextField("Enter promo code", text: $promoCode)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                Button(action: {
                    // Apply promo code action
                }) {
                    Image(systemName: "tag")
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }

    private var payButton: some View {
        Button(action: {
            navigateToSuccess = true
        }) {
            Text("Pay")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .padding(.top)
    }

    private func fetchCartItems() {
        viewModel.fetchAllProducts { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    cartProducts = viewModel.getCartProducts()
                    updatePaymentDetails()
                }
            case .failure(let error):
                print("Failed to fetch products:", error)
            }
        }
    }

    private func updatePaymentDetails() {
        subtotal = cartProducts.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
        discount = cartProducts.reduce(0) { $0 + (($1.product.price * $1.product.discountPercentage / 100) * Double($1.quantity)) }
        total = subtotal - discount
    }
}
