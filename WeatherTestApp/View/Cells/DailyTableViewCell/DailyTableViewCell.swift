//
//  DailyTableViewCell.swift
//  WeatherTestApp
//
//  Created by Nikita Velichko on 4.07.23.
//

import UIKit

struct DailyTableViewCellViewModel {
    let dayLabelString: String?
    let highTempLabelString: String?
    let lowTempLabelString: String?
    let humidityLabelString: String?
    let iconImage: UIImage?
    let urlString: String?
    
}

class DailyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    
    private var weatherModel: WeatherModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
    }
    
    func configure(model: WeatherModel) {
        self.weatherModel = model
    }
    
    func configureTableViewCellViewModelFor(_ index: Int) -> DailyTableViewCellViewModel {
        var dayLabelString: String?
        var highTempLabelString: String?
        var lowTempLabelString: String?
        var humidityLabelString: String?
        let iconImage = UIImage()
        var urlString: String?
        
        if let weatherModel =  weatherModel {
            let dailyModel = weatherModel.daily[index + 1]
            dayLabelString = Date(timeIntervalSince1970: Double(dailyModel.dt)).getDayForDate()
            highTempLabelString = String(format: "%.f", dailyModel.temp.max)
            lowTempLabelString = String(format: "%.f", dailyModel.temp.min)
            urlString = "http://openweathermap.org/img/wn/\(dailyModel.weather[0].icon)@2x.png"
            iconImageView.downloaded(from: urlString ?? "")
            if dailyModel.humidity >= 30 {
                humidityLabelString = String(dailyModel.humidity) + " %"
            } else {
                humidityLabelString = ""
            }
        }
        return DailyTableViewCellViewModel(dayLabelString: dayLabelString,
                                           highTempLabelString: highTempLabelString,
                                           lowTempLabelString: lowTempLabelString,
                                           humidityLabelString: humidityLabelString,
                                           iconImage: iconImage,
                                           urlString: urlString)
    }
    
    func setupCell(_ viewModel: DailyTableViewCellViewModel) {
        dayLabel.text = viewModel.dayLabelString
        highTempLabel.text = viewModel.highTempLabelString
        lowTempLabel.text = viewModel.lowTempLabelString
        humidityLabel.text = viewModel.humidityLabelString
        iconImageView.image = viewModel.iconImage
    }
}
