//
//  ViewController.swift
//  AutumnSchool24_hm2
//
//  Created by rez on 28.10.2024.
//

import UIKit

final class AnimationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	// MARK: - Constants
	private enum Constants {
		// background
		static let animateInterval: Double = 5.0
		// headerTitle
		static let headerTitleTopInset: CGFloat = 50
		// animations table
		static let animations = ["animation 1", "animation 2", "animation 3"]
		// speed
		static let segmentItemsSpeed = ["0.5x", "1.0x", "2.0x"]
		// color
		static let segmentItemsColor = ["Black", "Grey", "White"]
		// button
		static let cornerRadiusButton: CGFloat = 10
	}
	
	// MARK: - Private methods
	
	private let gradientLayer = CAGradientLayer()
	
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
	
	// MARK: - Actions
	@objc private func runButtonTapped() {
		
	}
	
	// MARK: - animateGradient
	private func animateGradient(duration: CFTimeInterval = Constants.animateInterval, repeatCount: Float = .infinity) {
		let colorChangeAnimation = CABasicAnimation(keyPath: "colors")
		colorChangeAnimation.fromValue = [UIColor.blue.cgColor, UIColor.magenta.cgColor]
		colorChangeAnimation.toValue = [UIColor.magenta.cgColor, UIColor.blue.cgColor]
		colorChangeAnimation.duration = duration
		colorChangeAnimation.autoreverses = true
		colorChangeAnimation.repeatCount = repeatCount
		gradientLayer.add(colorChangeAnimation, forKey: "colorChange")
	}
	
	
	// MARK: - numberOfRowsInSection
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Constants.animations.count
	}
	
	// MARK: - heightForRowAt
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 43
	}
	
	// MARK: - cellForRowAt
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = Constants.animations[indexPath.row]
		cell.textLabel?.font = UIFont.systemFont(ofSize: 22, weight: .regular)
		cell.textLabel?.textColor = .label
		cell.backgroundColor = .clear
		return cell
	}
	
	// MARK: - setupUi
	private func setupUi() {
		setupGradient()
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

	private func setupHeader() {
		headerTitle.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(headerTitle)
		NSLayoutConstraint.activate([
			headerTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			headerTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.headerTitleTopInset)
		])
	}

	private func setupTableAnimationsUI() {
		tableAnimations.backgroundColor = .clear
		tableAnimations.separatorColor = .black
		tableAnimations.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(tableAnimations)
		NSLayoutConstraint.activate([
			tableAnimations.topAnchor.constraint(equalTo: headerTitle.bottomAnchor, constant: 56),
			tableAnimations.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			tableAnimations.widthAnchor.constraint(equalToConstant: 300),
			tableAnimations.heightAnchor.constraint(equalToConstant: 133)
		])
	}
	
	private func setupSpeedControls() {
		speedTitle.textAlignment = .center
		speedTitle.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(speedTitle)
		NSLayoutConstraint.activate([
			speedTitle.topAnchor.constraint(equalTo: tableAnimations.bottomAnchor, constant: 56),
			speedTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])
		
		speedSegment.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(speedSegment)
		NSLayoutConstraint.activate([
			speedSegment.topAnchor.constraint(equalTo: speedTitle.bottomAnchor, constant: 24),
			speedSegment.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			speedSegment.widthAnchor.constraint(equalToConstant: 300)
		])
	}
	
	private func setupColorControls() {
		colorTitle.textAlignment = .center
		colorTitle.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(colorTitle)
		NSLayoutConstraint.activate([
			colorTitle.topAnchor.constraint(equalTo: speedSegment.bottomAnchor, constant: 56),
			colorTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])
		
		colorSegment.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(colorSegment)
		NSLayoutConstraint.activate([
			colorSegment.topAnchor.constraint(equalTo: colorTitle.bottomAnchor, constant: 24),
			colorSegment.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			colorSegment.widthAnchor.constraint(equalToConstant: 300)
		])
	}
	
	private func setupRunButton() {
		runButton.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(runButton)
		NSLayoutConstraint.activate([
			runButton.topAnchor.constraint(equalTo: colorSegment.bottomAnchor, constant: 56),
			runButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			runButton.widthAnchor.constraint(equalToConstant: 195),
			runButton.heightAnchor.constraint(equalToConstant: 49)
		])
	}
	
	// MARK: - viewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUi()
		
	}
	
	// MARK: - viewDidLayoutSubviews
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		gradientLayer.frame = view.bounds
	}
}
