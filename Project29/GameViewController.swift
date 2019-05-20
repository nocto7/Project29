//
//  GameViewController.swift
//  Project29
//
//  Created by kirsty darbyshire on 16/05/2019.
//  Copyright © 2019 nocto. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var currentGame: GameScene?
    
    @IBOutlet var angleSlider: UISlider!
    @IBOutlet var angleLabel: UILabel!
    
    @IBOutlet var velocitySlider: UISlider!
    @IBOutlet var velocityLabel: UILabel!
    
    @IBOutlet var launchButton: UIButton!
    @IBOutlet var playerLabel: UILabel!
    
    @IBOutlet var player1Score: UILabel!
    @IBOutlet var player2Score: UILabel!
    
    @IBOutlet var windLabel: UILabel!
    
    
    var score = (0, 0) {
        didSet {
            player1Score.text = "Score: \(score.0)"
            player2Score.text = "Score: \(score.1)"
        }
    }
    
    func loadMainGame() {
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                currentGame = scene as? GameScene
                currentGame?.viewController = self
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    func loadEndGame(winner: Int) -> SKScene? {
        // Load the SKScene from 'EndGameScene.sks'
        if let scene = SKScene(fileNamed: "EndGameScene") {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            if let endGame = scene as? EndGameScene {
                endGame.winner = winner
                return endGame
            }
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMainGame()
        
        angleChanged(self)
        velocityChanged(self)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func angleChanged(_ sender: Any) {
        angleLabel.text = "Angle: \(Int(angleSlider.value))°"
    }
    
    @IBAction func velocityChanged(_ sender: Any) {
        velocityLabel.text = "Velocity: \(Int(velocitySlider.value))"
    }
    
    @IBAction func launch(_ sender: Any) {
        angleSlider.isHidden = true
        angleLabel.isHidden = true
        velocitySlider.isHidden = true
        velocityLabel.isHidden = true
        launchButton.isHidden = true
        
        currentGame?.launch(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
    
    }
    
    func activatePlayer(number: Int) {
        if number == 1 {
            playerLabel.text = "<<< PLAYER ONE"
        } else {
            playerLabel.text = "PLAYER TWO >>>"
        }
        
        angleSlider.isHidden = false
        angleLabel.isHidden = false
        velocitySlider.isHidden = false
        velocityLabel.isHidden = false
        launchButton.isHidden = false
    }
    
    func scorePlayer(_ currentPlayer: Int) -> SKScene? {
        if currentPlayer == 1 {
            score.0 += 1
        } else if currentPlayer == 2 {
            score.1 += 1
        }
        if score.0 == 3 || score.1 == 3 {
            print ("calling end game")
            return endGame(winner: currentPlayer)
        }
        return nil
    }
    
    func endGame(winner: Int) -> SKScene? {
        print ("in end game")
        player1Score.isHidden = true
        player2Score.isHidden = true
        playerLabel.isHidden = true
        windLabel.isHidden = true
        return loadEndGame(winner: winner)
    }
}
