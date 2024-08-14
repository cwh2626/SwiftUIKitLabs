//
//  TossTableExpandableSheetViewController.swift
//  SwiftUIKitLabs
//
//  Created by 조웅희 on 2024/08/13.
//

import UIKit
import SnapKit

class TossTableExpandableSheetViewController: UIViewController {
    
    private let mainContentVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.clipsToBounds = true
        stackView.layer.cornerRadius = 16
        stackView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return stackView
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        panGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                          action: #selector(self.handlePanGesture(_:)))
        view.addGestureRecognizer(panGestureRecognizer!)
        return view
    }()
    
    private var grabberView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2
        view.clipsToBounds = true
        view.backgroundColor = .gray
        return view
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    private var headerContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.contentInset.bottom = tableBottomContentInset
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(BottomSheetTableViewCell.self, forCellReuseIdentifier: "BottomSheetTableViewCell")
        return tableView
    }()
    
    // MARK: - Propertty
    private lazy var safeAreaInsetsSize: UIEdgeInsets = view.safeAreaInsets
    private lazy var totalHeight = view.frame.height
    private lazy var topSafeArea = view.safeAreaInsets.top
    private lazy var bottomSafeArea = view.safeAreaInsets.bottom
    private lazy var heightExcludingSafeArea = totalHeight - topSafeArea  - safeAreaInsetsSize.top - safeAreaInsetsSize.bottom
    
    private lazy var headerHeight = trunc(headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height)
    private lazy var cellHeight = trunc(BottomSheetTableViewCell().systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height)
    private var tableHeightConst: Constraint?
    private var panGestureRecognizer: UIPanGestureRecognizer?
    private var isScrollEnabled = false
    private var isDragging = false
    private var tableBottomContentInset = 40.0
    private var dataSourceCount: Int = 9
    private var lastContentOffset: CGFloat = 0
    
    private var initHeight: CGFloat {
        min(cellHeight * CGFloat(dataSourceCount) + tableBottomContentInset, (cellHeight * 8) + tableBottomContentInset)
    }
    
    private var maxHeight: CGFloat {
        min(cellHeight * CGFloat(dataSourceCount) + tableBottomContentInset, heightExcludingSafeArea)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyles()
        setupAddView()
        setupConstaints()
        titleLabel.text = "반을 선택해주세요"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialTransformSetup()
        isScrollEnabled = dataSourceCount > 8
        tableView.isScrollEnabled = isScrollEnabled
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        tableHeightConst?.update(offset: initHeight)
        initialTransformSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateToIdentityState()
        if isScrollEnabled {
            let indexPath = IndexPath(row: 3, section: 0)
            tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
    }
    
    private func setupStyles() {
        view.backgroundColor = .black.withAlphaComponent(0.0)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissBottomSheet))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    private func initialTransformSetup() {
        mainContentVStackView.transform = CGAffineTransform(translationX: 0, y: tableView.contentSize.height + headerHeight + tableBottomContentInset)
    }
    
    private func setupAddView() {
        view.addSubview(mainContentVStackView)
        
        mainContentVStackView.addArrangedSubview(headerView)
        mainContentVStackView.addArrangedSubview(tableView)
        
        headerView.addSubview(grabberView)
        headerView.addSubview(titleLabel)
    }
    
    private func setupConstaints() {
        
        mainContentVStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            tableHeightConst = $0.height.equalTo(0).constraint
        }
        
        grabberView.snp.makeConstraints {
            $0.width.equalTo(28)
            $0.height.equalTo(4)
            $0.top.equalToSuperview().inset(14)
            $0.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(grabberView.snp.bottom).offset(14)
            $0.bottom.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
    }
    
    // MARK: - Action Methods
    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        let velocity = recognizer.velocity(in: view)
        let height = tableView.frame.height
    
        switch recognizer.state {
        case .changed:
            tableHeightConst?.update(offset: min(height + -translation.y, maxHeight))

            recognizer.setTranslation(.zero, in: view)
        case .ended, .cancelled:
            if velocity.y < 0 {
                animateToExpandedState()
            } else {
                animateToCloseState()
            }
        default:
            break
        }
    }

    @objc func dismissBottomSheet() {
        animateToCloseState()
    }
    
    private func animateToIdentityState() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.backgroundColor = .black.withAlphaComponent(0.6)
            self.mainContentVStackView.transform = .identity
        }, completion: nil)
    }
    
    private func animateToExpandedState() {
        self.tableHeightConst?.update(offset: maxHeight)
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0.2,
                       options: [.curveEaseIn],
                       animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func animateToCloseState() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.backgroundColor = .black.withAlphaComponent(0.0)
            self.mainContentVStackView.transform = CGAffineTransform(translationX: 0, y: self.tableView.contentSize.height + self.headerHeight + self.tableBottomContentInset)
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
        })
    }

    
}

extension TossTableExpandableSheetViewController:
    UITableViewDataSource,
    UITableViewDelegate,
    UIGestureRecognizerDelegate
{
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BottomSheetTableViewCell", for: indexPath) as? BottomSheetTableViewCell else {
            return UITableViewCell()
        }

        return cell
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print(#function)
        lastContentOffset = scrollView.contentOffset.y
        isDragging = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print(#function)
        isDragging = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == tableView else { return }
        if lastContentOffset < scrollView.contentOffset.y && isDragging {
            animateToExpandedState()
        }
    }
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard touch.view?.isDescendant(of: self.mainContentVStackView) == false else { return false }
        return true
    }
}

class BottomSheetTableViewCell: UITableViewCell {
    var emptyView: UIView = {
        let view = UIView()
        return view
    }()
    
    func randomColor() -> UIColor {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(emptyView)
        emptyView.backgroundColor = randomColor()
        emptyView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(50)
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
}
