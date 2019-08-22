//
//  MainVC.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 6/25/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import CoreLocation

class MainVC: ButtonBarPagerTabStripViewController {
  
  @IBOutlet var temperatureButton: UIButton!
  @IBOutlet var visualEffectView: UIVisualEffectView!
  @IBOutlet var weatherContainer: UIView!
  @IBOutlet var weatherContainerConstraint: NSLayoutConstraint!
  @IBOutlet var snipper: UIActivityIndicatorView!
  @IBOutlet var btnBarView: UIView!
  
  var isWeatherOpen = false
  var pageVCArray = [PageVC]()
  let appDelegate = UIApplication.shared.delegate as? AppDelegate
  var effect: UIVisualEffect!
  
  var newestLocaton: ((CLLocationCoordinate2D?) -> Void)?
  var statusUpdated: ((CLAuthorizationStatus?) -> Void)?
  var dataResponseWeather: ((WeatherInfo)-> Void)?
  let manager = CLLocationManager()
  var status: CLAuthorizationStatus{
    return CLLocationManager.authorizationStatus()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    NotificationCenter.default.addObserver(self, selector: #selector(moveToTopic(notification:)), name: NSNotification.Name("MoveToTopic"), object: nil)
    
    setUpCoreLocation()
  }
  
  override func viewDidLoad() {
    configureButtonBar()
    super.viewDidLoad()
    
    snipper.hidesWhenStopped = true
    snipper.startAnimating()
    
    effect = visualEffectView.effect
    visualEffectView.isHidden = true
    visualEffectView.effect = nil
    
    NotificationCenter.default.addObserver(self, selector: #selector(handleAreaBar(notificaton:)), name: NSNotification.Name("HandleAreaBar"), object: nil)
    
    btnBarView.clipsToBounds = true
    btnBarView.layer.cornerRadius = 12
    btnBarView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    btnBarView.layer.borderWidth = 2
    btnBarView.frame(forAlignmentRect: CGRect(x: 250, y: 30, width: 300, height: 30))
    
    temperatureButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
    temperatureButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
    
  }
  
  @objc func handleAreaBar(notificaton: Notification){
    let gesture = notificaton.userInfo?["data"] as? UIPanGestureRecognizer
    let translation = gesture?.translation(in: self.view).y
    guard let translatedIndex = translation else {return}
    
    if translatedIndex >= CGFloat(0){
      self.weatherContainer.frame.origin.y = self.view.frame.height -  self.weatherContainer.frame.height + translatedIndex
    }
    
    UIView.animate(withDuration: 0.3) {
      if gesture?.state == .ended{
        if self.weatherContainer.frame.origin.y <= 300{
          self.weatherContainer.frame.origin.y = self.view.frame.height - self.weatherContainer.frame.height
          self.isWeatherOpen = true
          
        } else {
          self.weatherContainer.frame.origin.y = self.view.frame.height
          self.isWeatherOpen = false
          self.animateVisualEffectOUT()
        }
      }
    }
  }
  
  @objc func moveToTopic(notification: Notification){
    let indexPath = notification.userInfo?["data"] as! IndexPath
    self.moveToViewController(at: indexPath.row, animated: false)
    
  }
  
  func setUpCoreLocation(){
    print("WILLAPEAR")
    if CLLocationManager.locationServicesEnabled(){
      manager.delegate = self
      manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
      manager.startUpdatingLocation()
      
      self.newestLocaton = {(location) in
        guard let latitude = location?.latitude, let longitude = location?.longitude else {return}
        LocationService.instance.getWeatherApi(latitude: latitude, longitude: longitude) { (dataResponse) in
          self.dataResponseWeather?(dataResponse)
          guard let temper = dataResponse.currently?.temperature else {
            return
          }
          DispatchQueue.main.async {
            self.temperatureButton.setTitle("\(round(temper * 10) / 10)°C", for: .normal)
            self.navigationController?.navigationBar.layoutIfNeeded()
          }
          self.manager.stopUpdatingLocation()
        }
      }
    }
  }
  
  func getApiWeather(){
    
  }
  
  func configureButtonBar() {
    settings.style.selectedBarHeight = 4
    settings.style.selectedBarBackgroundColor = #colorLiteral(red: 0, green: 0.9222823977, blue: 0.7017730474, alpha: 1)
    settings.style.buttonBarBackgroundColor = #colorLiteral(red: 0.1568458378, green: 0.1568738818, blue: 0.1568369865, alpha: 1)
    settings.style.buttonBarItemBackgroundColor = #colorLiteral(red: 0.1568458378, green: 0.1568738818, blue: 0.1568369865, alpha: 1)
    settings.style.buttonBarMinimumInteritemSpacing = 0
    settings.style.buttonBarItemFont = UIFont(name: "Helvetica Neue", size: 15)!
    settings.style.buttonBarItemTitleColor = .red
    settings.style.buttonBarMinimumLineSpacing = 0
    settings.style.buttonBarItemsShouldFillAvailableWidth = true
    settings.style.buttonBarLeftContentInset = 0
    settings.style.buttonBarRightContentInset = 0
    settings.style.buttonBarHeight = 30
    settings.style.selectedBarVerticalAlignment = .bottom
    
    // Changing item text color on swipe
    changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
      guard changeCurrentIndex == true else { return }
      oldCell?.label.textColor = .white
      newCell?.label.textColor = .white
    }
  }
  
  override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
    for i in 0..<ApiServices.instance.TOPIC_NEWSAPI.count{
      let pageVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageControllerID") as! PageVC
      pageVC.menuBarTitle = ApiServices.instance.TOPIC_NEWSAPI[i]
      DispatchQueue.main.async {
        ApiServices.instance.getMoreNewsApi(topic: ApiServices.instance.TOPIC_NEWSAPI[i], page: 3,numberOfArticles: 10) { (dataApi) in
          pageVC.articlesOfConcern = dataApi.articles
        }
      }
      
      ApiServices.instance.getMoreNewsApi(topic: ApiServices.instance.TOPIC_NEWSAPI[i], page: 1, numberOfArticles: 20) {(dataApi) in
        pageVC.articles = dataApi.articles
        if i == 0 {
          DispatchQueue.main.async {
            pageVC.newsFeedCV.reloadData()
            self.snipper.stopAnimating()
          }
        }
      }
      pageVCArray.append(pageVC)
    }
    return pageVCArray
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let weatherContainer = segue.destination as? WeatherContainer{
      self.dataResponseWeather = {(dataResponseWeather) in
        
        guard let latitude = dataResponseWeather.latitude,
          let longitude = dataResponseWeather.longitude,
          let time = dataResponseWeather.currently?.time,
          let summary = dataResponseWeather.currently?.summary,
          let temperature = dataResponseWeather.currently?.temperature,
          let apparentTemperature = dataResponseWeather.currently?.apparentTemperature,
          let humidity = dataResponseWeather.currently?.humidity,
          let pressure = dataResponseWeather.currently?.pressure,
          let stormDis = dataResponseWeather.currently?.nearestStormDistance,
          let precipIntensity = dataResponseWeather.currently?.precipIntensity,
          let precipType = dataResponseWeather.currently?.precipType,
          let precipProbability = dataResponseWeather.currently?.precipProbability,
          let dewPoint = dataResponseWeather.currently?.dewPoint,
          let winBearing = dataResponseWeather.currently?.windBearing,
          let ozone = dataResponseWeather.currently?.ozone,
          let cloudCover = dataResponseWeather.currently?.cloudCover,
          let visibility = dataResponseWeather.currently?.visibility,
          let uvIndex = dataResponseWeather.currently?.uvIndex,
          let icon = dataResponseWeather.currently?.icon
          else { return }
        
        
        DispatchQueue.main.async {
          
          weatherContainer.detailWeatherTableView.dataSource = weatherContainer
          weatherContainer.latitude = latitude
          weatherContainer.longitude = longitude
          weatherContainer.time = time
          weatherContainer.summary = summary
          weatherContainer.temperature = temperature
          weatherContainer.apparentTemperature = apparentTemperature
          weatherContainer.humidity = humidity
          weatherContainer.pressure = pressure
          weatherContainer.nearestStormDistance = stormDis
          weatherContainer.precipIntensity = precipIntensity
          weatherContainer.precipType = precipType
          weatherContainer.precipProbability = precipProbability
          weatherContainer.dewPoint = dewPoint
          weatherContainer.windBearing = winBearing
          weatherContainer.ozone = ozone
          weatherContainer.cloudCover = cloudCover
          weatherContainer.visibility = visibility
          weatherContainer.uvIndex = uvIndex
          weatherContainer.icon = icon
          weatherContainer.detailWeatherTableView.reloadData()
        }
      }
    }
  }
  
