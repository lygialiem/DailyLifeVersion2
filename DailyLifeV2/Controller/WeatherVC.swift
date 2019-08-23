//
//  WeatherVC.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/20/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherVC: UIViewController {
  
  @IBOutlet var weatherTableView: UITableView!
  var forecastData: ForecastApi?
  var hourlyData: HourlyDarkSkyApi?
  
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.navigationBar.isHidden = true 
    LocationService.instance.getCountryForecastApi(nameOfCountry: "Ho Chi Minh", completion: { (forecastData) in
      self.forecastData = forecastData
      DispatchQueue.main.async {
        self.weatherTableView.dataSource = self
        self.weatherTableView.reloadData()
      }
      
    }) { (hourlyData) in
      self.hourlyData = hourlyData
      DispatchQueue.main.async {
        self.weatherTableView.dataSource = self
        self.weatherTableView.reloadData()
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTableView()
    
    self.navigationController?.navigationBar.isHidden = true
    
  }
  
  
  override var preferredStatusBarStyle: UIStatusBarStyle{
    return .lightContent
  }
  
  func  setupTableView(){
    
    weatherTableView.delegate = self
    weatherTableView.dataSource = nil
  }
  
}

extension WeatherVC: UITableViewDelegate, UITableViewDataSource{
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 6
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section{
    case 0:
      return 1
    case 1:
      return 1
    case 2:
      return self.forecastData?.forecast?.forecastday?.count ?? 0
    case 3:
      return 1
    case 4:
      return 6
    case 5:
      return 0
    default:
      return Int()
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section{
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell0", for: indexPath) as! WeatherHeader0
      cell.configureCell(forecast: self.forecastData)
      return cell
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! ForecastHourTableViewCell
      cell.hourlyData = self.hourlyData
      cell.forecastHourlyCollectionView.dataSource = cell
      DispatchQueue.main.async {
        cell.forecastHourlyCollectionView.reloadData()
      }
      return cell
    case 2:
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! WeatheTableViewRow2
      cell.configureCell(forecastDay: self.forecastData?.forecast?.forecastday?[indexPath.row])
      return cell
    case 3:
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! WeatherRow3
      cell.summary.text = "Today: \(forecastData?.current?.condition?.text ?? "") currently. The high temperature will be \((forecastData?.forecast?.forecastday?[0]?.day?.maxtemp_c ?? 0).roundInt())ºC. Cloudy tonight with a low temperature of \(String(describing: (forecastData?.forecast?.forecastday?[0]?.day?.mintemp_c ?? 0).roundInt()))ºc"
      return cell
      
    case 4:
      switch indexPath.row{
      case 0:
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell4", for: indexPath) as! DetailWeatherCell
        cell.sunrise.text = forecastData?.forecast?.forecastday?[0]?.astro?.sunrise ?? ""
        cell.sunset.text = forecastData?.forecast?.forecastday?[0]?.astro?.sunset ?? ""
        return cell
      case 1:
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell5", for: indexPath) as! DetailWeatherCell
        cell.moonrise.text = forecastData?.forecast?.forecastday?[0]?.astro?.moonrise ?? ""
        cell.moonset.text = forecastData?.forecast?.forecastday?[0]?.astro?.moonset ?? ""
        return cell
      case 2:
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell6", for: indexPath) as! DetailWeatherCell
        cell.precipMm.text = "\(forecastData?.current?.precip_mm ?? 0) mm/h"
        cell.humidity.text = "\(Int(forecastData?.current?.humidity ?? 0))%"
        return cell
      case 3:
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell7", for: indexPath) as! DetailWeatherCell
        cell.wind.text = "\(forecastData?.current?.wind_dir ?? "") \(forecastData?.current?.wind_kph ?? 0) km/h"
        cell.feelsLike.text = "\((forecastData?.current?.feelslike_c ?? 0).roundInt())ºC"
        return cell
      case 4:
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell8", for: indexPath) as! DetailWeatherCell
        cell.gustKmPH.text = "\(forecastData?.current?.gust_kph ?? 0) km/h"
        cell.pressure.text = "\(forecastData?.current?.pressure_mb ?? 0) hPa"
        return cell
      case 5:
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell9", for: indexPath) as! DetailWeatherCell
        cell.visibility.text = "\(forecastData?.current?.vis_km ?? 0) km"
        cell.UVIndex.text = "\(Int(forecastData?.current?.uv ?? 0))"
        return cell
        
      default:
        return UITableViewCell()
      }
    default:
      return UITableViewCell()
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    switch section {
    case 0:
      let header = tableView.dequeueReusableCell(withIdentifier: "header0")
      return header
    case 1:
      let header = tableView.dequeueReusableCell(withIdentifier: "header1") as! WeatherHeader1_2
      header.hourlyTitleHeader.text = "Hourly"
      return header
    case 2:
      let header = tableView.dequeueReusableCell(withIdentifier: "header2") as! WeatherHeader1_2
      header.dailyTitleHeader.text = "Daily"
      return header
    case 3:
      let header = tableView.dequeueReusableCell(withIdentifier: "header3") as! WeatherHeader1_2
      header.summaryTitleHeader.text = "Summary"
      return header
    case 4:
      let header = tableView.dequeueReusableCell(withIdentifier: "header4") as!
      WeatherHeader1_2
      header.detailTitleHeader.text = "Detail"
      return header
      
    case 5:
      let header = tableView.dequeueReusableCell(withIdentifier: "header5") as! WeatherHeader1_2
      header.delegate = self
      return header
    default:
      return UIView()
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      return 150
    case 1:
      return 100
    case 2:
      return 50
    case 3:
      return UITableView.automaticDimension
    case 4:
      return 60
    case 5:
      return 0
    default:
      return CGFloat()
    }
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch section {
    case 0:
      return 0
    case 5:
      return 40
    default:
      return 20
    }
  }
  
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    view.tintColor = .clear
  }
}

extension WeatherVC: moveToWebVC{
  func moveToWebVCFromWeatherVC(url: String) {
    let webVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewVC") as! WebViewController 
    webVC.urlOfContent = url
    self.navigationController?.navigationBar.isHidden = false
    self.navigationController?.pushViewController(webVC, animated: true)
  }
}
