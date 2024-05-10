//
//  ExpandableSheetViewController.swift
//  SwiftUIKitLabs
//
//  Created by 조웅희 on 2024/05/08.
//

import UIKit
import SnapKit

class ExpandableSheetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var constTopContentheight: Constraint?
    private var initialInset = 0.0
    private var initialCornerRadius = 0.0
    
    private let rootVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = .purple
        
        return stackView
    }()
    
    private let topContentView : UIView = {
        let view = UIView()
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
        let panGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                          action: #selector(self.handlePanGesture(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
        return view
    }()
    
    
    private var constHeight: Constraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddView()
        setupConstaints()
        
    }

    private func setupAddView() {
        view.addSubview(rootVStackView)
        
        rootVStackView.addArrangedSubview(topContentView)
        rootVStackView.addArrangedSubview(mainContentVStackView)
        
        topContentView.addSubview(collectionView)
        
        mainContentVStackView.addArrangedSubview(headerView)
        mainContentVStackView.addArrangedSubview(tableView)
        
        
    }
    
    private func setupConstaints() {
        rootVStackView.snp.makeConstraints {
            $0.verticalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        topContentView.snp.makeConstraints {
            constTopContentheight = $0.height.equalToSuperview().multipliedBy(0.2).constraint
        }
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        headerView.snp.makeConstraints {
            $0.height.equalTo(100)
        }
    }
    
    // MARK: - Action Methods
    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        
        let maxInset: CGFloat = 143
        let minInset: CGFloat = 0
        var newInset = min(max(minInset, initialInset - translation.y), maxInset)
        
        // 아래 코드는 그 달라에서 한 이미지 크기 비율값으로 가져와서 해봐야겠다 이렇게 하니깐 안되네 오ㅇ케
        let maxCornerRadius: CGFloat = 16
        let minCornerRadius: CGFloat = 0
        var newCornerRadius = min(max(minCornerRadius, initialCornerRadius - translation.y), maxCornerRadius)
         
        newInset = round(newInset)
        newCornerRadius = round(newCornerRadius)
        switch recognizer.state {
        case .changed:
            print(newInset, translation.y, initialInset, newCornerRadius)
            self.constTopContentheight?.update(inset: newInset)
            self.mainContentVStackView.layer.cornerRadius = newCornerRadius

        case .ended:

            if newInset > 20 {
                UIView.animate(withDuration: 0.4,
                               delay: 0,
                               usingSpringWithDamping: 1,  // 댐핑 비율, 낮을수록 더 많은 바운스
                               initialSpringVelocity: 0.2,  // 시작 속도, 높을수록 빠른 움직임
                               options: [.curveEaseIn],
                               animations: {
                    self.constTopContentheight?.update(inset: 143)
                    self.initialInset = 143
                    self.mainContentVStackView.layer.cornerRadius = 0
                    self.initialCornerRadius = 0
                    self.view.layoutIfNeeded()

                }, completion: { _ in
                })
            } else {
                UIView.animate(withDuration: 0.4,
                               delay: 0,
                               usingSpringWithDamping: 0.6,  // 댐핑 비율, 낮을수록 더 많은 바운스
                               initialSpringVelocity: 0.2,  // 시작 속도, 높을수록 빠른 움직임
                               options: [.curveEaseInOut],
                               animations: {
                    self.constTopContentheight?.update(inset: 0)
                    self.initialInset = 0
                    self.mainContentVStackView.layer.cornerRadius = 16
                    self.initialCornerRadius = 16
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        default:
            break
        }
    }
    
    // MARK: - UIScrollViewDelegate Methods
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == tableView else { return }
        if scrollView.contentOffset.y > 50 {
            UIView.animate(withDuration: 0.4,
                           delay: 0,
                           usingSpringWithDamping: 1,  // 댐핑 비율, 낮을수록 더 많은 바운스
                           initialSpringVelocity: 0.2,  // 시작 속도, 높을수록 빠른 움직임
                           options: [.curveEaseIn],
                           animations: {
//                self.topContentView.snp.remakeConstraints {
//                    $0.height.equalTo(0)
//                }
                self.constTopContentheight?.update(inset: 143)
                self.initialInset = 143
                self.mainContentVStackView.layer.cornerRadius = 0
                self.initialCornerRadius = 0
                self.view.layoutIfNeeded()

            }, completion: { _ in
            })
        } else {
            UIView.animate(withDuration: 0.4,
                           delay: 0,
                           usingSpringWithDamping: 0.6,  // 댐핑 비율, 낮을수록 더 많은 바운스
                           initialSpringVelocity: 0.2,  // 시작 속도, 높을수록 빠른 움직임
                           options: [.curveEaseInOut],
                           animations: {
//                self.topContentView.snp.remakeConstraints {
//                    $0.height.equalToSuperview().multipliedBy(0.2)
//                }
                self.constTopContentheight?.update(inset: 0)
                self.initialInset = 0
                self.mainContentVStackView.layer.cornerRadius = 16
                self.initialCornerRadius = 16
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }

    // MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}


extension ExpandableSheetViewController:
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = . blue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 60, height: collectionView.frame.size.height - 20)

    }
}
