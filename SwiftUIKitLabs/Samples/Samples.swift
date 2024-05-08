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
                                                  title: "스트래치 스크롤")]),
    
    SampleGroup(title: "Test", samples: [Sample(controller: TestViewController(), className: TestViewController.identifier, title: "현재 위치 표시"),
                                              Sample(className: "MapMarkerInteractionViewController", title: "마커 선택 이벤트"),
                                              Sample(className: "MapComprehensiveCustomViewController", title: "지도 종합 테스트"),
                                              Sample(className: "LastMapComprehensiveCustomViewController", title: "지도 최종 테스트")])

]
