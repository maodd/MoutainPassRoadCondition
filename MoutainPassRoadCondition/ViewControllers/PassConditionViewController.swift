//
//  PassConditionViewController.swift
//  MoutainPassRoadCondition
//
//  Created by Frank on 2022-12-19.
//

import UIKit

enum PassConditionSection : Int, CaseIterable{
    case RestrictionEastBound = 0
    case RestrictionWestBound
    case RoadCondition
    case Weather
    case Temperature
    case Elevation
}

class PassConditionViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

    let DefaultPassId = 11 // Snowqualmie i-90
    var passConditionModelList = [PassConditionModel]()
    var currentPassConditionModel:PassConditionModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.close, target: self, action: #selector(closeSelf(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: UIBarButtonItem.Style.plain, target: self, action: #selector(popupPassNameSearch(_:)))
        
        DataService().getPassCondition { [weak self] models in
            guard let self = self else { return }
            self.passConditionModelList = models
            
            DispatchQueue.main.sync {
                self.setCurrentPassId(self.DefaultPassId)
            }
           
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return PassConditionSection.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return getSectionHeaderText(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PassConditionCell", for: indexPath) as! PassConditionTableViewCell

        renderCellWithModel(cell, indexPath.section)
        
        return cell
    }
    
    func renderCellWithModel(_ tableViewCell: PassConditionTableViewCell, _ section: Int) {
        tableViewCell.contentLabel.text = getCellContentText(section)
    }
    
    // MARK: Bar item actions
    @IBAction func closeSelf(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func popupPassNameSearch(_ sender: UIBarButtonItem) {
        guard let searchViewController = storyboard?.instantiateViewController(withIdentifier: "PassNameSearchVC") as? PassNameSearchViewController else { return }
 
        searchViewController.allPassConditions = self.passConditionModelList
        searchViewController.currentPass = self.currentPassConditionModel
        searchViewController.delegate = self
        self.present(searchViewController, animated: true, completion: nil)
    }
}

extension PassConditionViewController : PassNameSearchViewControllerDelegate {
    func setCurrentPassId(_ passId: Int) {
        
        if let model = self.passConditionModelList.first(where: { $0.MountainPassId == passId }) {
            self.currentPassConditionModel = model
                        
            self.title = model.MountainPassName
            
            self.tableView.reloadData()
            
        } else {
            // error
            
        }
    }
}

extension PassConditionViewController {
    func getSectionHeaderText(_ section: Int) -> String? {
        switch section {
        case PassConditionSection.RestrictionEastBound.rawValue: return "Restrictions Eastbound:"
        case PassConditionSection.RestrictionWestBound.rawValue: return "Restrictions Westbound:"
        case PassConditionSection.RoadCondition.rawValue: return "Road Condition:"
        case PassConditionSection.Weather.rawValue: return "Weather Condition:"
        case PassConditionSection.Temperature.rawValue: return "Temperature: "
        case PassConditionSection.Elevation.rawValue: return "Elevation:"
        default: return nil
        }
    }
    
    func getCellContentText(_ section: Int) -> String {
        guard let passConditionModel = currentPassConditionModel else { return "loading"}
        
        switch section {
        case PassConditionSection.RestrictionEastBound.rawValue:
            return passConditionModel.RestrictionOne.RestrictionText
        case PassConditionSection.RestrictionWestBound.rawValue:
            return passConditionModel.RestrictionTwo.RestrictionText
        case PassConditionSection.RoadCondition.rawValue:
            return passConditionModel.RoadCondition
        case PassConditionSection.Weather.rawValue:
            return passConditionModel.WeatherCondition ?? "No current information availiable"
        case PassConditionSection.Temperature.rawValue:
            if let temp = passConditionModel.TemperatureInFahrenheit {
                return "\(temp) °F"
            } else {
                return "unknown"
            }
        case PassConditionSection.Elevation.rawValue:
            return "\(passConditionModel.ElevationInFeet) feet"
        default: print("Unexpected Section")
        }
        return "Content error"
    }
}
