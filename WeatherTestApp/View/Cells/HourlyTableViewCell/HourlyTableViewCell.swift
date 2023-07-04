//
//  HourlyTableViewCell.swift
//  WeatherTestApp
//
//  Created by Nikita Velichko on 4.07.23.
//

import UIKit

class HourlyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    
    private var weatherModel: WeatherModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    func configure(model: WeatherModel) {
        self.weatherModel = model
        DispatchQueue.main.async { [weak self] in
            self?.hourlyCollectionView.reloadData()
        }
    }
    
    private func setupCollectionView() {
        hourlyCollectionView.register(UINib(nibName: "HourlyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HourlyCollectionViewCell")
        hourlyCollectionView.dataSource = self
        hourlyCollectionView.delegate = self
        hourlyCollectionView.allowsSelection = false
        hourlyCollectionView.showsVerticalScrollIndicator = false
        hourlyCollectionView.contentInsetAdjustmentBehavior = .never
    }
    
    private func configureCollectionCellViewModelFor(_ index: Int) -> HourlyCollectionViewCellViewModel  {
        var tempLabelString: String?
        var timeLabelString: String?
        var humidityLabelString: String?
        var iconImage: UIImage?
        var urlStringForImage: String?
        
        if let weatherModel = weatherModel {
            let hourlyModel = weatherModel.hourly[index]
            let hourForDate = Date(timeIntervalSince1970: Double(hourlyModel.dt)).getHourForDate()
            let nextHourForDate = Date(timeIntervalSince1970: Double(weatherModel.hourly[index + 1].dt)).getTimeForDate()
            let timeForDate = Date(timeIntervalSince1970: Double(hourlyModel.dt)).getTimeForDate()
            let sunset = Date(timeIntervalSince1970: Double(weatherModel.current.sunset)).getTimeForDate()
            let sunrise = Date(timeIntervalSince1970: Double(weatherModel.current.sunrise)).getTimeForDate()
            urlStringForImage = "http://openweathermap.org/img/wn/\(hourlyModel.weather[0].icon)@2x.png"
            
            if index == 0 {
                timeLabelString = "Now"
                iconImage = nil
                tempLabelString = String(format: "%.f", weatherModel.hourly[index].temp) + "°"
            } else {
                if sunset >= timeForDate && sunset < nextHourForDate {
                    tempLabelString = "Sunset"
                    iconImage = #imageLiteral(resourceName: "sunset")
                    timeLabelString = sunset
                } else if sunrise >= timeForDate && sunrise < nextHourForDate {
                    tempLabelString = "Sunrise"
                    iconImage = #imageLiteral(resourceName: "sunrise")
                    timeLabelString = sunrise
                } else {
                    iconImage = nil
                    tempLabelString = String(format: "%.f", weatherModel.hourly[index].temp) + "°"
                    timeLabelString = hourForDate
                }
            }
            if hourlyModel.humidity >= 30 {
                humidityLabelString = String(hourlyModel.humidity) + " %"
            } else {
                humidityLabelString = ""
            }
        }
        return HourlyCollectionViewCellViewModel(tempLabelString: tempLabelString,
                                                 timeLabelString: timeLabelString,
                                                 humidityLabelString: humidityLabelString,
                                                 iconImage: iconImage,
                                                 urlString: urlStringForImage)
    }
}

extension HourlyTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource {
    
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCollectionViewCell", for: indexPath as IndexPath)
        guard let hourlyCell = cell as? HourlyCollectionViewCell else { return cell }
        
        let viewModel = configureCollectionCellViewModelFor(indexPath.row)
        hourlyCell.setupCell(viewModel)
        return hourlyCell
        
    }
}
