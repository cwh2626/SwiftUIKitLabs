//
//  SideMenuViewController.swift
//  SwiftUIKitLabs
//
//  Created by 조웅희 on 2024/05/16.
//

import UIKit
import SnapKit

class SideMenuViewController: UIViewController {
    private lazy var sideMenuContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        let panGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                          action: #selector(self.handlePanGesture(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
        return view
    }()
    
    // 화면 너비의 70%를 계산
    private let screenWidth = UIScreen.main.bounds.size.width
    private lazy var seventyPercentWidth = screenWidth * 0.7
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyles()
        setupAddView()
        setupConstaints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sideMenuContainer.transform = CGAffineTransform(translationX: seventyPercentWidth, y: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateToExpandedState()
    }
    
    private func setupStyles() {
        view.backgroundColor = .black.withAlphaComponent(0.0)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSideMenu))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupAddView() {
        view.addSubview(sideMenuContainer)
    }
    
    private func setupConstaints() {
        sideMenuContainer.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.width.equalTo(seventyPercentWidth)
        }
    }
    
    private func animateToExpandedState() {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.backgroundColor = .black.withAlphaComponent(0.1)
            self.sideMenuContainer.transform = .identity
        })
    }
    
    private func animateToCollapsedState() {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.backgroundColor = .black.withAlphaComponent(0.0)
            self.sideMenuContainer.transform = CGAffineTransform(translationX: self.seventyPercentWidth, y: 0)
        }) { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    // MARK: - Action Methods
    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        
        switch recognizer.state {
        case .changed:
            // 이동 거리가 화면의 0% ~ 70% 사이로 제한되도록 합니다.
            let limitedX = max(0, min(sideMenuContainer.transform.tx + translation.x, seventyPercentWidth))
            
            // sideMenuContainer의 x축 변환을 업데이트합니다.
            sideMenuContainer.transform = CGAffineTransform(translationX: limitedX, y: 0)
            
            // 제스처의 이동 거리를 초기화하여 연속적인 이동 거리를 처리할 수 있도록 합니다.
            recognizer.setTranslation(CGPoint.zero, in: view)
            
        case .ended, .cancelled:
            if sideMenuContainer.transform.tx >= seventyPercentWidth * 0.1 {
                animateToCollapsedState()
            } else {
                animateToExpandedState()
            }
            
        default:
            break
        }
    }

    @objc func dismissSideMenu() {
        animateToCollapsedState()
    }

}

extension SideMenuViewController: UIGestureRecognizerDelegate {
    
    // sideMenuContainer 터치시에 펜제스처 무시 로직 - 참고: https://ios-development.tistory.com/924
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard touch.view?.isDescendant(of: self.sideMenuContainer) == false else { return false }
        return true
    }
}
