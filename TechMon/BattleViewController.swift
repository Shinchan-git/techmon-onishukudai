//
//  BattleViewController.swift
//  TechMon
//
//  Created by Owner on 2022/05/12.
//

import UIKit

class BattleViewController: UIViewController {
    
    @IBOutlet var playerNameLabel: UILabel!
    @IBOutlet var playerImageVeiw: UIImageView!
    @IBOutlet var playerHPLabel: UILabel!
    @IBOutlet var playerMPLabel: UILabel!
    @IBOutlet var playerTPLabel: UILabel!
    @IBOutlet var playerLevelLabel: UILabel!
    
    @IBOutlet var enemyNameLabel: UILabel!
    @IBOutlet var enemyImageView: UIImageView!
    @IBOutlet var enemyHPLabel: UILabel!
    @IBOutlet var enemyMPLabel: UILabel!
    
    @IBOutlet var attackButton: UIButton!
    @IBOutlet var fireButton: UIButton!
    @IBOutlet var chargeButton: UIButton!
    
    let player = Player()
    let enemy = Enemy()
    
    var gameTimer: Timer!
    var isPlayerAttackAvailable: Bool = true
    let savedData = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initCharacters()
        gameTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateGame), userInfo: nil, repeats: true)
        gameTimer.fire()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        TechDraUtil.playBGM(fileName: "BGM_battle001")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        TechDraUtil.stopBGM()
    }
    
    func initCharacters() {
        playerNameLabel.text = player.name
        playerImageVeiw.image = player.image
        enemyNameLabel.text = enemy.name
        enemyImageView.image = enemy.image
        let savedLevel = savedData.integer(forKey: Keys.playerLevel)
        if savedLevel == 0 {
            playerLevelLabel.text = "Lv.1"
        } else {
            playerLevelLabel.text = "Lv.\(savedLevel)"
            player.level = savedLevel
        }
        
        updateUI()
    }
    
    @objc func updateGame() {
        player.currentMP += 1
        if player.currentMP >= player.maxMP {
            isPlayerAttackAvailable = true
            player.currentMP = player.maxMP
        } else {
            isPlayerAttackAvailable = false
        }
        
        enemy.currentMP += 1
        if enemy.currentMP >= enemy.maxMP {
            enemyAttack()
            enemy.currentMP = 0
        }
        
        updateUI()
    }
    
    func enemyAttack() {
        TechDraUtil.animateDamage(playerImageVeiw)
        TechDraUtil.playSE(fileName: "SE_attack")
        player.currentHP -= enemy.attackPower
        judgeBattle()
        updateUI()
    }
    
    func finishBattle(vanishImageView: UIImageView, isPlayerWin: Bool) {
        TechDraUtil.animateVanish(vanishImageView)
        TechDraUtil.stopBGM()
        gameTimer.invalidate()
        isPlayerAttackAvailable = false
        
        var finishMessage: String = ""
        if isPlayerWin {
            TechDraUtil.playSE(fileName: "SE_fanfare")
            finishMessage = "レベルが１アップしました！！"
            let alert  = UIAlertController(title: "\(player.name)の勝利！", message: finishMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.player.level += 1
                self.savedData.set(self.player.level, forKey: Keys.playerLevel)
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)

        } else {
            TechDraUtil.playSE(fileName: "SE_gameover")
            finishMessage = "再チャレンジしよう！"
            let alert  = UIAlertController(title: "\(player.name)の敗北…", message: finishMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func attack() {
        if !isPlayerAttackAvailable { return }
        
        TechDraUtil.animateDamage(enemyImageView)
        TechDraUtil.playSE(fileName: "SE_attack")
        
        enemy.currentHP -= player.attackPower
        if enemy.currentHP < 0 {
            enemy.currentHP = 0
        }
        player.currentMP = 0
        player.currentTP += player.constantTPIncrement
        if player.currentTP >= player.maxTP {
            player.currentTP = player.maxTP
        }
        
        updateUI()
        judgeBattle()
    }
    
    @IBAction func charge() {
        if !isPlayerAttackAvailable { return }
        
        TechDraUtil.playSE(fileName: "SE_charge")
        player.currentTP += player.chargeTPIncrement
        if player.currentTP >= player.maxTP {
            player.currentTP = player.maxTP
        }
        player.currentMP = 0
        
        updateUI()
    }
    
    @IBAction func fire() {
        if !isPlayerAttackAvailable { return }
        if player.currentTP < player.chargeTPIncrement { return }
        
        TechDraUtil.animateDamage(enemyImageView)
        TechDraUtil.playSE(fileName: "SE_fire")
        
        enemy.currentHP -= player.techAttackPower
        if enemy.currentHP < 0 {
            enemy.currentHP = 0
        }
        player.currentTP -= player.chargeTPIncrement
        if player.currentTP < 0 {
            player.currentTP = 0
        }
        player.currentMP = 0
        
        updateUI()
        judgeBattle()
    }
    
    func judgeBattle() {
        if player.currentHP <= 0 {
            finishBattle(vanishImageView: playerImageVeiw, isPlayerWin: false)
            return
        }
        if enemy.currentHP <= 0 {
            finishBattle(vanishImageView: enemyImageView, isPlayerWin: true)
            return
        }
    }
    
    func updateUI() {
        playerHPLabel.text = "\(player.currentHP) / \(player.maxHP)"
        playerMPLabel.text = "\(player.currentMP) / \(player.maxMP)"
        playerTPLabel.text = "\(player.currentTP) / \(player.maxTP)"
        enemyHPLabel.text = "\(enemy.currentHP) / \(enemy.maxHP)"
        enemyMPLabel.text = "\(enemy.currentMP) / \(enemy.maxMP)"
        
        if isPlayerAttackAvailable {
            attackButton.isEnabled = true
            chargeButton.isEnabled = true
            if player.currentTP >= player.chargeTPIncrement {
                fireButton.isEnabled = true
            }
        } else {
            attackButton.isEnabled = false
            fireButton.isEnabled = false
            chargeButton.isEnabled = false
        }
    }
    
}
