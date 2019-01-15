//
//  CurrentMoveVC.swift
//  Metra
//
//  Created by Zelal-Ezaldeen on 1/13/19.
//  Copyright © 2019 Metra Company. All rights reserved.
//

import UIKit
import MapKit

class CurrentMoveVC: LocationVC {
    
    //Outlets
    @IBOutlet weak var swipBGImgView: UIImageView!
    @IBOutlet weak var sliderImgView: UIImageView!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var paceLbl: UILabel!
    @IBOutlet weak var pauseBtn: NSLayoutConstraint!
    
    //Variables
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var timer = Timer()
    
    var runDistance = 0.0
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeGuesture = UIPanGestureRecognizer(target: self, action: #selector(endRunSwiped(sender:)))
        sliderImgView.addGestureRecognizer(swipeGuesture)
        sliderImgView.isUserInteractionEnabled = true
        swipeGuesture.delegate = self as? UIGestureRecognizerDelegate

     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        manager?.distanceFilter = 10
        startRun()
    }
    
    func startRun() {
        manager?.startUpdatingLocation()
        startTimer()
    }
    
    func endRun() {
        manager?.stopUpdatingLocation()
    }
    
    func startTimer() {
        durationLbl.text = counter.formatTimeDurationToString()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter() {
        counter += 1
        durationLbl.text = counter.formatTimeDurationToString()
    
    }
    @IBAction func pauseBtnPressed(_ sender: Any) {
    }
    @objc func endRunSwiped(sender: UIPanGestureRecognizer) {
        let minAdjust: CGFloat = 80
        let maxAdjust: CGFloat = 130
        if let sliderView = sender.view {
            if sender.state == UIGestureRecognizer.State.began || sender.state == UIGestureRecognizer.State.changed {
               let translation =  sender.translation(in: self.view)
                if sliderView.center.x >= (swipBGImgView.center.x - minAdjust) && sliderView.center.x <= (swipBGImgView.center.x + maxAdjust) {
                    sliderView.center.x = sliderView.center.x + translation.x
                } else if sliderView.center.x >= (swipBGImgView.center.x + maxAdjust) {
                    sliderView.center.x = swipBGImgView.center.x + maxAdjust
                    //End Move here
                    dismiss(animated: true, completion: nil)
                } else {
                    sliderView.center.x = swipBGImgView.center.x - minAdjust
                }
                sender.setTranslation(CGPoint.zero, in: self.view)
            } else if sender.state == UIGestureRecognizer.State.ended {
                UIView.animate(withDuration: 0.1, animations: {
                    sliderView.center.x = self.swipBGImgView.center.x - minAdjust
                })
            }
        }
    }
}

extension CurrentMoveVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            checkLocationAuthStatus()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if startLocation == nil {
            startLocation = locations.first
        } else if let location = locations.last {
            runDistance += lastLocation.distance(from: location)
            distanceLbl.text = "\(runDistance.metersToMiles(places: 2))"
        }
        lastLocation = locations.last
    }
}
