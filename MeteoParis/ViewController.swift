//
//  ViewController.swift
//  MeteoParis
//
//  Created by Ronan Guyomard on 28/01/2019.
//  Copyright © 2019 Ronan Guyomard. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

// Data structure for Custom Cells
struct CellData {
    let weatherIcon : UIImage?
    let date : Date?
    let main : String?
    let weatherDescription : String?
    let temperature : Double?
}

class TableViewController: UITableViewController {
    
    
    @IBOutlet weak var meteoLabel: UILabel!
    var weatherIcons: [String:UIImage] = [String:UIImage]()
    var data = [CellData]()
    var city = String();

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Pre download weather icons
        self.preloadImages()
        
        // Call the api
        self.callOpenWeatherMap()
        
        // Use custom cells
        self.tableView.register(CustomCell.self, forCellReuseIdentifier: "custom")
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 400
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "custom") as! CustomCell
        cell.weatherIcon = data[indexPath.row].weatherIcon
        cell.date = data[indexPath.row].date
        cell.main = data[indexPath.row].main
        cell.temperature = data[indexPath.row].temperature
        cell.weatherDescription = data[indexPath.row].weatherDescription
        
        cell.layoutSubviews()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func preloadImages()
    {
        let imagesRootUrl = "http://openweathermap.org/img/w/"
        
        let imagesUrl : [String] = ["01d","02d","03d","04d","09d","10d","11d","13d","50d",
             "01n","02n","03n","04n","09n","10n","11n","13n","50n"]
        
        // For each image from the array
        for imageUrl in imagesUrl
        {
            let url = imagesRootUrl + imageUrl + ".png"
            
            // Download request
            Alamofire.request(url, method: .get).responseImage { response in
                if let image = response.result.value{
                    print(imageUrl)
                    self.weatherIcons[imageUrl] = image as UIImage
                    if(self.weatherIcons.count == imagesUrl.count)
                    {
                        print("Icons download complete!")
                    }
                } else {
                    print(response)
                }
            }
        }
        
        
        
    }
    
    func callOpenWeatherMap()
    {
        let url = "https://api.openweathermap.org/data/2.5/forecast?id=6455259&appid=f09eb16aaabcb9a89f9a842d791e1863"
        
        // GET request
        Alamofire.request(url).responseJSON { response in
            // Response serialization result
            
            // Data from Json
            var weatherData : [[String:Any]]
            
            if let json = response.result.value {
               
                let jsonDictionary = json as! [String:Any]
                
                // Page title
                self.city = (jsonDictionary["city"] as! [String:Any])["name"] as! String
                self.meteoLabel.text = "  Météo " + self.city
                
                // Get Day list from Json Dictionary
                weatherData = jsonDictionary["list"] as! [[String:Any]]
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Parse date according to Json response
                
                // For each day in weatherData
                for weatherInstantData in weatherData
                {
                    // Get all needed data from Json
                    let weather = weatherInstantData["weather"] as! [[String:Any]]
                    let mainInformation = weatherInstantData["main"] as! [String:Any]
                    let dateTime = weatherInstantData["dt_txt"] as! String
                    guard let date = dateFormatter.date(from: dateTime) else {
                        fatalError("ERROR: Date conversion failed due to mismatched format.")
                    }
                    let mainText = weather[0]["main"] as! String
                    let icon = weather[0]["icon"] as! String
                    let weatherIcon = self.weatherIcons[icon] as UIImage?
                    let descriptionText = weather[0]["description"] as! String
                    let temperature = mainInformation["temp"] as! Double
                    let temperatureCelsius = temperature - 273.15
                    
                    // Create a new CellData and add it to the collection
                    self.data.append(CellData(weatherIcon: weatherIcon, date: date, main: mainText, weatherDescription: descriptionText, temperature: temperatureCelsius))
                }
                
                self.tableView.reloadData()
                 print("JSON: \(json)") // serialized json response
            }
            
        }
    }
}

