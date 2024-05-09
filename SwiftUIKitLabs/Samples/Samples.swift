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
                                           Sample(controller: ExpandableSheetViewController(nibName: ExpandableSheetViewController.identifier, bundle: nil),
                                                                                       className: ExpandableSheetViewController.identifier,
                                                                                       title: "확장 바텀 시트"),
                                           Sample(controller: ExpandableSheetTwoViewController(nibName: ExpandableSheetTwoViewController.identifier, bundle: nil),
                                                                                       className: ExpandableSheetTwoViewController.identifier,
                                                                                       title: "확장 바텀 시트2")])
]
