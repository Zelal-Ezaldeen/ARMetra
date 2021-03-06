//
//  CurrentMoveVC.swift
//  Metra
//
//  Created by Zelal-Ezaldeen on 1/13/19.
//  Copyright © 2019 Metra Company. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class CurrentMoveVC: LocationVC {
    
    //Outlets
    @IBOutlet weak var swipBGImgView: UIImageView!
    @IBOutlet weak var sliderImgView: UIImageView!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var paceLbl: UILabel!
    
    @IBOutlet weak var viewError: UIView!
    @IBOutlet weak var pauseBtn: UIButton!
    
    //Variables
    fileprivate var startLocation: CLLocation!
    fileprivate var lastLocation: CLLocation!
    fileprivate var timer = Timer()
    fileprivate var coordinateLocations = List<Location>()
    fileprivate var runDistance = 0.0
    fileprivate var counter = 0
    fileprivate var pace = 0
    
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
        pauseBtn.setImage(#imageLiteral(resourceName: "pauseButton"), for: .normal) //pauseButton
        
        
    }
    
    func endRun() {
        manager?.stopUpdatingLocation()
        //Add our object to Realm
        Run.addRunToRealm(pace: pace, distance: runDistance, duration: counter, locations: coordinateLocations)
    }
    
    func pauseRun() {
        startLocation = nil
        lastLocation = nil
        timer.invalidate()
        manager?.stopUpdatingLocation()
         pauseBtn.setImage(#imageLiteral(resourceName: "resumeButton"), for: .normal)//setImage(resumeButton, for: .normal)
    }
    func startTimer() {
        durationLbl.text = counter.formatTimeDurationToString()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter() {
        counter += 1
        durationLbl.text = counter.formatTimeDurationToString()
    
    }
    
    func calculatePace(time seconds: Int, miles: Double) -> String {
        if miles == 0 {
            viewError.isHidden = false
        } else {
            pace = Int(Double(seconds) / miles)
            
        }
       return pace.formatTimeDurationToString()
    }
    @IBAction func pauseBtnPressed(_ sender: Any) {
        if timer.isValid {
             pauseRun()
        } else {
            startRun()
        }
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
                    endRun()
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
            print("First")
            print(startLocation)
        } else if let location = locations.last {
            print("DE")
            print(location)
            runDistance += lastLocation.distance(from: location)
            let newLocation = Location(latitude: Double(lastLocation.coordinate.latitude), longitude: Double(lastLocation.coordinate.longitude))
            coordinateLocations.insert(newLocation, at: 0)
            distanceLbl.text = "\(runDistance.metersToMiles(places: 2))"
            if counter > 0 && runDistance > 0 {
                paceLbl.text = calculatePace(time: counter, miles: runDistance.metersToMiles(places: 2))
            }
        }
        lastLocation = locations.last
    }
}
