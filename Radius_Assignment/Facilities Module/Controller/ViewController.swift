//
//  ViewController.swift
//  Radius_Assignment
//
//  Created by Adwait Barkale on 02/08/22.
//

import UIKit

/// This Class will be Controller for ViewController's View
class ViewController: BaseViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tblViewFacilities: UITableView!
    
    // MARK: - Variable Declarations
    var objResponse: ResponseDataModel?
    
    // MARK: - View's Initialization Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get Data From Api on App Launch
        self.configureTableview()
        self.getFacilitiesData()
    }
    
    // MARK: - User Defined Functions
    
    /// Function call to configure tableview
    func configureTableview() {
        self.tblViewFacilities.register(UINib(nibName: OptionsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: OptionsTableViewCell.identifier)
        self.tblViewFacilities.delegate = self
        self.tblViewFacilities.dataSource = self
        self.tblViewFacilities.separatorStyle = .none
        self.tblViewFacilities.backgroundColor = .white
    }
    
    /// Function call to fetch facilities data from api
    func getFacilitiesData() {
        NetworkManager.shared.callApi(withURL: EndPoints.urlFacilities.rawValue) { isSuccess, jsonResponse in
            if isSuccess && jsonResponse != "" {
                // Perform Parsing and Update UI
                do {
                    self.objResponse = try JSONDecoder().decode(ResponseDataModel.self,
                                                               from: jsonResponse.data(using: .utf8) ?? Data())
                    DispatchQueue.main.async {
                        self.tblViewFacilities.reloadData()
                    }
                } catch let error {
                    // Parsing Failed
                    self.showAlert(title: "", message: error.localizedDescription, presentedVC: self)
                }
            } else {
                // Show Unexpected Error Occured
                self.showAlert(title: "", message: StringConstants.shared.unexpectedError, presentedVC: self)
            }
        }
    }
    
    /// This function will check exclusions and return true false based on whether selection is allowed or not
    /// - Returns: Bool
    func checkForExclusions(indexPath: IndexPath) -> Bool {
        var userTappedOption = self.objResponse?.facilities?[indexPath.section].options?[indexPath.row]
        var itemPresentExclusionArr = [[Exclusions]]()
        // Find Object where Selected Condition Exists
        // Check if other elements in that array are deselected
        for arr in self.objResponse?.exclusions ?? [[Exclusions]]() {
            for options in arr {
                if userTappedOption?.id == options.options_id {
                    itemPresentExclusionArr.append(arr)
                }
            }
        }
        for arr in itemPresentExclusionArr {
            for object in arr {
                if object.options_id != userTappedOption?.id {
                    // Means it is diffrent Element check if it is Selected
                    if let option = self.getOption(withID: object.options_id!) {
                        if option.isSelected {
                            return false
                        }
                    }
                }
            }
        }
        return true
    }
    
    /// Function call to get Option Details With ID
    /// - Parameter withID: ID
    /// - Returns: Option Details
    func getOption(withID: String) -> Options? {
        for facilities in objResponse?.facilities ?? [Facilities]() {
            for option in facilities.options ?? [Options]() {
                if option.id == withID {
                    return option
                }
            }
        }
        return nil
    }
    
    /// Function call to update UI Details
    /// - Parameters:
    ///   - indexPath: IndexPath
    ///   - isSelectionAllow: Bool
    func updateUIData(indexPath: IndexPath, isSelectionAllow: Bool) {
        self.objResponse?.facilities?[indexPath.section].options?[indexPath.row].isSelected = isSelectionAllow
        self.objResponse?.facilities?[indexPath.section].isSelectionDone = isSelectionAllow
        self.tblViewFacilities.reloadRows(at: [IndexPath(row: indexPath.row, section: indexPath.section)], with: .automatic)
    }

}

// MARK: - Extensions

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.objResponse?.facilities?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objResponse?.facilities?[section].options?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblViewFacilities.dequeueReusableCell(withIdentifier: OptionsTableViewCell.identifier) as? OptionsTableViewCell else {
            return UITableViewCell()
        }
        let data = objResponse?.facilities?[indexPath.section].options?[indexPath.row]
        cell.imgViewOptions.image = UIImage(named: data?.icon ?? "")
        cell.lblName.text = data?.name ?? ""
        if data?.isSelected ?? false {
            cell.imgViewStatus.isHidden = false
        } else {
            cell.imgViewStatus.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Check if the particular option is already selected, if yes deselect it
        let option = self.objResponse?.facilities?[indexPath.section].options?[indexPath.row]
        let section = self.objResponse?.facilities?[indexPath.section]
        
        if option?.isSelected ?? false {
            self.updateUIData(indexPath: indexPath, isSelectionAllow: false)
        } else if section?.isSelectionDone ?? false {
            self.showAlert(title: "", message: StringConstants.shared.errSelectionNotAllow, presentedVC: self)
            return
        } else {
            // Check if Exclusion Condition allow the selection, If yes allow, Else Show Error Message
            let result = checkForExclusions(indexPath: indexPath)
            if result {
                self.updateUIData(indexPath: indexPath, isSelectionAllow: true)
            } else {
                // Show Alert
                self.objResponse?.facilities?[indexPath.section].options?[indexPath.row].isSelected = false
                self.showAlert(title: "", message: StringConstants.shared.errExclusionConditions, presentedVC: self)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return objResponse?.facilities?[section].name ?? ""
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = .white
            headerView.backgroundView?.backgroundColor = .white
            headerView.textLabel?.textColor = .black
        }
    }
    
}

