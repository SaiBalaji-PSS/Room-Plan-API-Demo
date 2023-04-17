//
//  ModelViewerVC.swift
//  RoomCaptureApp
//
//  Created by Sai Balaji on 16/04/23.
//

import UIKit
import SceneKit

class ModelViewerVC: UIViewController {
    var model: SCNScene!
    @IBOutlet weak var optionsSegmentControl: UISegmentedControl!
    var type: SCNLight.LightType!
    @IBOutlet weak var modelViewer: SCNView!
    var modelFilePath: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print(modelFilePath)
        self.type = .ambient
        configureUI()
        optionsSegmentControl.selectedSegmentIndex = 1
        
    }
    
    
    
    func configureUI(){
        modelViewer.scene?.rootNode.removeFromParentNode()
         model = try! SCNScene(url:URL(string: "\(modelFilePath)")!)
        modelViewer.showsStatistics = true
        
        
       // modelViewer.debugOptions.remove(SCNDebugOptions.renderAsWireframe)
        modelViewer.allowsCameraControl = true
        if modelViewer.debugOptions.contains(SCNDebugOptions.renderAsWireframe){
            model.background.contents = UIColor.black
        }
        else{
            model.background.contents = UIColor.gray
        }
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        //lightNode.light?.color = UIColor.blue
        lightNode.position = SCNVector3(x: 150, y: 10, z: 100)
        lightNode.light?.type = self.type
        model.rootNode.geometry?.firstMaterial!.fillMode = .lines
        model.rootNode.addChildNode(lightNode)
        modelViewer.scene = model
        
    }
    
    @IBAction func didSegmentValueChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
            case 0:
            modelViewer.debugOptions.insert(SCNDebugOptions.renderAsWireframe)
            model.background.contents = UIColor.black
            self.type = .ambient
            configureUI()
            break
            case 1:
            modelViewer.debugOptions.remove(SCNDebugOptions.renderAsWireframe)
            self.type = .ambient
            configureUI()
            break
            case 2:
            self.type = .directional
            modelViewer.debugOptions.remove(SCNDebugOptions.renderAsWireframe)
            
            configureUI()
            break
            default:
            break
        }
    }
    

    

}
