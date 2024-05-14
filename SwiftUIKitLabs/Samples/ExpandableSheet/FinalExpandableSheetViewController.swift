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
    private var isAnimating = false
    
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
        //        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        
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
        
        //        mainContentVStackView.addArrangedSubview(headerView)
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
        isAnimating = true

        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.2,
                       options: [.curveEaseInOut],
                       animations: {
            self.mainContentVStackView.transform = CGAffineTransform(translationX: 0, y: self.heightTopContentView)
            self.mainContentVStackView.layer.cornerRadius = self.maxCornerRadius
            self.navigationController?.navigationBar.setAppearance(.white.withAlphaComponent(0))
        }, completion: { _ in
            self.isAnimating = false

            
        })
    }
    
    private func animateToCollapsedState() {
        isAnimating = true
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0.2,
                       options: [.curveEaseIn],
                       animations: {
            self.mainContentVStackView.transform = .identity
            self.mainContentVStackView.layer.cornerRadius = 0
            self.navigationController?.navigationBar.setAppearance(.white.withAlphaComponent(1))
        }, completion: { _ in
            self.isAnimating = false

            
        })
    }
}


extension FinalExpandableSheetViewController:
    UITableViewDataSource,
    UITableViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
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
        print(scrollView.contentOffset.y, mainContentVStackView.transform.ty)
        guard scrollView == tableView, !isAnimating else { return }
        
        // 현재 변환된 y 값을 가져옴
//        scrollView.contentOffset.y = mainContentVStackView.transform.ty
        
        // 스크롤 오프셋에 따른 변환 값 계산
        let offsetY = scrollView.contentOffset.y
        let limitedY = heightTopContentView - max(0, min(offsetY, heightTopContentView))
        print("limitedY", limitedY)
        // 코너 반경과 알파 값 계산
        let cornerRadius = (limitedY / heightTopContentView) * maxCornerRadius
        let alpha = 1 - (limitedY / heightTopContentView)
        
        // 메인 콘텐츠 뷰의 이동 및 코너 반경 설정
        mainContentVStackView.transform = CGAffineTransform(translationX: 0, y: limitedY)
        mainContentVStackView.layer.cornerRadius = cornerRadius
        self.navigationController?.navigationBar.setAppearance(.white.withAlphaComponent(alpha))
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard scrollView == tableView else { return }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView == tableView else { return }
        if !decelerate {
            if scrollView.contentOffset.y > 50 {
                animateToCollapsedState()
            } else {
                guard mainContentVStackView.transform.ty != 0 || tableView.contentOffset.y < 0 else { return }
                animateToExpandedState()
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == tableView else { return }
        if scrollView.contentOffset.y > 50 {
            animateToCollapsedState()
        } else {
            guard mainContentVStackView.transform.ty != 0 || tableView.contentOffset.y < 0 else { return }
            animateToExpandedState()
        }
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
