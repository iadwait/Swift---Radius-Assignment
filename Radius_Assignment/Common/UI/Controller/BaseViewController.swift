//
//  BaseViewController.swift
//  Radius_Assignment
//
//  Created by Adwait Barkale on 02/08/22.
//

import UIKit

/// This class will handle all common UI Functionalities, All Controller will Inherit from this class
class BaseViewController: UIViewController {
    
    // MARK: - User Defined Functions
    
    /// Function call to show alert on view controllers
    /// - Parameters:
    ///   - title: Title
    ///   - message: Message
    ///   - presentedVC: Your Controller's Instance
    func showAlert(title: String, message: String, presentedVC: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: StringConstants.shared.okAlert, style: .default, handler: nil)
        alert.addAction(okAction)
        presentedVC.present(alert, animated: true, completion: nil)
    }

}
