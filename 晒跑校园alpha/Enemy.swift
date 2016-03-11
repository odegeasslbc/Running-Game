//
//  Enemy.swift
//  晒跑校园alpha
//
//  Created by Bingchen Liu on 14/10/29.
//  Copyright (c) 2014年 Bingchen Liu. All rights reserved.
//
import SpriteKit

enum Identifier:Int{
    case building=1,blanketEnemy,pillowEnemy
}

class Enemy:SKSpriteNode{
    var id = Identifier.building
    var hp = 2
    
    class func createBuilding()->Enemy{
        let buildingTexture = SKTexture(imageNamed: "PipeUp")
        let building = Enemy(texture:buildingTexture)
        building.hp = 2
        building.id = Identifier.building
        building.physicsBody = SKPhysicsBody(texture: buildingTexture, size:buildingTexture.size())
        return building
    }
    
    class func createBlanketEnemy()->Enemy{
        let blanketTexture = SKTexture(imageNamed: "beizi")
        let blanket = Enemy(texture:blanketTexture)
        blanket.hp = 2
        blanket.id = Identifier.blanketEnemy
        blanket.physicsBody = SKPhysicsBody(texture: blanketTexture, size:blanketTexture.size())
        return blanket
    }
    
    class func createPillowEnemy()->Enemy{
        let pillowTexture = SKTexture(imageNamed: "pillow1")
        let pillow = Enemy(texture:pillowTexture)
        pillow.hp = 2
        pillow.id = Identifier.pillowEnemy
        pillow.physicsBody = SKPhysicsBody(texture: pillowTexture, size:pillowTexture.size())
        return pillow
    }
}