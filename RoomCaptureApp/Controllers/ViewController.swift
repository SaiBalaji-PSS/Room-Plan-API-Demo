//
//  ViewController.swift
//  RoomCaptureApp
//
//  Created by Sai Balaji on 14/04/23.
//

import UIKit
import RoomPlan

class ViewController: UIViewController {

    
    @IBOutlet weak var scannedResultTV: UITableView!
    var scannedModels = [ScannedModel]()
    var dates = [String]()
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.scannedModels.removeAll()
        self.scannedResultTV.reloadData()
        getFilePaths()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil, image: UIImage(systemName: "camera.aperture"), target: self, action: #selector(scanBtnPressed))
        title = "Room Scanner"
        navigationController?.navigationBar.prefersLargeTitles = true
        scannedResultTV.delegate = self
        scannedResultTV.dataSource = self
        scannedResultTV.register(UINib(nibName: "ModelCell", bundle: nil), forCellReuseIdentifier: "CELL")
   
        
    }
    
    @objc func scanBtnPressed(){
        print("PRESSED")
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "roomScannerVC") as? RoomScannerVC{
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func getFilePaths(){
        let fm = FileManager.default
        let path = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
        do{
            let content = try fm.contentsOfDirectory(atPath: path.path)
            print(path)
            print(path.absoluteString)
            print(path.absoluteURL)
            print(path.path(percentEncoded: false))
            print(content)
            for c in content{
                self.scannedModels.append(ScannedModel(filePath: path.appendingPathComponent(c).absoluteString, creationDate: "\(try! fm.attributesOfItem(atPath: path.appendingPathComponent(c).path)[.creationDate] as? NSDate)"))
            }
            
            self.scannedResultTV.reloadData()
        }
        catch{
            print(error)
        }
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scannedModels.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as? ModelCell{
            cell.updateCell(path: scannedModels[indexPath.row].filePath, modelName: (scannedModels[indexPath.row].filePath as! NSString).lastPathComponent,creationDate: self.getFileCreationDate(path: URL(string:  scannedModels[indexPath.row].filePath)!)!)
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ModelViewerVC") as? ModelViewerVC{
            vc.modelFilePath = scannedModels[indexPath.row].filePath
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
    


extension ViewController{
    func getFileCreationDate(path: URL) -> String?{
        do{
            if let date = try FileManager.default.attributesOfItem(atPath: path.path(percentEncoded: false))[.creationDate] as? Date{
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yyyy"
                return formatter.string(from: date)
            }
           
        }
        catch{
            print(error)
        }
        return nil
    }
}
