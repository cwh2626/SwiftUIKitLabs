//
//  ExpandableSheetViewController.swift
//  SwiftUIKitLabs
//
//  Created by 조웅희 on 2024/05/08.
//

import UIKit

class ExpandableSheetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let headerView = UIView()
    private let tableView = UITableView()
    private let stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackView()
        setupHeaderView()
        setupTableView()
        
    }

    private func setupStackView() {
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupHeaderView() {
        headerView.backgroundColor = .blue
        headerView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(headerView)
        headerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        stackView.addArrangedSubview(tableView)
    }

    // MARK: - UIScrollViewDelegate Methods
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y > 100 {
                self.headerView.isHidden = false
                UIView.animate(withDuration: 0.3,
                               animations: {
                    self.headerView.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 0.3)
                    self.headerView.alpha = 0
                }, completion: { _ in
                    self.headerView.isHidden = true
                })
            } else {
                self.headerView.isHidden = false
                self.headerView.alpha = 1
                UIView.animate(withDuration: 0.3,
                               animations: {
                    self.headerView.transform = .identity
                }, completion: nil)
            }
    }

    // MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
