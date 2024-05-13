//
//  ExpandableSheetTwoViewController.swift
//  SwiftUIKitLabs
//
//  Created by johnny on 5/9/24.
//

import UIKit

class ExpandableSheetTwoViewController: UIViewController {

    @IBOutlet weak var rootScrollView: UIScrollView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var rootContentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        tableview.delegate = self
        rootScrollView.delegate = self
        
        rootScrollView.backgroundColor = .purple
        rootScrollView.decelerationRate = .fast

        headerView.backgroundColor = .clear
        
        rootContentView.clipsToBounds = true
        rootContentView.layer.cornerRadius = 16
        rootContentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}


extension ExpandableSheetTwoViewController:
    UITableViewDataSource,
    UITableViewDelegate
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
        let maxCornerRadius: CGFloat = 16
        let cornerRadius = maxCornerRadius - ((rootScrollView.contentOffset.y / 130) * maxCornerRadius)
        print(rootScrollView.contentOffset.y, tableview.contentOffset.y, scrollView == tableview)
//        guard scrollView == tableview else { return }
        // 스크롤 위치에 따른 코너 반경 계산
        
        self.rootContentView.layer.cornerRadius = cornerRadius
        if scrollView == tableview {
            if scrollView.contentOffset.y > 50 {
                
                UIView.animate(withDuration: 0.4,
                               delay: 0,
                               usingSpringWithDamping: 1,  // 댐핑 비율, 낮을수록 더 많은 바운스
                               initialSpringVelocity: 0.2,  // 시작 속도, 높을수록 빠른 움직임
                               options: [.curveEaseIn],
                               animations: {
                    self.rootScrollView.contentOffset.y = 130
//                    self.rootContentView.layer.cornerRadius = 0
                    self.view.layoutIfNeeded()
                    
                    
                }, completion: { _ in
                })
            } else {
                guard rootScrollView.contentOffset.y != 130 || tableview.contentOffset.y < 0 else { return }
                UIView.animate(withDuration: 0.4,
                               delay: 0,
                               usingSpringWithDamping: 0.6,  // 댐핑 비율, 낮을수록 더 많은 바운스
                               initialSpringVelocity: 0.2,  // 시작 속도, 높을수록 빠른 움직임
                               options: [.curveEaseInOut],
                               animations: {
                    self.rootScrollView.contentOffset.y = 0
//                    self.rootContentView.layer.cornerRadius = 16
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        } else if scrollView == rootScrollView {
            
        }
        
    }
    
    // MARK: - UITableViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == tableview {
            self.rootScrollView.isScrollEnabled = false
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == tableview {
            self.rootScrollView.isScrollEnabled = true
        } else if scrollView == rootScrollView {
            if scrollView.contentOffset.y > 50 {
                UIView.animate(withDuration: 0.4,
                               delay: 0,
                               usingSpringWithDamping: 1,  // 댐핑 비율, 낮을수록 더 많은 바운스
                               initialSpringVelocity: 0.2,  // 시작 속도, 높을수록 빠른 움직임
                               options: [.curveEaseIn],
                               animations: {
                    self.rootScrollView.contentOffset.y = 130
//                    self.rootContentView.layer.cornerRadius = 0
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
                    self.rootScrollView.contentOffset.y = 0
//                    self.rootContentView.layer.cornerRadius = 16
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == tableview && !decelerate {
            self.rootScrollView.isScrollEnabled = true
        } else if scrollView == rootScrollView && !decelerate {
            if scrollView.contentOffset.y > 50 {
                UIView.animate(withDuration: 0.4,
                               delay: 0,
                               usingSpringWithDamping: 1,  // 댐핑 비율, 낮을수록 더 많은 바운스
                               initialSpringVelocity: 0.2,  // 시작 속도, 높을수록 빠른 움직임
                               options: [.curveEaseIn],
                               animations: {
                    self.rootScrollView.contentOffset.y = 130
//                    self.rootContentView.layer.cornerRadius = 0
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
                    self.rootScrollView.contentOffset.y = 0
//                    self.rootContentView.layer.cornerRadius = 16
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
}
