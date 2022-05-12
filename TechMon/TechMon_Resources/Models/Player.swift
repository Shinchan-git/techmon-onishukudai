//
//  Player.swift
//  TechDra
//
//  Created by Master on 2015/03/24.
//  Copyright (c) 2015年 net.masuhara. All rights reserved.
//

import UIKit

class Player {
    
    var name: String = "勇者"
    var image: UIImage! = UIImage(named: "yusya.png")
    
    var currentHP: Int = 100
    var currentMP: Int = 0
    var currentTP: Int = 100
    
    let maxHP: Int = 100
    let maxTP: Int = 100
    let maxMP: Int = 20
    
    let attackPower: Int = 40
    let techAttackPower: Int = 100
    let defencePoint: Int = 0
    let constantTPIncrement: Int = 10
    let chargeTPIncrement: Int = 40
    var level: Int = 1
    
    init(name:String, imageName:String) {
        self.name = name
        self.image = UIImage(named: imageName)
        resetStatus()
    }
    
    init() {
        resetStatus()
    }
    
    func resetStatus() {
        currentHP = maxHP
        currentTP = 0
        currentMP = 0
    }
    
}
