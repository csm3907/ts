//
//  CombineCocoa+Extension.swift
//  Design
//
//  Created by 최승민 on 1/31/25.
//

import Combine
import CombineCocoa
import UIKit

public extension UIView {
    var touchPublisher: AnyPublisher<UITapGestureRecognizer, Never> {
        isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer()
        addGestureRecognizer(gesture)
        return gesture.tapPublisher
            .throttle(for: .milliseconds(500), scheduler: DispatchQueue.main, latest: false)
            .eraseToAnyPublisher()
    }
}
