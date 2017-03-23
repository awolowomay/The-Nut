//
//  ViewController.swift
//  How many fingers
//
//  Created by Awolowo Mayungbe on 2/8/17.
//  Copyright © 2017 Awolowo Mayungbe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    
    @IBOutlet var fingersTextField: UITextField!
    
    
    @IBAction func guess(_ sender: Any) {
  
        let diceRoll = String(arc4random_uniform(6))
        
        if fingersTextField.text == diceRoll {
            
            resultLabel.text = "You're right!"
            
        } else {
            
            resultLabel.text = "Wrong! it was a " + diceRoll + "."
            
        }
        
    }

    
    
    @IBOutlet var resultLabel: UILabel!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

