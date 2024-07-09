//
//  BasketViewController.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 09.07.24.
//

import UIKit

class BasketViewController: UIViewController {
    var coordinator: AppCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Basket"
    }
}
