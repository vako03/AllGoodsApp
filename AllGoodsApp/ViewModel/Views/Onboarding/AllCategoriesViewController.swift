//
//  AllCategoriesViewController.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 11.07.24.
//
//
import UIKit

class AllCategoriesViewController: UIViewController {
    private let categories: [String]
    private var tableView: UITableView!
    
    init(categories: [String]) {
        self.categories = categories.sorted()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "All Categories"
        setupTableView()
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryCell")
        view.addSubview(tableView)
    }
}

extension AllCategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.capitalized
        cell.imageView?.image = UIImage(named: "placeholder") // Replace with actual category image
        return cell
    }
}

extension AllCategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = categories[indexPath.row]
        // Handle navigation to products in selected category
        // You might need to fetch products for the selected category again if needed
    }
}
