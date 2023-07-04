//
//  DescriptionTableViewCell.swift
//  WeatherTestApp
//
//  Created by Nikita Velichko on 4.07.23.
//

import UIKit

struct DescriptionTableViewCellViewModel {
    let descriptionTextLabelString: String?
    let descriptionValueLabelString: String?
}

class DescriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionTextLabel: UILabel!
    @IBOutlet weak var descriptionValueLabel: UILabel!
    
    private var weatherModel: WeatherModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(model: WeatherModel) {
        self.weatherModel = model
    }
    
    func configureTableViewCellViewModelFor(_ index: Int) -> DescriptionTableViewCellViewModel {
        var descriptionTextLabelString: String?
        var descriptionValueLabelString: String?
        
        if let weatherModel = weatherModel {
            switch index {
            case 0:
                descriptionTextLabelString = descriptionArray[index]
                descriptionValueLabelString = Date(timeIntervalSince1970: Double(weatherModel.current.sunrise)).getTimeForDate()
            case 1:
                descriptionTextLabelString = descriptionArray[index]
                descriptionValueLabelString = Date(timeIntervalSince1970: Double(weatherModel.current.sunset)).getTimeForDate()
            case 2:
                descriptionTextLabelString = descriptionArray[index]
                descriptionValueLabelString = String(weatherModel.current.humidity) + " %"
            case 3:
                descriptionTextLabelString = descriptionArray[index]
                descriptionValueLabelString = String(format: "%.1f", weatherModel.current.windSpeed) + " m/s"
            case 4:
                descriptionTextLabelString = descriptionArray[index]
                descriptionValueLabelString = String(format: "%.f", weatherModel.current.feelsLike) + "°"
            case 5:
                descriptionTextLabelString = descriptionArray[index]
                descriptionValueLabelString = String(format: "%.1f", Double(weatherModel.current.pressure) / 133.332 * 100) + " mm Hg"
            case 6:
                descriptionTextLabelString = descriptionArray[index]
                descriptionValueLabelString = String(format: "%.1f", weatherModel.current.visibility / 1000) + " km"
            case 7:
                descriptionTextLabelString = descriptionArray[index]
                descriptionValueLabelString = String(format: "%.f", weatherModel.current.uvi)
            default:
                print("default value")
            }
            
        }
        return DescriptionTableViewCellViewModel(descriptionTextLabelString: descriptionTextLabelString,
                                                 descriptionValueLabelString: descriptionValueLabelString)
    }
    
    func setupCell(_ viewModel: DescriptionTableViewCellViewModel) {
        descriptionTextLabel.text = viewModel.descriptionTextLabelString
        descriptionValueLabel.text = viewModel.descriptionValueLabelString
    }
}
