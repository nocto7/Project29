//
//  EndGameScene.swift
//  Project29
//
//  Created by kirsty darbyshire on 18/05/2019.
//  Copyright © 2019 nocto. All rights reserved.
//

import SpriteKit

class EndGameScene: SKScene {
    var winner: Int?
    var buildings = [BuildingNode]()
    var player1: SKSpriteNode!
    var player2: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        let endNode = SKLabelNode(fontNamed: "Chalkduster")
        if winner == nil {
            endNode.text = "Game Over!"
        } else {
            endNode.text = "Game Over! Player \(winner!) Wins!"
        }
        endNode.horizontalAlignmentMode = .center
        endNode.position = CGPoint(x: 512, y: 650)
        addChild(endNode)
        createBuildings()
        createPlayers()
    }
    
    func createBuildings() {
        var currentX: CGFloat = -15
        
        // find widths of buildings first
        var widths = [Int]()
        while currentX < 1024 {
            let width = Int.random(in: 2...4) * 40
            widths.append(width)
            currentX += CGFloat(width + 2)
        }
        
        if winner == 1  {
            // draw bigger buildings on the left
            currentX = -15
            var height = 600
            let heightDiff = 300 / (widths.count - 2)
            height -= heightDiff
            var first = true
            for width in widths {
                let size = CGSize(width: width, height: height)
                currentX += CGFloat(width + 2)
                
                let building = BuildingNode(color: .red, size: size)
                building.position = CGPoint(x: currentX - (size.width / 2), y: size.height / 2)
                building.setup()
                buildings.append(building)
                addChild(building)
                
                if first {
                    height += heightDiff
                    first = false
                } else {
                    height -= heightDiff
                }
            }
        } else if winner == 2 {
            // draw bigger buildings on the right
            currentX = 1039
            var height = 600
            let heightDiff = 300 / (widths.count - 2)
            height -= heightDiff
            var first = true
            for width in widths {
                let size = CGSize(width: width, height: height)
                currentX -= CGFloat(width + 2)
                
                let building = BuildingNode(color: .red, size: size)
                building.position = CGPoint(x: currentX + (size.width / 2), y: size.height / 2)
                building.setup()
                buildings.append(building)
                addChild(building)
                
                if first {
                    height += heightDiff
                    first = false
                } else {
                    height -= heightDiff
                }
            }
            // put the buildings back in left to right order
            buildings = buildings.reversed()
            
        }
    }
    
    func createPlayers() {
        player1 = SKSpriteNode(imageNamed: "player")
        player1.name = "player1"
        player1.physicsBody = SKPhysicsBody(circleOfRadius: player1.size.width / 2)
        player1.physicsBody?.isDynamic = false
        
        let player1Building = buildings[1]
        player1.position = CGPoint(x: player1Building.position.x, y: player1Building.position.y + (player1Building.size.height + player1.size.height) / 2)
        addChild(player1)
        
        player2 = SKSpriteNode(imageNamed: "player")
        player2.name = "player2"
        player2.physicsBody = SKPhysicsBody(circleOfRadius: player2.size.width / 2)
        player2.physicsBody?.isDynamic = false
        
        let player2Building = buildings[buildings.count - 2]
        player2.position = CGPoint(x: player2Building.position.x, y: player2Building.position.y + (player2Building.size.height + player2.size.height) / 2)
        addChild(player2)
        
        let jumpUp = SKAction.moveBy(x: 0, y: 50, duration: 0.5)
        let jumpDown = SKAction.moveBy(x: 0, y: -50, duration: 0.5)
        let sequence = SKAction.sequence([jumpUp, jumpDown])
        let jumping = SKAction.repeatForever(sequence)
        
        if winner == 1 {
            player1.run(jumping)
        } else if winner == 2 {
            player2.run(jumping)
        }
    }
    
    
}
