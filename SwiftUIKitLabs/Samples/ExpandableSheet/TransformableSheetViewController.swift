//
//  TransformableSheetViewController.swift
//  SwiftUIKitLabs
//
//  Created by johnny on 5/13/24.
//

import UIKit
import SnapKit

class TransformableSheetViewController: UIViewController {
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
        
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
    }()
    
    private lazy var headerView : UIView = {
        let view = UIView()
        view.backgroundColor = .red
        panGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                          action: #selector(self.handlePanGesture(_:)))
        view.addGestureRecognizer(panGestureRecognizer!)

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
        
        mainContentVStackView.addArrangedSubview(headerView)
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
        
        headerView.snp.makeConstraints {
            $0.height.equalTo(135)
        }
    }
    
    
    // MARK: - Action Methods
    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        print(mainContentVStackView.transform.ty)
        // 제스쳐의 상태에 따라 다른 동작 수행
        switch recognizer.state {
        case .began:
            tableView.isScrollEnabled = false  // 스크롤 비활성화

            // 제스처 시작 시, 현재 mainContentVStackView의 변환 값을 저장
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
            tableView.isScrollEnabled = true  // 스크롤 비활성화

            if mainContentVStackView.transform.ty >= 120 {
                animateToExpandedState()
            } else {
                animateToCollapsedState()
            }
        default:
            break
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
}


extension TransformableSheetViewController:
    UITableViewDataSource,
    UITableViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
{
    // MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    // MARK: - UIScrollViewDelegate Methods
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y, mainContentVStackView.transform.ty)
        guard scrollView == tableView else { return }
        if scrollView.contentOffset.y > 50 {
            animateToCollapsedState()
        } else {
            guard mainContentVStackView.transform.ty != 0 || tableView.contentOffset.y < 0 else { return }
            animateToExpandedState()
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard scrollView == tableView else { return }
        panGestureRecognizer?.isEnabled = false  // 팬 제스처 비활성화
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView == tableView else { return }
        if !decelerate {
            panGestureRecognizer?.isEnabled = true  // 팬 제스처 활성화
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == tableView else { return }
        panGestureRecognizer?.isEnabled = true  // 팬 제스처 활성화
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
}

extension UINavigationBar {
    public func setAppearance(_ color: UIColor = .systemBackground) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        appearance.backgroundColor = color

        self.standardAppearance = appearance
        self.scrollEdgeAppearance = appearance
    }
    
}
