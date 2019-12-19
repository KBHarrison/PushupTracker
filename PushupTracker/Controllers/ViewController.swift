//
//  ViewController.swift
//  PushupTracker
//
//  Created by Harrison, Kyle on 10/2/19.
//  Copyright © 2019 Harrison, Kyle. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

//    MARK: - Variables
    

    override func viewDidLoad() {

        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        self.navigationController?
            .setToolbarHidden(true, animated: false)
        super.viewWillAppear(animated)
        
    }
    
    
    


}

