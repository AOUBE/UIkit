//
//  ViewController.swift
//  MyLocations
//
//  Created by Mittwoch on 2023/12/31.
//

import UIKit
// CoreLocation 核心位置框架
import CoreLocation
//CLLocationManagerDelegate 协议
class CurrentLocationViewController: UIViewController,CLLocationManagerDelegate {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var getButton: UIButton!
    //CLLocationManager 对象提供gps坐标 startUpdatingLocation()：开始接受坐标。
    let locationManager = CLLocationManager()
    //location存储了具体的位置信息
    var location: CLLocation?
    var updatingLocation = false
    var lastLocationError: Error?
    
    
    //反向地址编码 CLGeocoder:是将执行地理编码的对象。CLPlacemark：包含地址结果的对象。peoformingReverseGeocoding：设置为执行地理编码操作的时间。lastGeocodingError：错误
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var performingReverseGeocoding = false
    var lastGeocodingError: Error?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    @IBAction func getLocation(){
        // 在这里检查 授权状态 .notDetermined：意味着此应用程序尚未请求权限 .denied：拒绝。.restricted：限制
        let authStatus = locationManager.authorizationStatus
        if authStatus == .denied || authStatus == .restricted {
            showLocationServicesDeniedAlert()
            return
        }
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        if updatingLocation {
            stopLocationManager()
        } else {
            location=nil
            lastLocationError = nil
            startLocationManager()
        }
        updateLabels()
    }
    
    // MARK: - CLLocationManagerDelegate didFailWithError（报错）和didUpdateLocations（修改定位） 是 CLLocationManager的委托，随着startUpdatingLocation开始运行
    // 一些可能的核心位置错误：1、CLError.locationUnknown位置目前未知，但核心位置将继续尝试。2、CLError.denied用户拒绝应用使用定位服务的权限。3、CLError.network出现与网络相关的错误。想要将这些名称重新转化为code整数值，需要使用rawValue。例子：CLError.locationUnknown.rawValue
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError：\(error.localizedDescription)")
        
        // 这里表示当你只是无法获取位置的时候 不会停止 只会继续查找位置
        if (error as NSError).code == CLError.locationUnknown.rawValue{
            return
        }
        lastLocationError = error
        stopLocationManager()
        updateLabels()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print("didUpdateLocations\(newLocation)")
        
        //确定给定位置对象的时间太早（本例子：5秒） 则这是一个缓存结果 认为这些位置太久了 忽略
        if newLocation.timestamp.timeIntervalSinceNow < -5 {
            return
        }
        //确认新读数是否比以前的读书更精确
        if newLocation.horizontalAccuracy < 0 {
            return
        }
        //location为nil的情况下 说明这是第一次获取位置，应该直接继续
        //新位置信息的读数更加精准 locaion是定位信息 注意 这里全局的定位信息是locaion 这个函数内的定位信息是newlocaiton和locations
        if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy {
            lastLocationError = nil
            location = newLocation
        }
        //新定位的精准度优于所需的精准度，停止
        if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy{
            print("*** We're done!")
            stopLocationManager()
        }
        updateLabels()
        
        //反向地理编码
        if !performingReverseGeocoding {
            print("*** Going to geocode")
            performingReverseGeocoding = true
            //reverseGeocodeLocation 闭包 下面的括号{}本身中的东西是闭包
            // {placemarks, error in } 是闭包本身。in前面的项是闭包的
            参数
            geocoder.reverseGeocodeLocation(newLocation) {placemarks, error in
                if let error = error {
                    print("*** Reverse Geocoding error: \(error.localizedDescription)")
                    return
                }
                if let places = placemarks {
                    print("*** Found places: \(places)")
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    func showLocationServicesDeniedAlert(){
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app in Setting", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default,handler: nil)
        alert.addAction(okAction)
        present(alert,animated: true,completion: nil)
    }
    
    func updateLabels(){
        if let location = location {
            latitudeLabel.text = String(
                format: "%.8f", location.coordinate.latitude
            )
            longitudeLabel.text = String(
                format: "%.8f", location.coordinate.longitude
            )
            tagButton.isHidden = false
            messageLabel.text = "Get"
        } else {
            latitudeLabel.text = ""
            longitudeLabel.text = ""
            addressLabel.text = ""
            tagButton.isHidden = true
            //messageLabel.text = "Tap 'Get my Location' to Start"
            let statusMessage: String
            if let error = lastLocationError as NSError? {
                if error.domain == kCLErrorDomain && error.code == CLError.denied.rawValue {
                    statusMessage = "Location Services Disabled"
                } else {
                    statusMessage = "Error Getting Location"
                }
            } else if !CLLocationManager.locationServicesEnabled() {
                statusMessage = "Location Services Disablled"
            } else if updatingLocation{
                statusMessage = "Searching..."
            } else {
                statusMessage = "Tap 'Get My Location' to Start"
            }
            messageLabel.text = statusMessage
            configureGetButton()
        }
    }
    
    func startLocationManager(){
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            updatingLocation = true
        }
    }
    
    func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
        }
    }
    
    func configureGetButton() {
        print("updatingLocation:\(updatingLocation)")
        if updatingLocation {
            getButton.setTitle("stop", for: .normal)
        } else{
            getButton.setTitle("Get My Location", for: .normal)
            
        }
    }
}
