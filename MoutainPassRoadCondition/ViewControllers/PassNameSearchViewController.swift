//
//  PassNameSearchViewController.swift
//  MoutainPassRoadCondition
//
//  Created by Frank on 2022-12-20.
//

import UIKit

protocol PassNameSearchViewControllerDelegate {
    func setCurrentPassId(_ passId: Int)
}

class PassNameSearchViewController: UITableViewController {

    var delegate: PassNameSearchViewControllerDelegate?
    var currentPass:PassConditionModel?
    var filteredPassConditions:[PassConditionModel] = [PassConditionModel]()
    var allPassConditions:[PassConditionModel] = [PassConditionModel]() {
        didSet {
            filteredPassConditions = allPassConditions
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPassConditions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PassNameCell", for: indexPath)

        // Configure the cell...
        cell.textLabel!.text = filteredPassConditions[indexPath.row].MountainPassName
        if let currentPass = currentPass,
           filteredPassConditions[indexPath.row].MountainPassId == currentPass.MountainPassId {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentPass = filteredPassConditions[indexPath.row]
        self.currentPass = currentPass
        tableView.reloadData()
        self.dismiss(animated: true)
        
        if let delegate = delegate {
            delegate.setCurrentPassId(currentPass.MountainPassId)
        }
    }
}

extension PassNameSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            filteredPassConditions = allPassConditions.filter({ model in
                model.MountainPassName.contains(searchText)
            })
        } else {
            // restore to full list mode if not in search mode (no search terms).
            filteredPassConditions = allPassConditions
        }
        tableView.reloadData()
    }
}
