//
//  UIViewController+Extension.swift
//  Design
//
//  Created by 최승민 on 1/31/25.
//

import UIKit

public extension UIViewController {
    func alert(title: String = "경고", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "확인", style: .default) { (action) in
            print("확인 버튼 클릭")
        }
        alert.addAction(action)
        present(alert, animated: false, completion: nil)
    }
}
