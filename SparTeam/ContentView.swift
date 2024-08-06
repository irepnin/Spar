//
//  ContentView.swift
//  SparTeam
//
//  Created by Иван on 06.08.2024.
//

import SwiftUI

struct Product: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let price: Double
}

let mockProducts = [
    Product(name: "сыр Ламбер", imageName: "product1", price: 99.90),
    Product(name: "Энергетический напиток", imageName: "product2", price: 199.0),
    Product(name: "Салат овощной с крабовыми палочками", imageName: "product3", price: 250.90),
    Product(name: "Дорадо охлажденная непотрошеная", imageName: "product4", price: 592.00),
    Product(name: "Ролл маленькая Япония", imageName: "product5", price: 367.90),
    Product(name: "Огурцы тепличные садово-огородные", imageName: "product6", price: 69.2),
    Product(name: "Манго Кео", imageName: "product7", price: 1298.90),
    Product(name: "Салат овощной с крабовыми палочками", imageName: "product8", price: 120.90),
    Product(name: "Салат овощной с крабовыми палочками", imageName: "product9", price: 1298.90),
    Product(name: "Масло слобода рафинированное", imageName: "product10", price: 1298.90),
    Product(name: "Салат овощной с крабовыми палочками", imageName: "product11", price: 250.00),
    Product(name: "Макаронные изделия Spar Спагетти", imageName: "product12", price: 2600.90),
    Product(name: "Яблоки", imageName: "product13", price: 120.90),
    Product(name: "Хлеб", imageName: "product14", price: 120.90),
    // Добавьте больше продуктов по необходимости
]

class ProductViewModel: ObservableObject {
    @Published var products = mockProducts
    @Published var isGridView = true
}

class Cart: ObservableObject {
    @Published var items: [Product] = []

    func addToCart(product: Product) {
        items.append(product)
    }
}


struct CartView: View {
    @EnvironmentObject var cart: Cart

    var body: some View {
        NavigationView {
            List {
                ForEach(cart.items) { product in
                    HStack {
                        Image(product.imageName)
                            .resizable()
                            .frame(width: 50, height: 50)
                        VStack(alignment: .leading) {
                            Text(product.name)
                            Text(String(format: "₽%.2f", product.price))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Корзина")
        }
    }
}


struct GridView: View {
    let products: [Product]
    @Binding var currentIndex: Int
    @EnvironmentObject var cart: Cart

    var body: some View {
        ScrollViewReader { proxy in
            VStack {
                HStack {
                    Button(action: {
                        if currentIndex > 0 {
                            currentIndex -= 1
                            proxy.scrollTo(products[currentIndex].id, anchor: .top)
                        }
                    }) {
                        Image(systemName: "chevron.up")
                    }
                    Spacer()
                    Button(action: {
                        if currentIndex < products.count - 1 {
                            currentIndex += 1
                            proxy.scrollTo(products[currentIndex].id, anchor: .top)
                        }
                    }) {
                        Image(systemName: "chevron.down")
                    }
                }
                .padding()

                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(products) { product in
                            VStack {
                                Image(product.imageName)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                Text(product.name)
                                Text(String(format: "₽%.2f", product.price))
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Button(action: {
                                    cart.addToCart(product: product)
                                }) {
                                    Text("Добавить в корзину")
                                        .padding()
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                            }
                            .id(product.id)
                        }
                    }
                }
            }
        }
    }
}





struct ListView: View {
    let products: [Product]
    @Binding var currentIndex: Int
    @EnvironmentObject var cart: Cart

    var body: some View {
        ScrollViewReader { proxy in
            VStack {
                HStack {
                    Button(action: {
                        if currentIndex > 0 {
                            currentIndex -= 1
                            proxy.scrollTo(products[currentIndex].id, anchor: .top)
                        }
                    }) {
                        Image(systemName: "chevron.up")
                    }
                    Spacer()
                    Button(action: {
                        if currentIndex < products.count - 1 {
                            currentIndex += 1
                            proxy.scrollTo(products[currentIndex].id, anchor: .top)
                        }
                    }) {
                        Image(systemName: "chevron.down")
                    }
                }
                .padding()

                ScrollView {
                    LazyVStack {
                        ForEach(products) { product in
                            HStack {
                                Image(product.imageName)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                VStack(alignment: .leading) {
                                    Text(product.name)
                                    Text(String(format: "₽%.2f", product.price))
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Button(action: {
                                    cart.addToCart(product: product)
                                }) {
                                    Text("Добавить в корзину")
                                        .padding()
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                            }
                            .id(product.id)
                        }
                    }
                }
            }
        }
    }
}




struct ContentView: View {
    @StateObject private var viewModel = ProductViewModel()
    @State private var currentIndex = 0
    @StateObject private var cart = Cart()

    var body: some View {
        NavigationView {
            VStack {
                Picker("View Mode", selection: $viewModel.isGridView) {
                    Image(systemName: "square.grid.2x2").tag(true)
                    Image(systemName: "list.bullet").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                if viewModel.isGridView {
                    GridView(products: viewModel.products, currentIndex: $currentIndex)
                        .environmentObject(cart)
                } else {
                    ListView(products: viewModel.products, currentIndex: $currentIndex)
                        .environmentObject(cart)
                }

                NavigationLink(destination: CartView().environmentObject(cart)) {
                    Text("Корзина")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
            .navigationTitle("Магазин")
        }
    }
}





