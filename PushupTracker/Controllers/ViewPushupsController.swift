//
//  ViewPushupsController.swift
//  PushupTracker
//
//  Created by Harrison, Kyle on 10/3/19.
//  Copyright © 2019 Harrison, Kyle. All rights reserved.
//

import UIKit

class ViewPushupsController : UITableViewController {
    
    //MARK: Constants
    
    private enum Settings: String {
           
           case numberOfPushups, dateOfPushups
           
       }
    
    struct Storyboard {
        
        static let submissionView = 0
        static let dayView = 1
    }
    
    //MARK: - Properties
    var pushupNums: [Int] = []
    var pushupDates: [Date] = []
    static var displayMode = 1
    var pushupDict = [Date: Int]()

    //MARK: - Outlets
    
    @IBOutlet weak var PushupsTracker: UITableViewCell!
    
    //MARK: - Helpers
    
    
    func establishToolbar() {
        toolbarItems?.removeAll()
        var buttonArray = [UIBarButtonItem()]
        let switcharoo = UIBarButtonItem(title: "Error", style: UIBarButtonItem.Style.done, target: self, action: #selector(ViewPushupsController.switchViews(_:)))
        
        
        if ViewPushupsController.displayMode == Storyboard.submissionView {
            
            switcharoo.title = "Group by Submission"
            
        } else {
            
            switcharoo.title = "Group by Date"
            
        }
        buttonArray.append(switcharoo)
        self.setToolbarItems(buttonArray, animated: true)

    }
    
    func populateDictionary() {
        if pushupDict.count == 0 {
            for (index, element) in pushupDates.enumerated() {
                var checkKey: Date? = nil
                for dElement in pushupDict {
                    if dElement.key.asString(style: DateFormatter.Style.short) == element.asString(style: DateFormatter.Style.short) {
                        checkKey = dElement.key
                    }
                }
                if let key = checkKey {
                    pushupDict[key]! += pushupNums[index]
                } else {
                    pushupDict[element] = pushupNums[index]
                }
            }
        }
    }
    
 
    override func viewDidLoad() {
        loadDefaults()
        self.title = "Number of pushups per date"

        navigationController?.setToolbarHidden(false, animated: true)
        
        var buttonArray = [UIBarButtonItem()]
        let switcharoo = UIBarButtonItem(title: "Group By Submission", style: UIBarButtonItem.Style.done, target: self, action: #selector(ViewPushupsController.switchViews(_:)))
        buttonArray.append(switcharoo)
        self.setToolbarItems(buttonArray, animated: true)
        super.viewDidLoad()
        
    }
    
    func updateUI() {
    }
    

    func loadDefaults() {
        let defaults = UserDefaults.standard

        if let pushupArray = defaults.array(forKey: Settings.numberOfPushups.rawValue ) as? [Int] {
            if let dateArray =  defaults.array(forKey: Settings.dateOfPushups.rawValue) as? [Date] {
                pushupNums = pushupArray
                pushupDates = dateArray
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
    super.viewWillAppear(animated)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pushupNums.count != pushupDates.count {
            fatalError("The counts of the arrays are off. There are \(pushupNums.count) pushup elements and \(pushupDates.count) date elements.")
        } else {
            
            switch ViewPushupsController.displayMode {
            case Storyboard.submissionView :
                return pushupNums.count
            case Storyboard.dayView :
                populateDictionary()
                return pushupDict.count
            default:
                 fatalError("DisplayMode should equal 1 or 0. Currently equals \(ViewPushupsController.displayMode).")
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch ViewPushupsController.displayMode {
        case Storyboard.submissionView :
            let cell = tableView.dequeueReusableCell(withIdentifier: "PushupView", for: indexPath)
                   cell.textLabel?.text = """
                   \(pushupDates[indexPath.item]
                   .asString(style: DateFormatter.Style.medium)):  \(String(pushupNums[indexPath.item]))
                   """

                       return cell
               
        case Storyboard.dayView :
            let cell = tableView.dequeueReusableCell(withIdentifier: "PushupView", for: indexPath)
            
            let orderedTuple = pushupDict.sorted(by: { $0.0 < $1.0 })
            
            cell.textLabel?.text = "\(orderedTuple[indexPath.item].key.asString(style: DateFormatter.Style.medium)): \(orderedTuple[indexPath.item].value)"

                       return cell
            
                
        default:
            fatalError("DisplayMode should equal 1 or 0. Currently equals \(ViewPushupsController.displayMode).")
        }
        }

       
    
    @IBAction func switchViews(_ sender: UIButton) {
        establishToolbar()
        if ViewPushupsController.displayMode == Storyboard.submissionView {
            ViewPushupsController.displayMode = Storyboard.dayView
            populateDictionary()
        } else {
            ViewPushupsController.displayMode = Storyboard.submissionView
        }
        DispatchQueue.main.async { self.tableView.reloadData() }

    }
}


//MARK: - Extension

extension Date {
  func asString(style: DateFormatter.Style) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = style
    return dateFormatter.string(from: self)
  }
}
