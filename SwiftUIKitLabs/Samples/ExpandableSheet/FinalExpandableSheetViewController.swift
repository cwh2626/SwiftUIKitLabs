//
//  FinalExpandableSheetViewController.swift
//  SwiftUIKitLabs
//
//  Created by johnny on 5/14/24.
//

import UIKit

class FinalExpandableSheetViewController: UIViewController {
    private var currentTransform: CGAffineTransform?
    private let maxCornerRadius: CGFloat = 16
    private let heightTopContentView: CGFloat = 162
    private var panGestureRecognizer: UIPanGestureRecognizer?
    
    private let topContentView : UIView = {
        let view = UIView()
        view.backgroundColor = .purple
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let contentInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        collectionView.contentInset = contentInset
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        return collectionView
    }()
    
    private let mainContentVStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.clipsToBounds = true
        stackView.layer.cornerRadius = 16
        stackView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return stackView
    }()
    
    private lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderTopPadding = 0
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        panGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                          action: #selector(self.handlePanGesture(_:)))
        panGestureRecognizer?.delegate = self
        tableView.addGestureRecognizer(panGestureRecognizer!)
        return tableView
    }()
    
    private lazy var headerView : UIView = {
        let view = UIView()
        view.backgroundColor = .red
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAddView()
        setupConstaints()
        initialTransformSetup()
    }
    
    private func initialTransformSetup() {
        mainContentVStackView.transform = CGAffineTransform(translationX: 0, y: heightTopContentView)
        navigationController?.navigationBar.setAppearance(.white.withAlphaComponent(0))
    }
    
    private func setupAddView() {
        view.backgroundColor = .purple
        view.addSubview(topContentView)
        view.addSubview(mainContentVStackView)
        
        topContentView.addSubview(collectionView)
        
        mainContentVStackView.addArrangedSubview(tableView)
    }
    
    private func setupConstaints() {
        topContentView.snp.makeConstraints {
            $0.height.equalTo(heightTopContentView)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        mainContentVStackView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    private func animateToExpandedState() {

        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.2,
                       options: [.curveEaseInOut],
                       animations: {
            self.mainContentVStackView.transform = CGAffineTransform(translationX: 0, y: self.heightTopContentView)
            self.mainContentVStackView.layer.cornerRadius = self.maxCornerRadius
            self.navigationController?.navigationBar.setAppearance(.white.withAlphaComponent(0))
        }, completion: nil)
    }
    
    private func animateToCollapsedState() {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0.2,
                       options: [.curveEaseIn],
                       animations: {
            self.mainContentVStackView.transform = .identity
            self.mainContentVStackView.layer.cornerRadius = 0
            self.navigationController?.navigationBar.setAppearance(.white.withAlphaComponent(1))
        }, completion: nil)
    }
    
    // MARK: - Action Methods
    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)

        guard tableView.contentOffset.y <= 0 else {
            recognizer.setTranslation(CGPoint.zero, in: view)
            currentTransform = mainContentVStackView.transform
            return
        }
        
        switch recognizer.state {
        case .began:
            currentTransform = mainContentVStackView.transform
        case .changed:
            let potentialTransform = currentTransform!.translatedBy(x: 0, y: translation.y)
            let limitedY = max(0, min(potentialTransform.ty, heightTopContentView))
            
            let cornerRadius = (limitedY / heightTopContentView) * maxCornerRadius
            let alpha = 1 - (limitedY / heightTopContentView)
            
            mainContentVStackView.transform = CGAffineTransform(translationX: 0, y: limitedY)
            mainContentVStackView.layer.cornerRadius = cornerRadius
            self.navigationController?.navigationBar.setAppearance(.white.withAlphaComponent(alpha))
            
        case .ended, .cancelled:
            if heightTopContentView / 2 <= mainContentVStackView.transform.ty {
                animateToExpandedState()
            } else {
                animateToCollapsedState()
            }
        default:
            break
        }
    }
}

extension FinalExpandableSheetViewController:
    UITableViewDataSource,
    UITableViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    UIGestureRecognizerDelegate
{
    // MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    // MARK: - UIScrollViewDelegate Methods
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard mainContentVStackView.transform.ty > 0 else { return }
        scrollView.contentOffset.y = 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 60, height: collectionView.frame.size.height - 20)
        
    }
    
    // MARK: - UIGestureRecognizerDelegate Methods
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // 특정 제스처 인식기와 동시에 인식되도록 허용
        return true
    }
}
