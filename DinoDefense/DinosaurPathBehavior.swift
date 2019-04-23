//
//  DinosaurPathBehavior.swift
//  DinoDefense
//
//  Created by Toby Stephens on 21/10/2015.
//  Copyright © 2015 razeware. All rights reserved.
//

import Foundation
import GameplayKit

class DinosaurPathBehavior: GKBehavior {
  
  static func pathBehavior(forAgent agent: GKAgent,
    onPath path: GKPath,
    avoidingObstacles obstacles: [GKPolygonObstacle])
    -> DinosaurPathBehavior {
      
      let behavior = DinosaurPathBehavior()
      
        behavior.setWeight(0.5,
                           for: GKGoal(toReachTargetSpeed: agent.maxSpeed))
        behavior.setWeight(1.0,
                           for: GKGoal(toAvoid: obstacles, maxPredictionTime: 0.5))
        behavior.setWeight(1.0,
                           for: GKGoal(toFollow: path, maxPredictionTime: 0.5,
          forward: true))
        behavior.setWeight(1.0,
                           for: GKGoal(toStayOn: path, maxPredictionTime: 0.5))
      
      return behavior
      
  }
  
}

