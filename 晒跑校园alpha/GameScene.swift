//
//  GameScene.swift
//  晒跑校园alpha
//
//  Created by 刘炳辰 on 14/10/28.
//  Copyright (c) 2014年 刘炳辰. All rights reserved.
//

import SpriteKit
import Social

class GameOverScene:SKScene{
    
    let labelRestart = SKLabelNode(fontNamed:"Chalkduster")
    var tmpDelay:CGFloat!
    let buttonShare = SKLabelNode(fontNamed:"Chalkduster")
    var score:Int!
    
    init(size:CGSize, score: Int, delay: CGFloat){
        super.init(size: size)
        self.tmpDelay = delay
        self.score = score
        self.backgroundColor = SKColor(red: 81.0/255.0, green: 192.0/255.0, blue: 201.1/255.0, alpha: 1.0)
        var hardOrEasy = "中"
        if tmpDelay < 0.5 { hardOrEasy = "难"}
        else if tmpDelay < 1.5 { hardOrEasy = "中" }
        else { hardOrEasy = "易"}
        
        let labelGameOver = SKLabelNode(fontNamed:"Chalkduster")
        labelGameOver.text = "game over!  游戏难度：\(hardOrEasy)"
        labelGameOver.fontSize = 55
        labelGameOver.fontColor = SKColor(red: 255.0/255.0, green: 150/255.0, blue: 150/255.0, alpha: 1.0)
        labelGameOver.position = CGPointMake(self.size.width/2, self.size.height*0.7)
        self.addChild(labelGameOver)
        
        let labelScore = SKLabelNode(fontNamed:"Chalkduster")
        labelScore.text = "you got \(score) scores"
        labelScore.fontSize = 47
        labelScore.fontColor = SKColor(red: 255.0/255.0, green: 150/255.0, blue: 150/255.0, alpha: 1.0)
        labelScore.position = CGPointMake(self.size.width/2, self.size.height*0.56)
        self.addChild(labelScore)

        buttonShare.text = "截图或分享"
        buttonShare.fontSize = 25
        buttonShare.fontColor = SKColor.blackColor()
        buttonShare.position = CGPointMake(self.size.width/2, self.size.height*0.2)
        self.addChild(buttonShare)
        
        let boy = Boy()
        boy.setScale(1.3)
        boy.position = CGPointMake(self.frame.size.width * 0.13,self.frame.height * 0.4)
        boy.physicsBody?.affectedByGravity = false
        self.addChild(boy)
        
        labelRestart.text = "restart"
        labelRestart.fontSize = 40
        labelRestart.fontColor = SKColor.blackColor()
        labelRestart.position = CGPointMake(self.size.width/2, self.size.height*0.37)
        self.addChild(labelRestart)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func didTouchButton(#button:SKLabelNode,location:CGPoint) -> Bool{
        if button.position.y-50 < location.y && location.y < button.position.y+50 && button.position.x-60 < location.x && location.x < button.position.x+60{
            return true
        }else{
            return false
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {

        var touch:UITouch = touches.first as! UITouch
        let location = touch.locationInNode(self)

        if(didTouchButton(button:labelRestart,location:location)){
            let gameStartScene:GameScene = GameScene(size:self.size)
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            gameStartScene.scaleMode = .AspectFill
            gameStartScene.delayTime = tmpDelay
            self.view?.presentScene(gameStartScene, transition: reveal)
        }
        
        if(didTouchButton(button: buttonShare, location: location)){
            
            //截取当前屏幕截图
            //方法：布置一个新场景scene，建立一个新view，以目标截图为一个新texture建立新spriteNode
            //最后通过 drawViewHierarchyInRect 方法实现 获得图片
            let tex:SKTexture = self.view!.textureFromNode(self)!
            let view = SKView(frame :CGRectMake(0, 0, tex.size().width*0.3, tex.size().height*0.3))
            println("tex.size.width:\(tex.size().width)")
            println("view.frame.width:\(view.frame.width)")
            let sprite = SKSpriteNode(texture: tex)
            let label = SKLabelNode(text: "晒跑~校园~")
            label.fontSize = 50
            label.fontName = "Chalkduster"
            label.fontColor = SKColor(red: 255.0/255.0, green: 150/255.0, blue: 150/255.0, alpha: 1.0)
            sprite.setScale(0.3)
            let scene = SKScene(size: sprite.size)
            label.position = CGPointMake(view.frame.width/2, view.frame.height*0.84)
            sprite.position = CGPointMake(CGRectGetMidX(view.frame), CGRectGetMidY(view.frame) )
            scene.addChild(sprite)
            scene.addChild(label)
            view.presentScene(scene)
            UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0.0);
            view.drawViewHierarchyInRect(view.bounds , afterScreenUpdates: true)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext();

            let text = "我在『晒跑校园』游戏中得了\(self.score)分，快来追逐我的步伐吧！     下载地址：尚未上线，敬请期待"
            let activityItems = [image,text]
            let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            activityController
            (self.view!.nextResponder() as! UIViewController).presentViewController(activityController, animated: true, completion: nil)
            
            //UIImageWriteToSavedPhotosAlbum(image,nil,nil,nil)
            //showAlert()
        }
    }
    
    func showAlert(){
        //弹出 保存成功 提示
        let alert = UIAlertView()
        alert.title = ""
        alert.message = "截图保存成功"
        alert.addButtonWithTitle("Ok")
        alert.show()

    }
}


class GameScene: SKScene , SKPhysicsContactDelegate{

    var boy = Boy()
    var moving:SKNode!
    var buildings:SKNode!
    var enemys:SKNode!

    var gameoverLabelNode:SKLabelNode!
    var canRestart = Bool()
    var tmpScore = 0
    var score = 0
    var scoreLabelNode:SKLabelNode!
    
    //调整游戏难度，也就是enemy出现频率
    var delayTime:CGFloat!
    //按钮
    let buttonJump = SKSpriteNode(imageNamed: "buttonJump1")
    let buttonRestart = SKSpriteNode(imageNamed: "beizi1")
    let buttonWeaponBlanket = SKSpriteNode(imageNamed: "beizi1")
    let buttonWeaponPillow = SKSpriteNode(imageNamed: "zhentou1")
    
    let boyCategory: UInt32 = 0x1 << 0
    let buildingCategory: UInt32 = 0x1 << 1
    let enemyPillowCategory: UInt32 = 0x1 << 2
    let enemyBlanketCategory: UInt32 = 0x1 << 3
    let weaponPillowCategory: UInt32 = 0x1 << 4
    let weaponBlanketCategory: UInt32 = 0x1 << 5

    override func didMoveToView(view: SKView) {
        canRestart = false
        
        self.physicsWorld.gravity = CGVectorMake(0.0, -7)
        self.physicsWorld.contactDelegate = self
        
        //背景颜色
        let skyColor = SKColor(red: 10.0/255.0, green: 150.0/255.0, blue: 20.1/255.0, alpha: 1.0)
        self.backgroundColor = skyColor
        
        //添加一个移动的节点
        moving = SKNode()
        self.addChild(moving)
        moving.speed = 1
        
        //添加所有建筑物的节点
        buildings = SKNode()
        enemys = SKNode()

        moving.addChild(buildings)
        moving.addChild(enemys)
        
        //初始化地面
        let groundTexture = SKTexture(imageNamed: "land")
        groundTexture.filteringMode = SKTextureFilteringMode.Nearest
        let land1 = SKSpriteNode(texture: groundTexture)
        land1.position = CGPointMake(land1.size.width / 2.0, self.frame.height*0.243)
        let land2 = SKSpriteNode(texture: groundTexture)
        land2.position = CGPointMake(land1.size.width / 2.0 + self.frame.width,self.frame.height*0.243)
        //构建两个地面sprite，循环移动，使之看起来像是在前进
        let moveLand = SKAction.moveByX(-land1.size.width, y: 0, duration: 5)
        let resetLand = SKAction.moveByX(2 * land1.size.width, y: 0, duration: 0)
        land1.runAction(SKAction.repeatActionForever(SKAction.sequence([moveLand,resetLand,moveLand])))
        land2.runAction(SKAction.repeatActionForever(SKAction.sequence([moveLand,moveLand,resetLand])))

        //初始化校园背景
        let realTexture = SKTexture(imageNamed: "real1")
        let real1 = SKSpriteNode(texture: realTexture)
        real1.zPosition = -2
        real1.position = CGPointMake(real1.size.width / 2.0, self.frame.height - real1.size.height/2.0)
        
        let realTexture2 = SKTexture(imageNamed: "real2")
        let real2 = SKSpriteNode(texture: realTexture2)
        real2.zPosition = -2
        real2.position = CGPointMake(real2.size.width / 2.0 + self.frame.width, self.frame.height - real1.size.height/2.0)
        
        let realTexture3 = SKTexture(imageNamed: "real3")
        let real3 = SKSpriteNode(texture: realTexture3)
        real3.zPosition = -2
        real3.position = CGPointMake(real3.size.width / 2.0 + self.frame.width * 2.0 , self.frame.height - real1.size.height/2.0)
        
        let moveReal = SKAction.moveByX(-real1.size.width, y: 0, duration: 5)
        let resetReal = SKAction.moveByX(3 * real1.size.width, y: 0, duration: 0)
        
        real1.runAction(SKAction.repeatActionForever(SKAction.sequence([moveReal,resetReal,moveReal,moveReal])))
        real2.runAction(SKAction.repeatActionForever(SKAction.sequence([moveReal,moveReal,resetReal,moveReal])))
        real3.runAction(SKAction.repeatActionForever(SKAction.sequence([moveReal,moveReal,moveReal,resetReal])))
        
        moving.addChild(land1)
        moving.addChild(land2)
        moving.addChild(real1)
        moving.addChild(real2)
        moving.addChild(real3)

        //初始化主角
        boy.position = CGPointMake(self.frame.size.width * 0.13,self.frame.height * 0.45)
        boy.initialY = self.frame.height*0.45
        boy.physicsBody?.dynamic = true
        boy.physicsBody?.categoryBitMask = boyCategory
        
        boy.physicsBody?.collisionBitMask = buildingCategory
        boy.physicsBody?.contactTestBitMask = buildingCategory
        
        boy.physicsBody?.collisionBitMask = enemyBlanketCategory
        boy.physicsBody?.contactTestBitMask = enemyBlanketCategory

        boy.physicsBody?.collisionBitMask = enemyPillowCategory
        boy.physicsBody?.contactTestBitMask = enemyPillowCategory

        boy.run()
        moving.addChild(boy)
        
        //初始化按钮
        buttonWeaponBlanket.position = CGPoint(x: self.frame.width * 0.85,y: self.frame.height * 0.31)
        buttonRestart.position = CGPoint(x: self.frame.width * 0.5,y: self.frame.height * 0.56)
        buttonJump.position = CGPoint(x: self.frame.width * 0.13, y: self.frame.height * 0.235)
        buttonWeaponPillow.position = CGPoint(x: self.frame.width * 0.85, y: self.frame.height * 0.20)
        
        buttonWeaponBlanket.zPosition = 100
        buttonWeaponPillow.zPosition = 100
        buttonJump.zPosition = 100
        buttonRestart.zPosition = 100
        
        
        buttonRestart.hidden = true
        self.addChild(buttonRestart)
        self.addChild(buttonJump)
        self.addChild(buttonWeaponBlanket)
        self.addChild(buttonWeaponPillow)
        
        //持续创建建筑
        addBuilding()
        addEnemy()
        
        //生成game over 标签
        gameoverLabelNode = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        gameoverLabelNode.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.height*0.7)
        gameoverLabelNode.fontSize = 60
        gameoverLabelNode.text = "game over"
        self.gameoverLabelNode.hidden = true
        gameoverLabelNode.fontColor = SKColor(red: 1, green: 0, blue: 0, alpha: 1.0)
        self.addChild(gameoverLabelNode)
        
        //生成记分牌
        score = 0
        scoreLabelNode = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        scoreLabelNode.position = CGPointMake(self.frame.size.width*0.86,self.frame.size.height - 155 )
        scoreLabelNode.zPosition = 100
        scoreLabelNode.text = String()
        self.addChild(scoreLabelNode)
    }
    
    //生成一系列building
    func addBuilding(){
        
        if delayTime == nil{
            delayTime = 0.8
        }
        
        let createBuilding = SKAction.runBlock({() in self.createBuilding()})
        let delay = SKAction.waitForDuration(NSTimeInterval(delayTime*2))
        let createForever = SKAction.repeatActionForever(SKAction.sequence([createBuilding,delay]))
        moving.runAction(createForever)
        
    }
    //生成一个building
    func createBuilding(){
        let tmp = arc4random() % 6
        
        var tmpHeight = 10
        //减掉一定高度，使产生的building呈现出不同高度
        switch tmp{
        case 1:
            tmpHeight = 160
        case 2:
            tmpHeight = 70
        case 3:
            tmpHeight = 0
        case 4:
            tmpHeight = 100
        case 5:
            tmpHeight = 80
        default:
            tmpHeight = 40
         
        }

        var newBuilding = Enemy.createBuilding()
    
        newBuilding.position = CGPointMake(self.frame.size.width + newBuilding.size.width/2,self.frame.height * 0.45 - CGFloat(tmpHeight))
        newBuilding.zPosition = -1
        
        let moveBuilding = SKAction.moveByX(-self.frame.size.width - newBuilding.size.width,y:0,duration:4)
        let removeBuilding = SKAction.removeFromParent()
        let moveAndRemove = SKAction.sequence([moveBuilding,removeBuilding])
        newBuilding.name = "building"
        newBuilding.runAction(moveAndRemove)
        
        newBuilding.physicsBody?.dynamic = false
        newBuilding.physicsBody?.categoryBitMask = buildingCategory
        newBuilding.physicsBody?.contactTestBitMask = boyCategory
        newBuilding.physicsBody?.collisionBitMask = boyCategory
        if tmpHeight < 160 {
            buildings.addChild(newBuilding)
        }
    }
    
    //生成一系列enemy
    func addEnemy(){
        
        if delayTime == nil{
            delayTime = 0.8
        }
        
        let createBlanketEnemy = SKAction.runBlock({() in self.createBlanketEnemy()})
        let createPillowEnemy = SKAction.runBlock({() in self.createPillowEnemy()})
        let delay1 = SKAction.waitForDuration(NSTimeInterval(delayTime))
        let createForever = SKAction.repeatActionForever(SKAction.sequence([createBlanketEnemy,delay1,createPillowEnemy,delay1]))
        moving.runAction(createForever)
        
    }
    //生成一个blanketEnemy
    func createBlanketEnemy(){
        let tmp = arc4random() % 210
        
        
        var newEnemy = Enemy.createBlanketEnemy()
        
        newEnemy.position = CGPointMake(self.frame.size.width + newEnemy.size.width/2,self.frame.height * 0.45 + CGFloat( tmp))
        newEnemy.zPosition = 1
        let move = SKAction.moveByX(-self.frame.size.width-newEnemy.size.width,y:0,duration:3)
        let remove = SKAction.removeFromParent()
        let moveAndRemove = SKAction.sequence([move,remove])
        newEnemy.physicsBody?.affectedByGravity = false
        newEnemy.physicsBody?.dynamic = true
        newEnemy.runAction(moveAndRemove)
        newEnemy.physicsBody?.categoryBitMask = enemyBlanketCategory
        newEnemy.physicsBody?.contactTestBitMask = boyCategory
        newEnemy.physicsBody?.collisionBitMask = boyCategory
        
        enemys.addChild(newEnemy)
    }
    
    //生成一个pillowEnemy
    func createPillowEnemy(){
        let tmp = arc4random() % 100
        
        
        var newEnemy = Enemy.createPillowEnemy()
        
        newEnemy.position = CGPointMake(self.frame.size.width + newEnemy.size.width/2,self.frame.height * 0.45 + CGFloat( tmp))
        newEnemy.zPosition = 1
        let move = SKAction.moveByX(-self.frame.size.width-newEnemy.size.width,y:0,duration:3)
        let remove = SKAction.removeFromParent()
        let moveAndRemove = SKAction.sequence([move,remove])
        newEnemy.physicsBody?.affectedByGravity = false
        newEnemy.physicsBody?.dynamic = true
        newEnemy.runAction(moveAndRemove)
        newEnemy.physicsBody?.categoryBitMask = enemyPillowCategory
        newEnemy.physicsBody?.contactTestBitMask = boyCategory
        newEnemy.physicsBody?.collisionBitMask = boyCategory
        
        enemys.addChild(newEnemy)
    }
    
    //判断被按下按钮，手指触摸的位置是否与按钮位置重合
    func didTouchButton(#button:SKSpriteNode,location:CGPoint) -> Bool{
        if button.position.y-50 < location.y && location.y < button.position.y+50 && button.position.x-50 < location.x && location.x < button.position.x+50{
            return true
        }else{
            return false
        }
    }
    
    //按钮被按下的动画
    func ButtonDown() -> SKAction{
        let buttonTexture1 = SKTexture(imageNamed: "bird-03")
        let buttonTexture2 = SKTexture(imageNamed: "bird-04")
        let anim = SKAction.animateWithTextures([buttonTexture1,buttonTexture2], timePerFrame: 0.3)
        return anim
    }
    
    func jumpButtonDown() -> SKAction{
        let buttonTexture1 = SKTexture(imageNamed: "buttonJump2")
        let buttonTexture2 = SKTexture(imageNamed: "buttonJump1")
        let anim = SKAction.animateWithTextures([buttonTexture1,buttonTexture2], timePerFrame: 0.3)
        return anim
    }
    
    func pillowButton() -> SKAction{
        let pillowTexture1 = SKTexture(imageNamed: "zhentou2")
        let pillowTexture2 = SKTexture(imageNamed: "zhentou1")
        let anim = SKAction.animateWithTextures([pillowTexture1,pillowTexture2], timePerFrame: 0.3)
        return anim
    }
    
    func blanketButton() -> SKAction{
        let blanketTexture1 = SKTexture(imageNamed: "beizi2")
        let blanketTexture2 = SKTexture(imageNamed: "beizi1")
        let anim = SKAction.animateWithTextures([blanketTexture1,blanketTexture2], timePerFrame: 0.3)
        return anim
    }
    
    //射出武器
    func shoot(weaponKind:String){
        
        let moveWeaponSprite = SKAction.moveByX(frame.size.width, y: 0, duration: 1.0)
        let remove = SKAction.removeFromParent()
        let moveAndRemove = SKAction.sequence([moveWeaponSprite,remove])
        
        let weaponTexture = SKTexture(imageNamed:weaponKind)
        let weapon = SKSpriteNode(texture: weaponTexture)
        weapon.position = boy.position
        weapon.zPosition = -1
        
        weapon.physicsBody = SKPhysicsBody(texture:weaponTexture,size:weaponTexture.size())
        
        weapon.physicsBody?.affectedByGravity = false
        
        if(weaponKind=="beizi"){
            weapon.physicsBody?.categoryBitMask = weaponBlanketCategory
            weapon.physicsBody?.contactTestBitMask = enemyBlanketCategory
            weapon.physicsBody?.collisionBitMask = enemyBlanketCategory
        }else{
            weapon.physicsBody?.categoryBitMask = weaponPillowCategory
            weapon.physicsBody?.contactTestBitMask = enemyPillowCategory
            weapon.physicsBody?.collisionBitMask = enemyPillowCategory
        }
        
        moving.addChild(weapon)
        weapon.runAction(moveAndRemove)
        
        //weapon.physicsBody?.velocity = CGVector(dx:0.0,dy:0.0)
        //weapon.physicsBody?.applyImpulse(CGVectorMake(0.0,1))
    }
    
    //武器碰撞的动画
    func onHitPillow() -> SKAction{
        let pillow1 = SKTexture(imageNamed: "pillow1")
        let pillow2 = SKTexture(imageNamed: "pillow2")

        let anim = SKAction.animateWithTextures([pillow1,pillow2], timePerFrame: 0.5)
        return anim
    }
    
    func stopScene(){
        moving.speed = 0
        //buttonRestart.hidden = false
        
        boy.status = .roll
        
        /*
        boy.runAction( SKAction.rotateByAngle(CGFloat(M_PI) * CGFloat(boy.position.y) * 0.01, duration:1), completion:{self.boy.speed = 0 })
        boy.removeFromParent()
        
        let showLabelAction:SKAction = SKAction.runBlock(
            {
                self.gameoverLabelNode.hidden = false
            }
        )
        //红白交替显示game over 文字
        let redColorAction:SKAction = SKAction.runBlock({
            self.gameoverLabelNode.fontColor = SKColor(red: 1, green: 0, blue: 0, alpha: 1.0)
        })
        let whiteColorAction:SKAction = SKAction.runBlock({
            self.gameoverLabelNode.fontColor = SKColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        })
        let wait = SKAction.waitForDuration(NSTimeInterval(0.2))
        let canRestartAction = SKAction.runBlock({self.canRestart = true})
        let actions = [showLabelAction,redColorAction,whiteColorAction,wait]
        let repeatAction = SKAction.repeatAction(SKAction.sequence(actions), count: 2)
        
        self.runAction(SKAction.sequence([repeatAction,canRestartAction]))
        */
    }
    
    func resetScene (){
        // Move bird to original position and reset velocity
        gameoverLabelNode.hidden = true
        boy.removeAllActions()
        buttonRestart.hidden = true
        
        boy.position = CGPointMake(self.frame.size.width * 0.13,self.frame.height * 0.45)
        boy.initialY = self.frame.height*0.45
        boy.physicsBody?.dynamic = true
        boy.physicsBody?.categoryBitMask = boyCategory
        boy.physicsBody?.collisionBitMask = buildingCategory
        boy.physicsBody?.contactTestBitMask = buildingCategory
        boy.run()
        moving.addChild(boy)
        
        
        // Remove all existing pipes
        buildings.removeAllChildren()
        enemys.removeAllChildren()
        // Reset _canRestart
        canRestart = false
        gameoverLabelNode.hidden = true
        // Reset score
        score = 0
        //scoreLabelNode.text = String(score)
        
        // Restart animation
        moving.speed = 1
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            if moving.speed > 0{
                if boy.status == Status.run{
                    if didTouchButton(button: buttonJump, location: location){
                    boy.jump()
                    buttonJump.runAction(jumpButtonDown())
                    }
                }else if boy.status == Status.jump{
                    if boy.position.y > self.frame.size.height*0.62{
                        if didTouchButton(button: buttonJump, location: location){
                        boy.jumpSecond()
                        buttonJump.runAction(jumpButtonDown())
                        }
                    }
                }
            
                if didTouchButton(button: buttonWeaponBlanket, location: location){
                    shoot("beizi")
                    buttonWeaponBlanket.runAction(blanketButton())
                }else if didTouchButton(button: buttonWeaponPillow, location: location){
                    shoot("pillow1")
                    buttonWeaponPillow.runAction(pillowButton())
                }
            }else{
                if didTouchButton(button: buttonRestart,location:location){
                    if canRestart == true{
                        resetScene()
                    }
                }
            }
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if moving.speed > 0{
            if ( contact.bodyA.categoryBitMask |  contact.bodyB.categoryBitMask) == ( boyCategory | buildingCategory )
            || ( contact.bodyA.categoryBitMask |  contact.bodyB.categoryBitMask) == ( boyCategory | enemyBlanketCategory)
            || ( contact.bodyA.categoryBitMask |  contact.bodyB.categoryBitMask) == ( boyCategory | enemyPillowCategory )
            {
                stopScene()
                let reveal = SKTransition.flipHorizontalWithDuration(0.5);
                let gameOverScene = GameOverScene(size:self.size, score: score, delay: delayTime);
                //gameOverScene.score = score
                //gameOverScene.tmpDelay = delayTime
                self.view?.presentScene(gameOverScene, transition: reveal);
            }
            
            else if ( contact.bodyA.categoryBitMask |  contact.bodyB.categoryBitMask) == ( weaponPillowCategory | enemyPillowCategory ){
                
                //击落敌人加分
                if let tmpA = contact.bodyA.node as? SKSpriteNode {
                    tmpA.removeFromParent()
                    score += 10
                }
                if let tmpB = contact.bodyB.node as? SKSpriteNode{
                    tmpB.removeFromParent()
                }
            }
            
            else if ( contact.bodyA.categoryBitMask |  contact.bodyB.categoryBitMask) == ( weaponBlanketCategory | enemyBlanketCategory ){
                
                //击落敌人加分
                if let tmpA = contact.bodyA.node as? SKSpriteNode {
                    tmpA.removeFromParent()
                    score += 10
                }
                if let tmpB = contact.bodyB.node as? SKSpriteNode{
                    tmpB.removeFromParent()
                }
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if moving.speed > 0 {
            
            //显示当前跑动距离
            tmpScore++
            if(tmpScore == 10){
                score++
                tmpScore = 0
                scoreLabelNode.text = String("分数 : \(score)")
                // Add a little visual feedback for the score increment
                scoreLabelNode.runAction(SKAction.sequence([SKAction.scaleTo(1.5, duration:NSTimeInterval(0.1)), SKAction.scaleTo(1.0, duration:NSTimeInterval(0.1))]))
            }
            
            
            if boy.position.y < self.frame.height*0.45 {
                boy.status = .run
                boy.position.y = self.frame.height*0.45
            }
        
            if boy.status == Status.run {
                self.physicsWorld.gravity = CGVectorMake(0.0, 0.0)
                boy.position.y = self.frame.height*0.45
                boy.position.x = self.frame.width*0.13
            }else if boy.status == Status.jump{
                self.physicsWorld.gravity = CGVectorMake(0.0, -7)
            }
        }
    }
    
    
}

/*
var firstBody:SKPhysicsBody
var secondBody:SKPhysicsBody

if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
{
firstBody = contact.bodyA
secondBody = contact.bodyB
}
else
{
firstBody = contact.bodyB
secondBody = contact.bodyA
}

if let tmp = secondBody.node as? SKSpriteNode {
tmp.removeFromParent()
}*/