  @IBAction func openMenuPressed(_ sender: Any) {
    NotificationCenter.default.post(name: NSNotification.Name("OpenOrCloseSideMenu"), object: nil)
  }
  
  @IBAction func weatherButtonByPressed(_ sender: Any) {
    self.visualEffectView.isHidden = false
    UIView.animate(withDuration: 0.3) {
      if  self.isWeatherOpen{
        self.weatherContainer.frame.origin.y = self.view.frame.height
        self.isWeatherOpen = false
        self.animateVisualEffectOUT()
      } else {
        self.weatherContainer.frame.origin.y = self.view.frame.height -  self.weatherContainer.frame.height
        self.isWeatherOpen = true
        self.animateVisualEffectIN()
      }
    }
  }
  
  func animateVisualEffectOUT(){
    self.visualEffectView.effect = nil
    self.visualEffectView.isHidden = true
  }
  
  func animateVisualEffectIN(){
    self.visualEffectView.effect = self.effect
    self.visualEffectView.isHidden = false
  }
}


extension MainVC: CLLocationManagerDelegate{
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.sorted(by: {$0.timestamp > $1.timestamp}).first else {
      self.newestLocaton?(nil)
      return
    }
    self.newestLocaton?(location.coordinate)
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    debugPrint("Fail to get Location")
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    print("Location Status:",status)
    self.statusUpdated?(status)
  }
}
