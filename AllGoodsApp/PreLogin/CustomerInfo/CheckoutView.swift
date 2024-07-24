//
//  CheckoutView.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 23.07.24.
//

import SwiftUI

struct CheckoutView: View {
    @State var email: String
    @State var phoneNumber: String
    @State var address: String
    @State var cartProducts: [CartProduct]
    @State private var subtotal: Double = 0.0
    @State private var discount: Double = 0.0
    @State private var total: Double = 0.0
    @State private var promoCode: String = ""
    @State private var selectedPaymentMethod: String = ""
    @State private var navigateToSuccess = false
    @State private var orderNumber: String = ""
    @State private var showAlert = false
    
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
        .onAppear(perform: updatePaymentDetails)
        .background(
            NavigationLink(destination: SuccessView(orderNumber: orderNumber), isActive: $navigateToSuccess) {
                EmptyView()
            }
        )
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Payment Method Required"), message: Text("Please choose a payment method."), dismissButton: .default(Text("OK")))
        }
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
            Text("Choose a payment method")
                .font(.headline)
            
            HStack {
                Text("Payment to the courier by card")
                Spacer()
                Button(action: {
                    selectedPaymentMethod = "card"
                }) {
                    Image(systemName: selectedPaymentMethod == "card" ? "checkmark.circle.fill" : "circle")
                }
            }
            HStack {
                Text("Payment to the courier in cash")
                Spacer()
                Button(action: {
                    selectedPaymentMethod = "cash"
                }) {
                    Image(systemName: selectedPaymentMethod == "cash" ? "checkmark.circle.fill" : "circle")
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
                TextField("Enter promo code", text: $promoCode, onCommit: applyPromoCode)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                Button(action: applyPromoCode) {
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
            if selectedPaymentMethod.isEmpty {
                showAlert = true
            } else {
                orderNumber = generateOrderNumber()
                let order = Order(orderNumber: orderNumber,
                                  productThumbnail: cartProducts.first?.product.thumbnail ?? "",
                                  customerEmail: email,
                                  customerPhoneNumber: phoneNumber,
                                  date: getCurrentDate(),
                                  amount: String(format: "%.2f₾", total))
                
                SharedStorage.shared.addOrder(order)
                navigateToSuccess = true
            }
        }) {
            Text("Pay \(String(format: "%.2f₾", total))")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .padding(.top)
    }
    
    private func updatePaymentDetails() {
        subtotal = cartProducts.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
        discount = cartProducts.reduce(0) { $0 + (($1.product.price * $1.product.discountPercentage / 100) * Double($1.quantity)) }
        total = subtotal - discount
        applyPromoCode()  // Re-apply promo code when updating payment details
    }
    
    private func applyPromoCode() {
        if promoCode == "Get10" {
            let promoDiscount = subtotal * 0.1
            discount += promoDiscount
            total = subtotal - discount
        } else {
            // Recalculate discount without promo code
            discount = cartProducts.reduce(0) { $0 + (($1.product.price * $1.product.discountPercentage / 100) * Double($1.quantity)) }
            total = subtotal - discount
        }
    }
    
    private func generateOrderNumber() -> String {
        return String(format: "%04d", Int.random(in: 0...9999))
    }
    
    private func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: Date())
    }
}
