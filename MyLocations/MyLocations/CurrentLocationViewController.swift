//
//  ViewController.swift
//  MyLocations
//
//  Created by mittwoch on 2024/11/15.
//

import UIKit
import CoreLocation

class CurrentLocationViewController: UIViewController,CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var location: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateLabels()
    }
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var getButton: UIButton!
    
    // MARK: - Actions
    @IBAction func getLocation() {
        let authStatus = locationManager.authorizationStatus
        // notDetermined 是没有请求过获取位置信息的意思
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        //请求位置被拒绝或者限制 给出一个弹窗
        if authStatus == .denied || authStatus == .restricted {
            showLocationServicesDeniedAlert()
            return
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
    }
    
    //MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print("didUpdateLocations \(newLocation)")
        location = newLocation    // Add this
        updateLabels()
    }
    
    //MARK: - Helper Methods
    func showLocationServicesDeniedAlert(){
        let alert = UIAlertController(title: "Location Services Disable", message: "Please enable location services for this app in Settings.", preferredStyle: .alert )
        let okAction = UIAlertAction(title: "Ok", style: .default,handler: nil)
        alert.addAction(okAction)
        present(alert,animated: true,completion: nil)
    }
    
    //MARK: - func
    func updateLabels(){
        if let location = location {
            latitudeLabel.text = String(format:"%.8f", location.coordinate.latitude)
            longitudeLabel.text = String(format:"%.8f", location.coordinate.longitude)
            tagButton.isHidden = false
            messageLabel.text = ""
        } else {
            latitudeLabel.text = ""
            longitudeLabel.text = ""
            addressLabel.text = ""
            tagButton.isHidden = true
            messageLabel.text = "Tap 'Get My Location' to Start"
        }
    }
}
