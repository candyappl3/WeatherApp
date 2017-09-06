//
//  ParticlesView.swift
//  WeatherApp
//
//  Created by Dmitry Shadrin on 30.08.17.
//  Copyright © 2017 Dmitry Shadrin. All rights reserved.
//

import UIKit
import SpriteKit

class ParticlesView: SKView {
  override func didMoveToSuperview() {
    
    let scene = SKScene(size: self.frame.size)
    scene.backgroundColor = #colorLiteral(red: 0.4053938733, green: 0.4389288056, blue: 0.4876467322, alpha: 1)
    self.presentScene(scene)
    
    self.allowsTransparency = true
    self.backgroundColor = .clear
    
    if let particles = SKEmitterNode(fileNamed: "rain.sks") {
      particles.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height + 20)
      particles.particlePositionRange = CGVector(dx: self.bounds.size.width, dy: 0)
      scene.addChild(particles)
    }
    
  }
}
