//
//  StretchTableViewController.swift
//  SwiftUIKitLabs
//
//  Created by 조웅희 on 2024/05/19.
//

import UIKit
import SnapKit

class StretchTableViewController: UIViewController {
    private let headerView: UIView! = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    private let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .image)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let sectionHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    private lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .blue
        tableView.sectionHeaderTopPadding = 0
        // 스크롤 뷰의 내용이 자동으로 안전 영역이나 네비게이션 바 등의 UI 요소에 의해 조정되지 않도록함
        tableView.contentInsetAdjustmentBehavior = .never
        return tableView
    }()
    
    private let tableHeaderHeight: CGFloat = 213
    private let screenWidth = UIScreen.main.bounds.size.width
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddView()
        setupConstraints()
        updateHeaderView()
    }
    
    private func setupAddView() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        tableView.addSubview(headerView)
        headerView.addSubview(headerImageView)
        
        tableView.contentInset = UIEdgeInsets(top: tableHeaderHeight, left: 0, bottom: 0, right: 0) // headerView의 공간 확보를 위해 헤더 높이 만큼 inset 부여
        tableView.contentOffset = CGPoint(x: 0, y: -tableHeaderHeight) // 첫 상단 스크롤 시작을 위해 inset 준만큼 위치 변경
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        headerImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func updateHeaderView() {
        var tableWidth = 0.0
        
        // viewDidLoad 에서는 테이블의 레이아웃값이 없기에 systemLayoutSizeFitting 활용
        if tableView.bounds.width == 0 {
            tableWidth = tableView.systemLayoutSizeFitting(UIScreen.main.bounds.size).width
        } else {
            tableWidth = tableView.bounds.width
        }
        
        // 테이블뷰가 기준이기에 y값은 음수
        var headerRect = CGRect(x: 0, y: -tableHeaderHeight, width: tableWidth, height: tableHeaderHeight)
        
        if tableView.contentOffset.y < -tableHeaderHeight {
            headerRect.origin.y = tableView.contentOffset.y // 첫 위치가  -tableHeaderHeight 인걸 생각하면 이 값이 맞음
            headerRect.size.height = -tableView.contentOffset.y // 하단으로 당기면 contentOffset은 음수 이기에 양수 변환을 위해 음수화
        } else {
            tableView.contentInset.top = max(-tableView.contentOffset.y, view.safeAreaInsets.top) // viewForHeaderInSection의 위치 때문에 contentInset도 실시간으로 변경해줘야함
        }
        
        headerView.frame = headerRect
    }
}

extension StretchTableViewController:
    UITableViewDataSource,
    UITableViewDelegate
{
    // MARK: - UITableViewDataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sectionHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    // MARK: - UIScrollViewDelegate Methods
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }
}
