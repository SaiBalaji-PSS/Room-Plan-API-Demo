//
//  ModelCell.swift
//  RoomCaptureApp
//
//  Created by Sai Balaji on 16/04/23.
//

import UIKit
import SceneKit

class ModelCell: UITableViewCell {

    @IBOutlet weak var modelPreviewView: SCNView!
    
    @IBOutlet weak var creationDate: UILabel!
    @IBOutlet weak var modelName: UILabel!
   // var modelPath: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func updateCell(path: String,modelName: String,creationDate: String){
        
       var model = try! SCNScene(url: URL(string: path)!)
        model.background.contents = UIColor.gray
        modelPreviewView.allowsCameraControl = true
        print(model.rootNode.childNodes)

        let lightnode = SCNNode()
        lightnode.light = SCNLight()
        
        lightnode.light?.type = .directional
        lightnode.position = SCNVector3(x: 0, y: 10, z: 20)
        lightnode.light?.color = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 0.5373810017)
        model.rootNode.addChildNode(lightnode)
        modelPreviewView.scene = model
        self.modelName.text = modelName
        self.creationDate.text = creationDate
        
    }
    
}
