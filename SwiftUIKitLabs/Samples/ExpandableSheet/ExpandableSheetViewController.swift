//
//  ExpandableSheetViewController.swift
//  SwiftUIKitLabs
//
//  Created by 조웅희 on 2024/05/08.
//

import UIKit
import SnapKit

class ExpandableSheetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
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
    
    private let headerView : UIView = {
        let view = UIView()
        view.backgroundColor = .red
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
            $0.height.equalToSuperview().multipliedBy(0.2)
        }
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        headerView.snp.makeConstraints {
            $0.height.equalTo(100)
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
                self.topContentView.snp.remakeConstraints {
                    $0.height.equalTo(0)
                }
                self.mainContentVStackView.layer.cornerRadius = 0
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
                self.topContentView.snp.remakeConstraints {
                    $0.height.equalToSuperview().multipliedBy(0.2)
                }
                self.mainContentVStackView.layer.cornerRadius = 16
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
