//
//  Router .swift
//  TicTacToe
//
//  Created by Алексей Гончаров on 4/22/22.
//

import Foundation
import UIKit

class Router {
    let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func showAlert(title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        actions.forEach { action in
            alert.addAction(action)
        }
        viewController.present(alert, animated: true)
    }
}
