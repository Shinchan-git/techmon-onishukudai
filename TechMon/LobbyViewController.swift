//
//  LobbyViewController.swift
//  TechMon
//
//  Created by Owner on 2022/05/12.
//

import UIKit

class LobbyViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var staminaLabel: UILabel!
    @IBOutlet var levelLabel: UILabel!
    
    var stamina: Int = 100
    var staminaTimer: Timer!
    let savedData = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPlayer()
        staminaTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(updateStaminaValue), userInfo: nil, repeats: true)
        staminaTimer.fire()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        TechDraUtil.playBGM(fileName: "lobby")
        updateLevel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        TechDraUtil.stopBGM()
    }
    
    func initPlayer() {
        nameLabel.text = "勇者"
        staminaLabel.text = "\(stamina) / 100"
    }
    
    func updateLevel() {
        let savedLevel = savedData.integer(forKey: Keys.playerLevel)
        if savedLevel == 0 {
            levelLabel.text = "Lv.1"
        } else {
            levelLabel.text = "Lv.\(savedLevel)"
        }
    }
    
    @IBAction func toBattle() {
        if stamina >= 50 {
            stamina -= 50
            staminaLabel.text = "\(stamina) / 100"
            performSegue(withIdentifier: "toBattle", sender: nil)
        } else {
            let alert = UIAlertController(title: "バトルに行けません", message: "スタミナをためてください", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func updateStaminaValue() {
        if stamina < 100 {
            stamina += 1
            staminaLabel.text = "\(stamina) / 100"
        }
    }

}
