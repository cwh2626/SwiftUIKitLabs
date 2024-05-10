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
        print(rootScrollView.contentOffset.y, tableview.contentOffset.y, scrollView == tableview)
        guard scrollView == tableview else { return }
        
        if scrollView.contentOffset.y > 50 {
            UIView.animate(withDuration: 0.4,
                           delay: 0,
                           usingSpringWithDamping: 1,  // 댐핑 비율, 낮을수록 더 많은 바운스
                           initialSpringVelocity: 0.2,  // 시작 속도, 높을수록 빠른 움직임
                           options: [.curveEaseIn],
                           animations: {
                self.rootScrollView.contentOffset.y = 130
                self.rootContentView.layer.cornerRadius = 0
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
                self.rootContentView.layer.cornerRadius = 16
                self.view.layoutIfNeeded()
            }, completion: nil)
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
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == tableview && !decelerate {
            self.rootScrollView.isScrollEnabled = true
        }
    }
}