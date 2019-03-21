//
//  ViewController.swift
//  ARKit Template
//
//  Created by Denis Bystruev on 21/03/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.autoenablesDefaultLighting = true
        
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.debugOptions = [.showWorldOrigin, .showFeaturePoints]
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        loadCampus()
        loadCampusFrom(sceneFile: "art.scnassets/campus.scn")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ... Custom Methods
    func loadCampus() {
        let node = SCNNode()
        node.position = SCNVector3(0, -1, -3)
        
        node.addChildNode(loadMainBuilding())
        node.addChildNode(loadGrass())
        
        for z in stride(from: Float(-0.5), through: 0.5, by: 0.5) {
            node.addChildNode(loadTree(x: 2, y: 0, z: z))
        }
        
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    func loadMainBuilding() -> SCNNode {
        let node = SCNNode()
        node.position.y = 0.5
        
        let box = SCNBox(width: 3, height: 1, length: 1, chamferRadius: 0)
        node.geometry = box
        
        let colors = [#colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)]
        var materials = [SCNMaterial]()
        
        colors.forEach { color in
            let material = SCNMaterial()
            material.diffuse.contents = color
            materials += [material]
        }
        box.materials = materials
        
        return node
    }
    
    func loadGrass() -> SCNNode {
        let node = SCNNode(geometry: SCNPlane(width: 5, height: 2))
        node.eulerAngles.x = -.pi / 2
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.green
        node.position.y = -0.01
        
        return node
    }
    
    func loadTree(x: Float = 0, y: Float = 0, z: Float = 0) -> SCNNode {
        let node = SCNNode()
        node.position = SCNVector3(x, y, z)
        node.scale = SCNVector3(0.25, 0.25, 0.25)
        
        let stall = SCNNode(geometry: SCNCylinder(radius: 0.05, height: 2))
        stall.position.y = 1
        stall.geometry?.firstMaterial?.diffuse.contents = UIColor.brown
        node.addChildNode(stall)
        
        let crown = SCNNode(geometry: SCNSphere(radius: 0.5))
        crown.position.y = 2
        crown.geometry?.firstMaterial?.diffuse.contents = UIColor.green
        node.addChildNode(crown)
        
        return node
    }
    
    func loadCampusFrom(sceneFile: String) {
        guard let scene = SCNScene(named: sceneFile) else { return }
        
        let node = scene.rootNode
        
        sceneView.scene.rootNode.addChildNode(node)
    }
}
