# running_game-swift using SpriteKit
The game is mainly using two kind of weapons (pillow and blanket) against two kind of enemies(pillow and blanket) as well as escaping pipe blocks.

Key features:

1. Player is allowed to add avatar on the role

2. Able to share to social network like Facebook

3. Able to modify the difficulty, the frequency of enemies and blocks.

4. Pillow bullet can only kill pillow enemy, so does blanket.

![alt tag](https://cloud.githubusercontent.com/assets/9973368/13761379/9c5f3d0a-ea0e-11e5-9b72-7fabbbe8eb32.gif)

##Tech specs

###1. Filter on Image
![alt tag](https://cloud.githubusercontent.com/assets/9973368/13761808/305aba50-ea11-11e5-95bb-92e26b6fdc7f.gif)
```swift
    var filter: CIFilter!
    filter = CIFilter(name: "CISepiaTone")
    filter.setValue(beginImage, forKey: kCIInputImageKey)
    filter.setValue(0.5, forKey: kCIInputIntensityKey)
    
        @IBAction func amountSliderValueChanged(sender: UISlider) {
        
        let sliderValue = sender.value
        
        filter.setValue(sliderValue, forKey: kCIInputIntensityKey)
        
        let outputImage = filter.outputImage
        
        let cgimg = context.createCGImage(outputImage!, fromRect: outputImage!.extent)

        let newImage = UIImage(CGImage: cgimg, scale:1, orientation:orientation)
        
        self.imageView.image = newImage
        
    }
```
###2. UIImagePicker  
![alt tag](https://cloud.githubusercontent.com/assets/9973368/13761962/56f28eb2-ea12-11e5-9e4e-9d648555926b.gif)
```swift
    //load the imagepickercontroller
    @IBAction func loadPhoto(sender : AnyObject) {
        
        let pickerC = UIImagePickerController()
        
        pickerC.delegate = self
        
        //let popover = UIPopoverController(contentViewController: pickerC)
        //popover.presentPopoverFromRect(self.chooseImgButton.frame, inView: self.view, permittedArrowDirections: .Up, animated: true)
        
        self.presentViewController(pickerC, animated: true, completion: nil)
        
    }
    
    //get the chosen image 
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil);
        let gotImage = image
        beginImage = CIImage(image: gotImage)
        filter.setValue(beginImage, forKey: kCIInputImageKey)
        orientation = gotImage.imageOrientation
        self.amountSliderValueChanged(fliterSlider)
    }

    
    //save image
    @IBAction func savePhoto(sender: AnyObject) {
        let tmpImage = imageView.image
        
        let imageFrame:CGSize = CGSizeMake(100, 100)
        let image = scaleToSize(tmpImage!, size: imageFrame)
        let filePath = NSHomeDirectory() + "/Documents/head.png"
        //println(filePath)
        UIImageJPEGRepresentation(image, 1.0)!.writeToFile(filePath, atomically: true)
    }
    
    //resize the image to make it fit in the game scene
    func scaleToSize(img:UIImage , size: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(size,false,1.0)
        imageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        
        _ = UIGraphicsGetCurrentContext()
        let rect = CGRectMake(0, 0, size.width, size.height)

        img.drawInRect(rect)
        
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImg
    }
    
    @IBAction func clearPhoto(sender:AnyObject) {
        let filePath = NSHomeDirectory() + "/Documents/head.png"
        let fileManager = NSFileManager()
        
        do{
            try fileManager.removeItemAtPath(filePath)
        }catch{
            print(error)
        }
    }
```

###3. Social Sharing 
![alt tag](https://cloud.githubusercontent.com/assets/9973368/13762498/c1f3847a-ea15-11e5-9ff3-b2b98de3369b.gif)
```swift
        if(didTouchButton(button: buttonShare, location: location)){
            //截取当前屏幕截图
            //方法：布置一个新场景scene，建立一个新view，以目标截图为一个新texture建立新spriteNode
            //最后通过 drawViewHierarchyInRect 方法实现 获得图片
            let aimTexture:SKTexture = self.view!.textureFromNode(self)!
            let view = SKView(frame :CGRectMake(0, 0, aimTexture.size().width*0.3, aimTexture.size().height*0.3))

            let sprite = SKSpriteNode(texture: aimTexture)
            sprite.setScale(0.3)
            sprite.position = CGPointMake(CGRectGetMidX(view.frame), CGRectGetMidY(view.frame) )
            
            let label = SKLabelNode(text: "晒跑~校园~")
            label.fontSize = 50
            label.fontName = "Chalkduster"
            label.fontColor = SKColor(red: 255.0/255.0, green: 150/255.0, blue: 150/255.0, alpha: 1.0)
            label.position = CGPointMake(view.frame.width/2, view.frame.height*0.84)

            
            let scene = SKScene(size: sprite.size)
            scene.addChild(sprite)
            scene.addChild(label)
            
            view.presentScene(scene)
            UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0.0);
            view.drawViewHierarchyInRect(view.bounds , afterScreenUpdates: true)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext();

            let text = "I get \(self.score) points in running game，join with me now！     download url：www.bingchen.com"
            let activityItems = [image,text]
            let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            activityController
            (self.view!.nextResponder() as! UIViewController).presentViewController(activityController, animated: true, completion: nil)
            
            //UIImageWriteToSavedPhotosAlbum(image,nil,nil,nil)
        }
```

###4. SpriteKit

####Usage

#### 1. Animate
```swift
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
    
  func scoreChange(){
    //score label count
    tmpScore++
    if(tmpScore == 10){
      score++
      tmpScore = 0
      scoreLabelNode.text = String("score : \(score)")
      // Add a little visual feedback for the score increment
      scoreLabelNode.runAction(SKAction.sequence([SKAction.scaleTo(1.5, duration:NSTimeInterval(0.1)), SKAction.scaleTo(1.0, duration:NSTimeInterval(0.1))]))
    }
  }
```
####2. Extract Circle Image
```swift
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

```
####3 Class Function
```swift
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
}
```

####4 Spritenode BitMask
```swift
        boy.physicsBody?.dynamic = true
        boy.physicsBody?.categoryBitMask = boyCategory
        
        boy.physicsBody?.collisionBitMask = buildingCategory
        boy.physicsBody?.contactTestBitMask = buildingCategory
        
        
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
```

####5 Spritenode Initialize
```swift
    //create a seirs of enemies permantely
    func addEnemy(){
        
        let createBlanketEnemy = SKAction.runBlock({() in self.createBlanketEnemy()})
        let createPillowEnemy = SKAction.runBlock({() in self.createPillowEnemy()})
        let delay1 = SKAction.waitForDuration(NSTimeInterval(delayTime))
        let createForever = SKAction.repeatActionForever(SKAction.sequence([createBlanketEnemy,delay1,createPillowEnemy,delay1]))
        moving.runAction(createForever)
        
    }
    //create one blanketEnemy
    func createBlanketEnemy(){
        let tmp = arc4random() % 210
        
        
        let newEnemy = Enemy.createBlanketEnemy()
        
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
```




