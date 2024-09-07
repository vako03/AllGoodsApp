//
//  OnboardingVC.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 07.09.24.
//

import Foundation
import UIKit

final class OnboardingViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    var viewModel: OnboardingViewModel!
    

    private let pageControl = UIPageControl()
    private lazy var nextButton = CustomButton(title: "Next") { [weak self] in
        self?.nextTapped()
    }
    private lazy var skipButton = CustomButton(title: "Skip") { [weak self] in
        self?.skipTapped()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self

        let firstViewController = viewModel.viewControllerForPage(at: 0)
        setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)

        setupPageControl()
        setupButtons()
    }

    private func setupPageControl() {
        pageControl.numberOfPages = viewModel.totalPages
        pageControl.currentPage = viewModel.currentPageIndex
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
        view.addSubview(skipButton)
        view.addSubview(nextButton)

        skipButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 80).isActive = true

        NSLayoutConstraint.activate([
            skipButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            skipButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),

            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60)
        ])
    }

    private func skipTapped() {
        viewModel.skipOnboarding()
    }

    private func nextTapped() {
        guard let nextViewController = viewModel.nextPage() else { return }

        setViewControllers([nextViewController], direction: .forward, animated: true, completion: { [weak self] completed in
            if completed {
                self?.pageControl.currentPage = self?.viewModel.currentPageIndex ?? 0
                self?.updateNextButtonTitle()
            }
        })
    }

    private func updateNextButtonTitle() {
        if viewModel.isLastPage() {
            nextButton.setTitle("Start", for: .normal)
        } else {
            nextButton.setTitle("Next", for: .normal)
        }
    }

    // MARK: UIPageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return viewModel.previousPage()
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return viewModel.nextPage()
    }
}

class OnboardingPageViewController: UIViewController {
    private var viewModel: OnboardingPageViewModel

    private let titleLabel = CustomLabel(text: "", fontSize: 24, textColor: .black, alignment: .center)
    private let descriptionLabel = CustomLabel(text: "", fontSize: 16, textColor: .gray, alignment: .center)
    private let imageView = CustomImageView(image: nil)

    init(viewModel: OnboardingPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Set initial state for animation here, before the view appears.
        setInitialAnimationState()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Start the animation after the view has appeared.
        applyAnimation()
    }

    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20

        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 250),
            imageView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }

    private func bindViewModel() {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        imageView.image = UIImage(named: viewModel.imageName)
    }

    // MARK: - Set Initial Animation State
    private func setInitialAnimationState() {
        // Set different initial states based on the image
        switch viewModel.imageName {
        case "FirstOnboard":
            imageView.transform = CGAffineTransform(translationX: 0, y: -view.bounds.height) // Start from offscreen (above)
        case "SecondOnboard":
            imageView.transform = CGAffineTransform(translationX: view.bounds.width, y: 0) // Start from offscreen (right)
        case "ThirdOnboard":
            imageView.transform = CGAffineTransform(translationX: 0, y: -view.bounds.height) // Start from offscreen (above)
        default:
            imageView.transform = .identity
        }
    }

    // MARK: - Apply Animation After View Appears
    private func applyAnimation() {
        switch viewModel.imageName {
        case "FirstOnboard":
            animateParcelImage()  // The first page animation
        case "SecondOnboard":
            animateImage3D()      // The second page animation
        case "ThirdOnboard":
            animateShoppingImage() // The third page animation
        default:
            break
        }
    }

    // MARK: - First Onboarding Animation (Move and Wiggle)
    private func animateParcelImage() {
        UIView.animate(withDuration: 2.0, delay: 0, options: [.curveEaseInOut], animations: {
            self.imageView.transform = .identity  // Move to final position (on screen)
        }, completion: { _ in
            self.moveImageSideways()
        })
    }

    private func moveImageSideways() {
        UIView.animate(withDuration: 1.0, delay: 0, options: [.autoreverse, .repeat, .curveEaseInOut], animations: {
            self.imageView.transform = CGAffineTransform(translationX: 20, y: 0)
        })
    }

    // MARK: - Second Onboarding Animation (3D Spin)
    private func animateImage3D() {
        UIView.animate(withDuration: 2.0, delay: 0, options: [.curveEaseInOut], animations: {
            self.imageView.transform = .identity  // Move to final position (on screen)
        }, completion: { _ in
            self.spinImage3D()
        })
    }

    private func spinImage3D() {
        UIView.animate(withDuration: 1.0, delay: 0, options: [.autoreverse, .repeat, .curveEaseInOut], animations: {
            self.imageView.transform = CGAffineTransform(rotationAngle: -.pi / 9)  // Rotate left
        }, completion: { _ in
            UIView.animate(withDuration: 1.0, delay: 0, options: [.autoreverse, .repeat, .curveEaseInOut], animations: {
                self.imageView.transform = CGAffineTransform(rotationAngle: .pi / 9)  // Rotate right
            })
        })
    }

    // MARK: - Third Onboarding Animation (Shake Effect)
    private func animateShoppingImage() {
        UIView.animate(withDuration: 2.0, delay: 0, options: [.curveEaseInOut], animations: {
            self.imageView.transform = .identity  // Move to final position (on screen)
        }, completion: { _ in
            self.shakeShoppingImage()
        })
    }

    private func shakeShoppingImage() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.autoreverse, .repeat, .curveEaseInOut], animations: {
            self.imageView.transform = CGAffineTransform(translationX: 10, y: 0)
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 0, options: [.autoreverse, .repeat, .curveEaseInOut], animations: {
                self.imageView.transform = CGAffineTransform(translationX: -10, y: 0)
            })
        })
    }
}
