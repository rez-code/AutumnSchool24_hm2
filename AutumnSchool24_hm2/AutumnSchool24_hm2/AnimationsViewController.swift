//
//  AnimationsViewController.swift
//  AutumnSchool24_hm2
//
//  Created by rez on 28.10.2024.
//

import UIKit
import Lottie

final class AnimationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	
	// MARK: - Properties
	private var selectedAnimationIndex: Int? = nil
	
	
	// MARK: - Constants
	private struct Constants: Codable {
		// background
		static let animateInterval: Double = 5.0
		// headerTitle
		static let headerTitleTopInset: CGFloat = 50
		// animations table
		static let animationsNames = ["animation 1", "animation 2", "animation 3"]
		// speed
		static let segmentItemsSpeed = ["0.5x", "1.0x", "2.0x"]
		// color
		static let segmentItemsColor = ["Black", "Grey", "White"]
		// button
		static let cornerRadiusButton: CGFloat = 10
	}
	
	
	// MARK: - UI Elements
	private let gradientLayer = CAGradientLayer()
	private lazy var animationView: LottieAnimationView = LottieAnimationView()
	
	private lazy var headerTitle: UILabel = {
		let label = UILabel()
		label.text = "Выберите анимацию"
		label.font = .systemFont(ofSize: .init(30), weight: .bold)
		label.textColor = .label
		label.textAlignment = .center
		return label
	}()
	
	private lazy var tableAnimations: UITableView = {
		let tableView = UITableView()
		tableView.delegate = self
		tableView.dataSource = self
		tableView.backgroundColor = .clear
		tableView.separatorColor = .label
		tableView.isScrollEnabled = false
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		return tableView
	}()
	
	private lazy var speedTitle: UILabel = {
		let label = UILabel()
		label.text = "Speed"
		label.font = .systemFont(ofSize: 22)
		label.textColor = .label
		label.textAlignment = .center
		return label
	}()
	
	private lazy var speedSegment: UISegmentedControl = {
		let segment = UISegmentedControl(items: Constants.segmentItemsSpeed)
		segment.selectedSegmentIndex = 1
		segment.tintColor = .label
		return segment
	}()
	
	private lazy var colorTitle: UILabel = {
		let label = UILabel()
		label.text = "Color"
		label.font = .systemFont(ofSize: 22)
		label.textColor = .label
		label.textAlignment = .center
		return label
	}()
	
	private lazy var colorSegment: UISegmentedControl = {
		let segment = UISegmentedControl(items: Constants.segmentItemsColor)
		segment.selectedSegmentIndex = 1
		return segment
	}()
	
	private lazy var runButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Запустить", for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 18)
		button.setTitleColor(.white, for: .normal)
		button.backgroundColor = .systemBlue
		button.layer.cornerRadius = Constants.cornerRadiusButton
		button.addTarget(self, action: #selector(runButtonTapped), for: .touchUpInside)
		return button
	}()
	
	private lazy var mainStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [
			headerTitle,
			tableAnimations,
			speedTitle,
			speedSegment,
			colorTitle,
			colorSegment,
			runButton
		])
		stackView.axis = .vertical
		stackView.alignment = .center
		stackView.spacing = 50
		return stackView
	}()
	
	
	// MARK: - View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		gradientLayer.frame = view.bounds
	}
	
	
	// MARK: - Actions
	@objc private func runButtonTapped() {
		guard let selectedIndex = selectedAnimationIndex else {
			showAlert(message: "Анимация не выбрана!")
			return
		}
		
		let animationName = Constants.animationsNames[selectedIndex]
		let speed: CGFloat = [0.5, 1.0, 2.0][speedSegment.selectedSegmentIndex]
		let backgroundColor: UIColor = [.black, .gray, .white][colorSegment.selectedSegmentIndex]
		
		UIView.animate(withDuration: 0.3, animations: {
			self.runButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
		}) { [weak self] _ in
			UIView.animate(withDuration: 0.3, animations: {
				self?.runButton.transform = .identity
			}) { [weak self] _ in
				self?.showAnimationView(animationName: animationName, speed: speed, backgroundColor: backgroundColor)
			}
		}
	}
	
	
	// MARK: - Helper Methods
	private func showAlert(message: String) {
		let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
		present(alert, animated: true, completion: nil)
	}
	
	private func showAnimationView(animationName: String, speed: CGFloat, backgroundColor: UIColor) {
		let animationContainerView = UIView(frame: view.bounds)
		animationContainerView.backgroundColor = backgroundColor
		view.addSubview(animationContainerView)
		
		animationView = LottieAnimationView(name: animationName)
		animationView.frame = animationContainerView.bounds
		animationView.contentMode = .scaleAspectFit
		animationView.animationSpeed = speed
		animationContainerView.addSubview(animationView)
		
		animationView.play { [weak self] _ in
			animationContainerView.removeFromSuperview()
			self?.animationView.removeFromSuperview()
		}
	}
	
	
	// MARK: - Animate Gradient
	private func animateGradient(duration: CFTimeInterval = Constants.animateInterval, repeatCount: Float = .infinity) {
		let colorChangeAnimation = CABasicAnimation(keyPath: "colors")
		colorChangeAnimation.fromValue = [UIColor.blue.cgColor, UIColor.magenta.cgColor]
		colorChangeAnimation.toValue = [UIColor.magenta.cgColor, UIColor.blue.cgColor]
		colorChangeAnimation.duration = duration
		colorChangeAnimation.autoreverses = true
		colorChangeAnimation.repeatCount = repeatCount
		gradientLayer.add(colorChangeAnimation, forKey: "colorChange")
	}
	
	
	// MARK: - UITableViewDataSource
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Constants.animationsNames.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = Constants.animationsNames[indexPath.row]
		cell.textLabel?.font = UIFont.systemFont(ofSize: 22, weight: .regular)
		cell.textLabel?.textColor = .label
		cell.backgroundColor = .clear
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 43
	}
	
	
	// MARK: - UITableViewDelegate
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		selectedAnimationIndex = indexPath.row
	}
	
	
	// MARK: - Setup UI
	private func setupUI() {
		setupGradient()
		setupStackView()
		setupHeader()
		setupTableAnimationsUI()
		setupSpeedControls()
		setupColorControls()
		setupRunButton()
	}
	
	private func setupGradient() {
		gradientLayer.colors = [UIColor.blue.cgColor, UIColor.magenta.cgColor]
		gradientLayer.startPoint = CGPoint(x: 0, y: 0)
		gradientLayer.endPoint = CGPoint(x: 1, y: 1)
		gradientLayer.frame = view.bounds
		view.layer.addSublayer(gradientLayer)
		animateGradient()
	}
	
	private func setupStackView() {
		mainStackView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(mainStackView)
		NSLayoutConstraint.activate([
			mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
			mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
		])
	}
	
	private func setupHeader() {
		headerTitle.textAlignment = .center
		mainStackView.addArrangedSubview(headerTitle)
	}
	
	private func setupTableAnimationsUI() {
		tableAnimations.backgroundColor = .clear
		tableAnimations.separatorColor = .label
		tableAnimations.heightAnchor.constraint(equalToConstant: 133).isActive = true
		tableAnimations.widthAnchor.constraint(equalTo: mainStackView.widthAnchor).isActive = true
		mainStackView.addArrangedSubview(tableAnimations)
	}
	
	private func setupSpeedControls() {
		speedTitle.textAlignment = .center
		mainStackView.addArrangedSubview(speedTitle)
		
		speedSegment.widthAnchor.constraint(equalTo: mainStackView.widthAnchor).isActive = true
		mainStackView.addArrangedSubview(speedSegment)
	}
	
	private func setupColorControls() {
		colorTitle.textAlignment = .center
		mainStackView.addArrangedSubview(colorTitle)
		
		colorSegment.widthAnchor.constraint(equalTo: mainStackView.widthAnchor).isActive = true
		mainStackView.addArrangedSubview(colorSegment)
	}
	
	private func setupRunButton() {
		runButton.widthAnchor.constraint(equalToConstant: 195).isActive = true
		runButton.heightAnchor.constraint(equalToConstant: 49).isActive = true
		mainStackView.addArrangedSubview(runButton)
	}
}


//@available(iOS 17.0, *)
//#Preview {
//	AnimationsViewController()
//}
