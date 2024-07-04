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
    private let nextButton = UIButton(type: .system)
    private let skipButton = UIButton(type: .system)

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
        onboardingPage.titleText = "Easily track your daily transactions"
        onboardingPage.descriptionText = "Comprehensive up-to-date news coverage, aggregated from sources all over the world"
        return onboardingPage
    }

    private func secondOnboardingPage() -> UIViewController {
        let onboardingPage = SecondOnboardingPageViewController()
        onboardingPage.titleText = "Stay updated with the latest news"
        onboardingPage.descriptionText = "Real-time notifications and updates from trusted sources."
        return onboardingPage
    }

    private func thirdOnboardingPage() -> UIViewController {
        let onboardingPage = ThirdOnboardingPageViewController()
        onboardingPage.titleText = "Get started now!"
        onboardingPage.descriptionText = "Sign up and explore the world of seamless transactions."
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
        skipButton.setTitle("Skip", for: .normal)
        skipButton.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)

        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)

        view.addSubview(skipButton)
        view.addSubview(nextButton)

        skipButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false

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
