//
//  SideMenuMainViewController.swift
//  SwiftUIKitLabs
//
//  Created by 조웅희 on 2024/05/16.
//

import UIKit
import SnapKit

class SideMenuMainViewController: UIViewController {

    private let rootVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var menuOpenButton: UIButton = {
        let button = UIButton()
        button.setTitle("사이드 메뉴", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(menuOpenButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyles()
        setupAddView()
        setupConstaints()
    }
    
    private func setupStyles() {
        view.backgroundColor = .white
    }
    
    private func setupAddView() {
        view.addSubview(rootVStackView)
        
        [
            menuOpenButton
        ].forEach { rootVStackView.addArrangedSubview($0) }
    }
    
    private func setupConstaints() {
        rootVStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    @objc func menuOpenButtonTapped(_ sender: UIButton) {
        let sideMenuVC = SideMenuViewController()
        
        // over: 부모뷰 위에 표시되는 느낌(부모뷰가 보임)
        // overCurrentContext: 부모뷰 보다는 크게 표시 불가
        sideMenuVC.modalPresentationStyle = .overFullScreen
        sideMenuVC.modalTransitionStyle = .crossDissolve
        present(sideMenuVC, animated: false, completion: nil)
    }
}


