//
//  TableExpandableSheetViewController.swift
//  SwiftUIKitLabs
//
//  Created by johnny on 5/14/24.
//

import UIKit

class TableExpandableSheetViewController: UIViewController {

    @IBOutlet weak var topContentView: UIView!
    
    @IBOutlet weak var rootContentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constTableViewTop: NSLayoutConstraint!
    private var isScroll = true
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topContentView.backgroundColor = .blue
        tableView.backgroundColor = .purple

        tableView.sectionHeaderTopPadding = 0 // 헤더 설정하면 기본값으로 상단 패딩이 있음 이걸로 해결
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension TableExpandableSheetViewController:
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
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    // MARK: - UIScrollViewDelegate Methods
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == tableView else { return }
        print(self.constTableViewTop.constant, scrollView.contentOffset.y )
        
        if scrollView.contentOffset.y < 162 && scrollView.contentOffset.y > 0 {
            self.constTableViewTop.constant = scrollView.contentOffset.y
        }
        
//        guard isScroll else { return }
//        
//        if scrollView.contentOffset.y > 50 {
//            guard self.constTableViewTop.constant != 0 else { return }
//            self.isScroll = false
//            UIView.animate(withDuration: 0.9,
//                           delay: 0,
//                           usingSpringWithDamping: 1,  // 댐핑 비율, 낮을수록 더 많은 바운스
//                           initialSpringVelocity: 0.2,  // 시작 속도, 높을수록 빠른 움직임
//                           options: [.curveEaseIn],
//                           animations: {
////                self.topContentView.snp.remakeConstraints {
////                    $0.height.equalToSuperview().multipliedBy(0.2)
////                }
//                self.constTableViewTop.constant = 0
//                self.rootContentView.layoutIfNeeded()
//            }, completion: { _ in
//                self.isScroll = true
//            })
//        } else {
//            guard self.constTableViewTop.constant != 162 else { return }
//            isScroll = false
//            UIView.animate(withDuration: 0.9,
//                           delay: 0,
//                           usingSpringWithDamping: 1,  // 댐핑 비율, 낮을수록 더 많은 바운스
//                           initialSpringVelocity: 0.2,  // 시작 속도, 높을수록 빠른 움직임
//                           options: [.curveEaseIn],
//                           animations: {
////                self.topContentView.snp.remakeConstraints {
////                    $0.height.equalTo(0)
////                }
//                self.constTableViewTop.constant = 162
//                self.rootContentView.layoutIfNeeded()
//                
//
//            }, completion: { _ in
//                self.isScroll = true
//            })
//            
//        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 135
    }
    
    // MARK: - UITableViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView == tableView else { return }
        if !decelerate {
            if scrollView.contentOffset.y > 50 {
                UIView.animate(withDuration: 0.9,
                               delay: 0,
                               usingSpringWithDamping: 1,  // 댐핑 비율, 낮을수록 더 많은 바운스
                               initialSpringVelocity: 0.2,  // 시작 속도, 높을수록 빠른 움직임
                               options: [.curveEaseIn],
                               animations: {
    //                self.topContentView.snp.remakeConstraints {
    //                    $0.height.equalTo(0)
    //                }

                    scrollView.contentOffset.y = 162
                    self.constTableViewTop.constant = scrollView.contentOffset.y
                    self.rootContentView.layoutIfNeeded()
                    

                }, completion: { _ in
                    self.isScroll = true
                })
            } else {
                UIView.animate(withDuration: 0.9,
                               delay: 0,
                               usingSpringWithDamping: 1,  // 댐핑 비율, 낮을수록 더 많은 바운스
                               initialSpringVelocity: 0.2,  // 시작 속도, 높을수록 빠른 움직임
                               options: [.curveEaseIn],
                               animations: {
    //                self.topContentView.snp.remakeConstraints {
    //                    $0.height.equalToSuperview().multipliedBy(0.2)
    //                }
                    scrollView.contentOffset.y = 0
                    self.constTableViewTop.constant = scrollView.contentOffset.y
                    self.rootContentView.layoutIfNeeded()
                }, completion: { _ in
                    self.isScroll = true
                })
 
                
            }
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == tableView else { return }
//        if scrollView.contentOffset.y > 50 {
//            UIView.animate(withDuration: 0.9,
//                           delay: 0,
//                           usingSpringWithDamping: 1,  // 댐핑 비율, 낮을수록 더 많은 바운스
//                           initialSpringVelocity: 0.2,  // 시작 속도, 높을수록 빠른 움직임
//                           options: [.curveEaseIn],
//                           animations: {
////                self.topContentView.snp.remakeConstraints {
////                    $0.height.equalTo(0)
////                }
//                self.constTableViewTop.constant = 162
//                self.rootContentView.layoutIfNeeded()
//                
//
//            }, completion: { _ in
//                self.isScroll = true
//            })
//        } else {
//            
//                UIView.animate(withDuration: 0.9,
//                               delay: 0,
//                               usingSpringWithDamping: 1,  // 댐핑 비율, 낮을수록 더 많은 바운스
//                               initialSpringVelocity: 0.2,  // 시작 속도, 높을수록 빠른 움직임
//                               options: [.curveEaseIn],
//                               animations: {
//    //                self.topContentView.snp.remakeConstraints {
//    //                    $0.height.equalToSuperview().multipliedBy(0.2)
//    //                }
//                    self.constTableViewTop.constant = 0
//                    self.rootContentView.layoutIfNeeded()
//                }, completion: { _ in
//                    self.isScroll = true
//                })
//        }
        
    }

}
