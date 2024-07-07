//
//  OnboardingViewController.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 04.07.24.
//

import UIKit

class OnboardingViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    var coordinator: AppCoordinator?

    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [
            self.firstOnboardingPage(),
            self.secondOnboardingPage(),
            self.thirdOnboardingPage()
        ]
    }()

    private let pageControl = UIPageControl()
    private let nextButton = CustomButton(title: "Next")
    private let skipButton = CustomButton(title: "Skip")

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self

        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }

        setupPageControl()
        setupButtons()
    }

    private func firstOnboardingPage() -> UIViewController {
        let onboardingPage = FirstOnboardingPageViewController()
        onboardingPage.titleText = "Discover the Best Deals"
        onboardingPage.descriptionText = "Unlock exclusive discounts and offers on your favorite products."
        return onboardingPage
    }

    private func secondOnboardingPage() -> UIViewController {
        let onboardingPage = SecondOnboardingPageViewController()
        onboardingPage.titleText = "Your Style, Your Way"
        onboardingPage.descriptionText = "Explore a wide range of categories to match your unique taste and lifestyle."
        return onboardingPage
    }

    private func thirdOnboardingPage() -> UIViewController {
        let onboardingPage = ThirdOnboardingPageViewController()
        onboardingPage.titleText = "Shopping Made Simple"
        onboardingPage.descriptionText = "Enjoy a hassle-free shopping experience with easy navigation and quick checkout."
        onboardingPage.coordinator = coordinator
        return onboardingPage
    }

    private func setupPageControl() {
        pageControl.numberOfPages = orderedViewControllers.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(pageControl)

        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setupButtons() {
        skipButton.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)

        view.addSubview(skipButton)
        view.addSubview(nextButton)

        NSLayoutConstraint.activate([
            skipButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            skipButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),

            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60)
        ])
    }

    @objc private func skipTapped() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        coordinator?.showLogin()
    }

    @objc private func nextTapped() {
        guard let currentViewController = viewControllers?.first,
              let nextViewController = pageViewController(self, viewControllerAfter: currentViewController) else {
            return
        }

        setViewControllers([nextViewController], direction: .forward, animated: true, completion: { [weak self] completed in
            if completed, let index = self?.orderedViewControllers.firstIndex(of: nextViewController) {
                self?.pageControl.currentPage = index
                self?.updateNextButtonTitle(for: index)
            }
        })
    }

    private func updateNextButtonTitle(for index: Int) {
        if index == orderedViewControllers.count - 1 {
            nextButton.setTitle("Start", for: .normal)
            nextButton.removeTarget(self, action: #selector(nextTapped), for: .touchUpInside)
            nextButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        } else {
            nextButton.setTitle("Next", for: .normal)
            nextButton.removeTarget(self, action: #selector(startTapped), for: .touchUpInside)
            nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        }
    }

    @objc private func startTapped() {
        coordinator?.showLogin()
    }

    // MARK: UIPageViewControllerDataSource

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else {
            return nil
        }

        guard orderedViewControllers.count > previousIndex else {
            return nil
        }

        return orderedViewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }

        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count

        guard orderedViewControllersCount != nextIndex else {
            return nil
        }

        guard orderedViewControllersCount > nextIndex else {
            return nil
        }

        return orderedViewControllers[nextIndex]
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 0 // Returning 0 here hides the default page control.
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }

    // MARK: UIPageViewControllerDelegate

    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let pendingViewController = pendingViewControllers.first,
           let index = orderedViewControllers.firstIndex(of: pendingViewController) {
            pageControl.currentPage = index
            updateNextButtonTitle(for: index)
        }
    }
}
