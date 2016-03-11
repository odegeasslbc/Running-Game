//
//  Boy.swift
//  晒跑校园alpha
//
//  Created by Bingchen Liu on 14/10/28.
//  Copyright (c) 2014年 Bingchen Liu. All rights reserved.
//
import SpriteKit
import Foundation

enum Status:Int{
    case run=1,jump,jump2,roll
}

class Boy:SKSpriteNode {
    
    var status = Status.run
    var initialX:CGFloat!
    var initialY:CGFloat = 345.6
    
    
    init(){
        let boyTexture1 = SKTexture(imageNamed: "跑01")
        boyTexture1.filteringMode = SKTextureFilteringMode.Nearest
        let color = UIColor.whiteColor()
        let size = boyTexture1.size()
        super.init(texture: boyTexture1, color: color, size: size)
        
        
        let fileManager = NSFileManager()
        _ = NSHomeDirectory() + "/Documents"
        let filePath = NSHomeDirectory() + "/Documents/head.png"

        if (fileManager.fileExistsAtPath(filePath) ) {
            let headData:NSData! = fileManager.contentsAtPath(filePath)
            let head:UIImage! = UIImage(data: headData)
            
            let newImg = getCircleImage(head)
            
            
            
            let headTexture = SKTexture(image:newImg)
            
            headTexture.filteringMode = SKTextureFilteringMode.Nearest
            let headNode = SKSpriteNode(texture:headTexture)
            headNode.position = CGPointMake(13,self.size.height*0.3-16)
            headNode.zPosition = 0
            headNode.centerRect = CGRectMake(0, 0, 20, 20)
            self.addChild(headNode)
            
        }
        else{
        print("no")
        }
        self.physicsBody = SKPhysicsBody(texture: boyTexture1, size:boyTexture1.size())

    }
    
    func getCircleImage(head:UIImage) -> UIImage{
        let radius = head.size.width/2
        let x1:CGFloat = 0.0;
        let y1:CGFloat = 0.0;
        let x2 = x1 + head.size.width;
        let y2 = y1;
        let x3 = x2;
        let y3 = y1 + head.size.height;
        let x4 = x1;
        let y4 = y3;
        
        //将图片以圆形载入
        UIGraphicsBeginImageContext(head.size)
        let gc = UIGraphicsGetCurrentContext()
        
        CGContextMoveToPoint(gc, x1, y1+radius);
        CGContextAddArcToPoint(gc, x1, y1, x1+radius, y1, radius);
        CGContextAddArcToPoint(gc, x2, y2, x2, y2+radius, radius);
        CGContextAddArcToPoint(gc, x3, y3, x3-radius, y3, radius);
        CGContextAddArcToPoint(gc, x4, y4, x4, y4-radius, radius);
        CGContextClosePath(gc);
        CGContextClip(gc);
        
        CGContextTranslateCTM(gc, 0, head.size.height);
        CGContextScaleCTM(gc, 1, -1);
        CGContextDrawImage(gc, CGRectMake(0, 0, head.size.width, head.size.height),head.CGImage );
        
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        return newImg
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dynamicFalse(){
        self.physicsBody?.dynamic = false
    }
    
    func run(){
        status = .run
        let birdTexture1 = SKTexture(imageNamed: "跑01")
        birdTexture1.filteringMode = .Nearest
        let birdTexture2 = SKTexture(imageNamed: "跑02")
        birdTexture2.filteringMode = .Nearest
        let birdTexture3 = SKTexture(imageNamed: "跑03")
        birdTexture3.filteringMode = .Nearest
        let birdTexture4 = SKTexture(imageNamed: "跑04")
        birdTexture4.filteringMode = .Nearest
        let birdTexture5 = SKTexture(imageNamed: "跑05")
        birdTexture5.filteringMode = .Nearest
        let birdTexture6 = SKTexture(imageNamed: "跑06")
        birdTexture6.filteringMode = .Nearest
        let birdTexture7 = SKTexture(imageNamed: "跑07")
        birdTexture7.filteringMode = .Nearest
        let birdTexture8 = SKTexture(imageNamed: "跑08")
        birdTexture8.filteringMode = .Nearest
        
        let anim = SKAction.animateWithTextures([birdTexture1, birdTexture2,birdTexture3,birdTexture4,birdTexture5,birdTexture6,birdTexture7,birdTexture8], timePerFrame: 0.07)
        
        let repeatAction = SKAction.repeatActionForever(anim)
        
        self.physicsBody?.dynamic = true
        //self.physicsBody?.applyImpulse(CGVectorMake(0.0,7.0))
        self.runAction(repeatAction)
    }
    
    func jump(){
        self.removeAllActions()
        status = .jump

        self.texture = SKTexture(imageNamed: "跳01")
        let jumpTexture1 = SKTexture(imageNamed: "跳01")
        let jumpTexture2 = SKTexture(imageNamed: "跳02")
        let jumpTexture3 = SKTexture(imageNamed: "跳03")
        let jumpTexture4 = SKTexture(imageNamed: "跳04")
        let jumpTexture5 = SKTexture(imageNamed: "跳05")
        let jumpTexture6 = SKTexture(imageNamed: "跳06")
        let jumpTexture7 = SKTexture(imageNamed: "跳07")
        let anim = SKAction.animateWithTextures([jumpTexture1, jumpTexture2,jumpTexture3,jumpTexture4,jumpTexture5,jumpTexture6,jumpTexture7], timePerFrame: 0.14)
        
        let returnY = SKAction.moveToY(initialY,duration:0.1)
        let stop = SKAction.runBlock({() in self.dynamicFalse() } )
        
        let action = SKAction.sequence([anim,returnY,stop])
        self.physicsBody?.dynamic = true
        self.physicsBody?.velocity = CGVector(dx: 0.0,dy: 0.0)
        self.physicsBody?.applyImpulse(CGVectorMake(0.0, 200))
        //println(bird.position.y)
        self.runAction(action,completion:{
            () in self.run()})
    }
    
    func jumpSecond(){
        self.removeAllActions()
        status = .jump2

        let jumpTexture1 = SKTexture(imageNamed: "跳01")
        let jumpTexture2 = SKTexture(imageNamed: "跳02")
        let jumpTexture3 = SKTexture(imageNamed: "跳03")
        let jumpTexture4 = SKTexture(imageNamed: "跳04")
        let jumpTexture5 = SKTexture(imageNamed: "跳05")
        let jumpTexture6 = SKTexture(imageNamed: "跳06")
        let jumpTexture7 = SKTexture(imageNamed: "跳07")
        let anim = SKAction.animateWithTextures([jumpTexture1, jumpTexture2,jumpTexture3,jumpTexture4,jumpTexture5,jumpTexture6,jumpTexture7], timePerFrame: 0.15)
        
        
        let returnY = SKAction.moveToY(initialY,duration:0.1)
        let stop = SKAction.runBlock({() in self.dynamicFalse() } )
        
        let action = SKAction.sequence([anim,returnY,stop])
        
        self.physicsBody?.velocity = CGVector(dx: 0.0,dy: 0.0)
        self.physicsBody?.applyImpulse(CGVectorMake(0.0, 170))
        //println(bird.position.y)
        self.runAction(action,completion:{
            () in self.run()})
        
    
    }

}