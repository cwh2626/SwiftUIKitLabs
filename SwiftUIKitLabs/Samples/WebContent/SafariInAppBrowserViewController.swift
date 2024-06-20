//
//  ViewController.swift
//  SwiftUIKitLabs
//
//  Created by johnny on 6/18/24.
//

import UIKit
import SafariServices

// SFSafariViewController: 순수 OS에서 제공해주는 인앱 브라우저를 사용하고싶은 경우 추천!! 커스텀 제약이 너무 큼
class SafariInAppBrowserViewController: SFSafariViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        preferredBarTintColor = .blue
        preferredControlTintColor = .brown
    }
    
    override init(url URL: URL, configuration: SFSafariViewController.Configuration) {
        super.init(url: URL, configuration: configuration)
    }
}
