//
//  RoomScannerVC.swift
//  RoomCaptureApp
//
//  Created by Sai Balaji on 14/04/23.
//

import UIKit
import RoomPlan
class RoomScannerVC: UIViewController{
 
    
    @IBOutlet weak var doorCountLbl: UILabel!
    @IBOutlet weak var wallCountLbl: UILabel!
    
    @IBOutlet weak var openingCountLbl: UILabel!
    
    var roomBuilder = RoomBuilder(options: [.beautifyObjects])
    @IBOutlet weak var roomScannerView: UIView!
    private var roomCaptureView: RoomCaptureView!
    private var roomCaptureSessionConfiguration: RoomCaptureSession.Configuration = RoomCaptureSession.Configuration()
    private var finalResult: CapturedRoom?
    
    @IBOutlet weak var exportBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        exportBtn.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startSession()
        
    }
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.largeTitleDisplayMode = .never
        setupRoomCapture()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Stop", image: nil, target: self, action: #selector(stopScanning))
       
    }
    
    @objc func stopScanning(){
        roomCaptureView.captureSession.stop()
    }
    

    func setupRoomCapture(){
        roomCaptureView = RoomCaptureView(frame: roomScannerView.bounds)
        roomCaptureView.captureSession.delegate = self
        roomCaptureView.delegate = self
        roomScannerView.insertSubview(roomCaptureView, at: 0)
    }
    func startSession(){
        roomCaptureView.captureSession.run(configuration: roomCaptureSessionConfiguration)
        
    }

    @IBAction func exportBtnPressed(_ sender: Any) {
        
        if let finalResult{
            var fm = FileManager.default
            var path = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileName = "\(UUID().uuidString).usdz"
            path.appendPathComponent(fileName)
            do{
                try finalResult.export(to: path.absoluteURL)
            }
            catch{
                print(error)
            }
            
        }
    }
}


extension RoomScannerVC:  RoomCaptureSessionDelegate {
    func captureSession(_ session: RoomCaptureSession, didUpdate room: CapturedRoom) {
        DispatchQueue.main.async {
            self.doorCountLbl.text = "\(room.doors.count)"
            self.openingCountLbl.text = "\(room.openings.count)"
            self.wallCountLbl.text = "\(room.walls.count)"
        }
 
        print(room.doors.count)
        print(room.openings.count)
        print(room.walls.count)

        print(room.objects.first?.category == CapturedRoom.Object.Category.table)
    }
    
    func captureSession(_ session: RoomCaptureSession, didAdd room: CapturedRoom) {
        
    }
    
    func captureSession(_ session: RoomCaptureSession, didChange room: CapturedRoom) {
        
    }
    
    func captureSession(_ session: RoomCaptureSession, didRemove room: CapturedRoom) {
        
    }
    
    func captureSession(_ session: RoomCaptureSession, didProvide instruction: RoomCaptureSession.Instruction) {
        
    }
    
    func captureSession(_ session: RoomCaptureSession, didStartWith configuration: RoomCaptureSession.Configuration) {
        
    }
    
    func captureSession(_ session: RoomCaptureSession, didEndWith data: CapturedRoomData, error: (Error)?) {
        //called when capture is stopped or stopped with an error
        if let error{
            print(error)
        }
        Task{
            let finalroom = try! await roomBuilder.capturedRoom(from: data)
            print(finalroom.objects)
            
        }
    }
}



extension RoomScannerVC: RoomCaptureViewDelegate{
    func captureView(shouldPresent roomDataForProcessing: CapturedRoomData, error: (Error)?) -> Bool {
        return true
    }
    
    func captureView(didPresent processedResult: CapturedRoom, error: (Error)?) {
        //handle final post processed result
        print(processedResult)
        self.finalResult = processedResult
        exportBtn.isHidden = false
        
        
        
    }
}
