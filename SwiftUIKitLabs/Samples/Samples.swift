//
//  Samples.swift
//  SwiftUIKitLabs
//
//  Created by 조웅희 on 2024/05/01.
//

import Foundation
import UIKit

struct Sample {
    var controller: UIViewController?
    var className: String
    var title: String
}

struct SampleGroup {
    var title: String
    var samples: [Sample]
}

let storyboard = UIStoryboard(name: "Main", bundle: .main)

let sampleGroups: Array<SampleGroup> = [

    SampleGroup(title: "Basics", samples: [Sample(controller: StretchScrollViewController(nibName: StretchScrollViewController.identifier, bundle: nil),
                                                  className: StretchScrollViewController.identifier,
                                                  title: "스트래치 스크롤"),
                                           Sample(controller: StretchTableViewController(nibName: StretchTableViewController.identifier, bundle: nil),
                                                                                         className: StretchTableViewController.identifier,
                                                                                         title: "테이블뷰 스트래치 스크롤"),
                                           Sample(controller: ExpandableSheetViewController(nibName: ExpandableSheetViewController.identifier, bundle: nil),
                                                                                       className: ExpandableSheetViewController.identifier,
                                                                                       title: "확장 바텀 시트"),
                                           Sample(controller: ExpandableSheetTwoViewController(nibName: ExpandableSheetTwoViewController.identifier, bundle: nil),
                                                                                       className: ExpandableSheetTwoViewController.identifier,
                                                                                       title: "확장 바텀 시트2"),
                                           Sample(controller: TransformableSheetViewController(),
                                                                                       className: TransformableSheetViewController.identifier,
                                                                                       title: "확장 바텀 시트3 - transform"),
                                           Sample(controller: TableExpandableSheetViewController(nibName: TableExpandableSheetViewController.identifier, bundle: nil),
                                                                                       className: TableExpandableSheetViewController.identifier,
                                                                                       title: "확장 바텀 시트4 - tableView"),
                                           Sample(controller: FinalExpandableSheetViewController(nibName: FinalExpandableSheetViewController.identifier, bundle: nil),
                                                                                       className: FinalExpandableSheetViewController.identifier,
                                                                                       title: "확장 바텀 시트 최종 - transform"),
                                           Sample(controller: TossTableExpandableSheetViewController(),
                                                                                       className: TossTableExpandableSheetViewController.identifier,
                                                                                       title: "토스 소비 바텀 시트 - transform")
    ]),
    SampleGroup(title: "Side Menu", samples: [
        Sample(
            controller: SideMenuMainViewController(),
            className: SideMenuMainViewController.identifier,
            title: "사이드 메뉴"
        )
    ]),
    SampleGroup(title: "Web", samples: [
        Sample(
            controller: SafariInAppBrowserViewController(url: URL(string: "https://www.naver.com")!, configuration: .init()),
            className: SafariInAppBrowserViewController.identifier,
            title: "사파리 인앱브라우저"
        ),
        Sample(
            controller: WKWebViewViewController(nibName: WKWebViewViewController.identifier, bundle: nil),
            className: WKWebViewViewController.identifier,
            title: "WKWebView 인앱브라우저"
        )
    ])
]
