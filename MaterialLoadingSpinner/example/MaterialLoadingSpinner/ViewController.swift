//
//  ViewController.swift
//  MaterialLoadingSpinner
//
//  Created by Christos Papantonis on 03/03/2019.
//  Copyright © 2019 Christos Papantonis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let spinnerView = MaterialLoadingSpinner(view: self.view, size: 70, backgroundColor: .black, strokeColor: .yellow, strokeWidth: 10.0)
        self.view.addSubview(spinnerView)
        
        spinnerView.start()
    }
    

}
