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

class PassConditionViewController: UITableViewController {

    var passConditionModel: PassConditionModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DataService().getPassCondition { [unowned self] model in
            self.passConditionModel = model
            DispatchQueue.main.sync {
                self.title = self.passConditionModel?.MountainPassName
                self.tableView.reloadData()
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
        guard let passConditionModel = passConditionModel else { return "loading"}
        
        switch section {
        case PassConditionSection.RestrictionEastBound.rawValue:
            return passConditionModel.RestrictionOne.RestrictionText
        case PassConditionSection.RestrictionWestBound.rawValue:
            return passConditionModel.RestrictionTwo.RestrictionText
        case PassConditionSection.RoadCondition.rawValue:
            return passConditionModel.RoadCondition
        case PassConditionSection.Weather.rawValue:
            return passConditionModel.WeatherCondition
        case PassConditionSection.Temperature.rawValue:
            if let temp = passConditionModel.TemperatureInFahrenheit {
                return "\(temp)°F"
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
