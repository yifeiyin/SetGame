//
//  PauseMenuViewController.swift
//  Set
//
//  Created by YinYifei on 2018-05-11.
//  Copyright © 2018 Yifei Yin. All rights reserved.
//

import UIKit

class PauseMenuViewController: UIViewController {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var goBackButton: UIButton!
    
    var label1Text = "32 cards remaining (20%)"
    var label2Text = "3 sets collected"
    var label3Text = "4 sets on table"
    var goBackButtonEnbled = true
    var completion: (SetGame?) -> Void = { _ in }
    
    @IBAction func NewGameButtonPressed(_ sender: UIButton) {
        completion(SetGame())
        dismiss(animated: true)
    }
    
    @IBAction func GoBackButtonPressed(_ sender: UIButton) {
        completion(nil)
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Update()
    }
    
    func Update() {
        label1.text = label1Text
        label2.text = label2Text
        label3.text = label3Text
        goBackButton.isEnabled = goBackButtonEnbled
    }
}
