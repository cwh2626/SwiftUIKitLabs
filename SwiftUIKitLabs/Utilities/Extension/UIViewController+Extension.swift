//
//  UIViewController+Extension.swift
//  SwiftUIKitLabs
//
//  Created by 조웅희 on 2024/05/08.
//

import UIKit

extension UIViewController {
    // `class var` vs `static var`:

    // `class var`:
    // - 클래스 변수로서 클래스 수준에서 사용됩니다.
    // - 이 변수는 오버라이드가 가능하여, 서브클래스에서 재정의할 수 있습니다.
    // - 이는 다형성을 활용하여 각 서브클래스에서 다른 행동이나 값을 제공할 수 있게 합니다.

    // `static var`:
    // - 정적 변수로서 클래스 수준에서 사용됩니다.
    // - 이 변수는 오버라이드할 수 없으며, 모든 인스턴스에서 공통적으로 사용되는 고정된 값이나 행동을 제공합니다.
    // - 서브클래스에서 이를 변경할 수 없으므로, 일관된 행동을 보장합니다.
    class var identifier: String { return String(describing: self) }
}
