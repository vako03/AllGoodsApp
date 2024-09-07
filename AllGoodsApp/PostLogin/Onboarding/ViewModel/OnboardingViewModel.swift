//
//  OnboardingViewModel.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 07.09.24.
//

import Foundation
import UIKit

class OnboardingViewModel {
    private let coordinator: AppCoordinator
    private(set) var currentPageIndex: Int = 0
    let orderedPages: [OnboardingPageViewModel]

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        self.orderedPages = [
            OnboardingPageViewModel(title: "Discover the Best Deals", description: "Unlock exclusive discounts and offers on your favorite products.", imageName: "FirstOnboard"),
            OnboardingPageViewModel(title: "Your Style, Your Way", description: "Explore a wide range of categories to match your unique taste and lifestyle.", imageName: "SecondOnboard"),
            OnboardingPageViewModel(title: "Shopping Made Simple", description: "Enjoy a hassle-free shopping experience with easy navigation and quick checkout.", imageName: "ThirdOnboard")
        ]
    }

    var totalPages: Int {
        return orderedPages.count
    }

    func nextPage() -> UIViewController? {
        currentPageIndex += 1
        guard currentPageIndex < orderedPages.count else {
            coordinator.showLogin()
            return nil
        }
        return viewControllerForPage(at: currentPageIndex)
    }

    func previousPage() -> UIViewController? {
        currentPageIndex -= 1
        guard currentPageIndex >= 0 else {
            return nil
        }
        return viewControllerForPage(at: currentPageIndex)
    }

    func viewControllerForPage(at index: Int) -> UIViewController {
        let pageViewModel = orderedPages[index]
        let pageVC = OnboardingPageViewController(viewModel: pageViewModel)
        return pageVC
    }

    func skipOnboarding() {
        coordinator.showLogin()
    }

    func isLastPage() -> Bool {
        return currentPageIndex == orderedPages.count - 1
    }
}

class OnboardingPageViewModel {
    let title: String
    let description: String
    let imageName: String

    init(title: String, description: String, imageName: String) {
        self.title = title
        self.description = description
        self.imageName = imageName
    }
}

