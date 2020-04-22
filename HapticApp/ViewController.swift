//
//  ViewController.swift
//  HapticApp
//
//  Created by Amaury A V A Souza on 17/04/20.
//  Copyright © 2020 Amaury A V A Souza. All rights reserved.
//

import UIKit
import CoreHaptics

class ViewController: UIViewController {
    
    @IBOutlet weak var ronronar: UIButton!
    var engine: CHHapticEngine!
    lazy var supportsHaptics: Bool = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.supportsHaptics
    }()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createEngine()
        ronronar.imageView?.contentMode = .scaleAspectFill
        
      
    }

    func createEngine() {
          // Create and configure a haptic engine.
          do {
              engine = try CHHapticEngine()
          } catch let error {
              print("Engine Creation Error: \(error)")
          }
          
          if engine == nil {
              print("Failed to create engine!")
          }
          
          // The stopped handler alerts you of engine stoppage due to external causes.
          engine.stoppedHandler = { reason in
              print("The engine stopped for reason: \(reason.rawValue)")
              switch reason {
              case .audioSessionInterrupt: print("Audio session interrupt")
              case .applicationSuspended: print("Application suspended")
              case .idleTimeout: print("Idle timeout")
              case .systemError: print("System error")
              case .notifyWhenFinished: print("Playback finished")
              @unknown default:
                  print("Unknown error")
              }
          }
        engine.resetHandler = {
                   // Try restarting the engine.
                   print("The engine reset --> Restarting now!")
                   do {
                       try self.engine.start()
                   } catch {
                       print("Failed to restart the engine: \(error)")
                   }
               }
    }
    
    func playHapticsFile(named filename: String) {
        
        // If the device doesn't support Core Haptics, abort.
        if !supportsHaptics {
            return
        }
        
        // Express the path to the AHAP file before attempting to load it.
        guard let path = Bundle.main.path(forResource: filename, ofType: "ahap") else {
            return
        }
        
        do {
            // Start the engine in case it's idle.
            try engine.start()
            
            // Tell the engine to play a pattern.
            try engine.playPattern(from: URL(fileURLWithPath: path))
            
        } catch { // Engine startup errors
            print("An error occured playing \(filename): \(error).")
        }
    }
    
    
    @IBAction func ronronar(_ sender: Any) {
        playHapticsFile(named: "Rumble")

    }
}

