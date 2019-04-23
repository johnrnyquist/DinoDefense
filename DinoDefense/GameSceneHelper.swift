//
//  GameSceneHelper.swift
//  VillageDefense
//
//  Created by Toby Stephens on 26/09/2015.
//  Copyright © 2015 razeware. All rights reserved.
//

import SpriteKit
import GameKit
import AVFoundation

// The names and zPositions of all the key layers in the GameScene
enum GameLayer: CGFloat {
    // The difference in zPosition between all the dinosaurs, towers and obstacles
    static let zDeltaForSprites: CGFloat = 10
    // The zPositions of all the GameScene layers
    case Background = -100
    case Shadows = -50
    case Sprites = 0
    case Hud = 1000
    case Overlay = 1100
    // The name the layers in the GameScene scene file
    var nodeName: String {
        switch self {
            case .Background: return "Background"
            case .Shadows: return "Shadows"
            case .Sprites: return "Sprites"
            case .Hud: return "Hud"
            case .Overlay: return "Overlay"
        }
    }
    // All layers
    static var allLayers = [Background, Shadows, Sprites, Hud, Overlay]
}

class GameSceneHelper: SKScene {
    // All the GameScene layer nodes
    var gameLayerNodes = [GameLayer: SKNode]()
    // Used when placing dinosaurs
    let random = GKRandomDistribution.d20()
    // View size and scale
    var viewSize: CGSize {
        return self.view!.frame.size
    }
    var sceneScale: CGFloat {
        let minScale = min(viewSize.width / self.size.width,
                           viewSize.height / self.size.height)
        let maxScale = max(viewSize.width / self.size.width,
                           viewSize.height / self.size.height)
        return sqrt(minScale / maxScale)
    }
    // HUD
    var baseLabel: SKLabelNode!
    var waveLabel: SKLabelNode!
    var goldLabel: SKLabelNode!
    // Nodes used for the screens for the different game states
    var readyScreen: ReadyNode!
    var winScreen: WinNode!
    var loseScreen: LoseNode!
    // Base lives
    var baseLives = 5
    // Gold
    var gold = 75
    // Background music
    var musicPlayer: AVAudioPlayer!
    // Sound effects
    let baseDamageSoundAction = SKAction.playSoundFileNamed("LifeLost.mp3",
                                                            waitForCompletion: false)
    let winSoundAction = SKAction.playSoundFileNamed("YouWin.mp3",
                                                     waitForCompletion: false)
    let loseSoundAction = SKAction.playSoundFileNamed("YouLose.mp3",
                                                      waitForCompletion: false)

    override func didMove(to view: SKView) {
        super.didMove(to: view)

        // No need for gravity
        physicsWorld.gravity = CGVector.zero

        // Load the game layers
        loadGameLayers()

        // Layout the HUD elements so that they are in the correct position for the screen size
        layoutHUD()

        // Load screens for Ready, Win and Lose states
        loadStateScreens()

        // Ready
        showReady(show: true)
    }

