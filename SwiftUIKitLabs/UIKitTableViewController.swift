//
//  UIKitTableViewController.swift
//  SwiftUIKitLabs
//
//  Created by 조웅희 on 2024/05/01.
//

import UIKit

class UIKitTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "UIkitLabs"
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sampleGroups.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleGroups[section].samples.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "SampleCell", for: indexPath)
        cell.textLabel?.text = sampleGroups[indexPath.section].samples[indexPath.row].title
        cell.detailTextLabel?.text = sampleGroups[indexPath.section].samples[indexPath.row].className
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sample = sampleGroups[indexPath.section].samples[indexPath.row]
        showSample(sample)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView()
        headerView.bounds = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 60)
        
        let label: UILabel = UILabel()
        label.frame = headerView.bounds.inset(by: UIEdgeInsets(top: 0, left: tableView.separatorInset.left, bottom: 0, right: 0))
        label.text = sampleGroups[section].title
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title1)
        headerView.addSubview(label)
        
        return headerView
    }
    
    func showSample(_ sample: Sample) {
        if let vc = sample.controller {
            vc.title = sample.title
            vc.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

