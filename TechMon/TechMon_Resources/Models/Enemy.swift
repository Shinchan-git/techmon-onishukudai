//
//  Enemy.swift
//  techMon
//
//  Created by Yuki.F on 2015/10/27.
//  Copyright © 2015年 Yuki Futagami. All rights reserved.
//

import UIKit

class Enemy {
    
    var name: String = "ドラゴン"
    var image: UIImage! = UIImage(named: "monster.png")

    var currentHP: Int = 400
    var currentMP: Int = 0

    let maxHP: Int = 400
    let maxMP: Int = 35
    
    let attackPower: Int = 15
    let defencePoint: Int = 5
    var level: Int = 1
    let attackInterval: TimeInterval = 1.2
    
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
        currentMP = 0
    }
}

