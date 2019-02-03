//
//  CustomCell.swift
//  MeteoParis
//
//  Created by Ronan Guyomard on 28/01/2019.
//  Copyright © 2019 Ronan Guyomard. All rights reserved.
//

import Foundation
import UIKit

// Custom cell for weather displaying
class CustomCell: UITableViewCell {
    var weatherIcon : UIImage?
    var date : Date?
    var main : String?
    var weatherDescription : String?
    var temperature : Double?
    
    var dateView : UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 19, weight: UIFont.Weight.thin)
        textView.isScrollEnabled = false
        return textView
    }()
    
    var weatherIconView : UIImageView = {
        var weatherIconView = UIImageView()
        weatherIconView.translatesAutoresizingMaskIntoConstraints = false
        return weatherIconView
    }()
    
    var mainTextView : UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.boldSystemFont(ofSize: 17)
        textView.isScrollEnabled = false
        return textView
    }()
    
    var weatherDescriptionView : UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        return textView
    }()
    
    var temperatureView : UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(dateView)
        self.addSubview(weatherIconView)
        self.addSubview(mainTextView)
        
        // Declare constraints
        weatherIconView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        weatherIconView.centerYAnchor.constraint(equalTo:self.centerYAnchor).isActive = true
        weatherIconView.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        weatherIconView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        dateView.leftAnchor.constraint(equalTo: weatherIconView.rightAnchor).isActive = true
        dateView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        dateView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        dateView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5).isActive = true
        
        mainTextView.leftAnchor.constraint(equalTo: weatherIconView.rightAnchor).isActive = true
        mainTextView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        mainTextView.topAnchor.constraint(equalTo: self.dateView.bottomAnchor).isActive = true
        mainTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Date line
        if let date = date {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE dd MMMM HH:mm" // Date format for displaying
            formatter.locale = Locale(identifier: "fr_FR")
            dateView.text = formatter.string(from: date)
        }
        // Weather icon
        if let weatherIcon = weatherIcon{
            weatherIconView.image = weatherIcon
        }
        
        // Info line
        if let main = main {
            mainTextView.text = main.uppercased() + "  " + String(format:"%.2f", self.temperature as! Double) + "°C"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