    func startBackgroundMusic() {
        // Start the background music
        let musicFileURL = Bundle.main.url(forResource: "BackgroundMusic",
                                           withExtension: "mp3")
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: musicFileURL!)
            musicPlayer.prepareToPlay()
            musicPlayer.volume = 0.5
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        } catch {
            fatalError("Error loading \(String(describing: musicFileURL)): \(error)")
        }
    }

    // Load the Game layers
    func loadGameLayers() {
        for gameLayer in GameLayer.allLayers {
            // Find the node in the scene file
            let foundNodes = self[gameLayer.nodeName]
            let layerNode = foundNodes.first!

            // Set the zPosition - should be the same as the scene file, but worth setting
            layerNode.zPosition = gameLayer.rawValue

            // Store Game layer node
            gameLayerNodes[gameLayer] = layerNode
        }
    }

    // Layout the HUD elements to fit the screen
    func layoutHUD() {
        let hudNode = gameLayerNodes[.Hud]!

        // Position Base Health label
        if let baseLabel = hudNode.childNode(withName: "BaseLabel") as? SKLabelNode {
            self.baseLabel = baseLabel
            self.baseLabel.position = CGPoint(x: baseLabel.position.x,
                                              y: (self.size.height - baseLabel.position.y) * sceneScale)
            self.baseLabel.alpha = 0
        }

        // Position Wave label
        if let waveLabel = hudNode.childNode(withName: "WaveLabel") as? SKLabelNode {
            self.waveLabel = waveLabel
            self.waveLabel.position = CGPoint(x: waveLabel.position.x,
                                              y: (self.size.height - waveLabel.position.y) * sceneScale)
            self.waveLabel.alpha = 0
        }

        // Position Gold label
        if let goldLabel = hudNode.childNode(withName: "GoldLabel") as? SKLabelNode {
            self.goldLabel = goldLabel
            self.goldLabel.position = CGPoint(x: goldLabel.position.x,
                                              y: (self.size.height - goldLabel.position.y) * sceneScale)
            self.goldLabel.alpha = 0
        }
    }

    // Update the hud labels
    func updateHUD() {
        baseLabel.text = "Lives: \(max(0, baseLives))"
        goldLabel.text = "Gold: \(gold)"
    }

    // Load the screens for the Ready, Win and Lose states from their SKS files
    func loadStateScreens() {
        // Ready
        let readyScenePath: String = Bundle.main.path(forResource: "ReadyScene",
                                                      ofType: "sks")!
        let readyScene = NSKeyedUnarchiver.unarchiveObject(withFile: readyScenePath) as! SKScene
        if let readyScreen = (readyScene.childNode(withName: "MainNode"))!.copy() as? ReadyNode {
            self.readyScreen = readyScreen
        }

        // Win
        let winScenePath: String = Bundle.main.path(forResource: "WinScene",
                                                    ofType: "sks")!
        let winScene = NSKeyedUnarchiver.unarchiveObject(withFile: winScenePath) as! SKScene
        if let winScreen = (winScene.childNode(withName: "MainNode"))!.copy() as? WinNode {
            self.winScreen = winScreen
        }

        // Lose
        let loseScenePath: String = Bundle.main.path(forResource: "LoseScene",
                                                     ofType: "sks")!
        let loseScene = NSKeyedUnarchiver.unarchiveObject(withFile: loseScenePath) as! SKScene
        if let loseScreen = (loseScene.childNode(withName: "MainNode"))!.copy() as? LoseNode {
            self.loseScreen = loseScreen
        }
    }

    // Show the state screens
    func showReady(show: Bool) {
        if show {
            updateHUD()
            addNode(node: readyScreen,
                    toGameLayer: .Overlay)
            readyScreen.show()
        } else {
            readyScreen.hide()
        }
    }

    func showWin() {
        // Play the end music
        self.run(winSoundAction)

        // Stop the background music
        musicPlayer.pause()

        // Show the win screen
        winScreen.alpha = 0.0
        addNode(node: winScreen,
                toGameLayer: .Overlay)
        winScreen.run(SKAction.sequence([SKAction.fadeAlpha(to: 1.0,
                                                            duration: 1.0), SKAction.run({ () -> Void in
            // Pause the scene
            self.speed = 0.1
        })]))
        winScreen.show()
    }

    func showLose() {
        // Play the end music
        self.run(loseSoundAction)

        // Stop the background music
        musicPlayer.pause()

        // Show the lose screen
        loseScreen.alpha = 0.0
        addNode(node: loseScreen,
                toGameLayer: .Overlay)
        loseScreen.run(SKAction.sequence([SKAction.fadeAlpha(to: 1.0,
                                                             duration: 1.0), SKAction.run({ () -> Void in
            // Pause the scene
            self.speed = 0.1
        })]))
        loseScreen.show()
    }

    func addNode(node: SKNode,
                 toGameLayer: GameLayer) {
        gameLayerNodes[toGameLayer]!.addChild(node)
    }
}
