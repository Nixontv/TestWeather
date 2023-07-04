//
//  InformationTableViewCell.swift
//  WeatherTestApp
//
//  Created by Nikita Velichko on 4.07.23.
//

import UIKit

struct InformationTableViewCellViewModel {
    let informationLabelString: String?
}

class InformationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var informationLabel: UILabel!
    
    private var weatherModel: WeatherModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(model: WeatherModel) {
        self.weatherModel = model
    }
    
    func configureTableViewCellViewModelFor(_ index: Int) -> InformationTableViewCellViewModel {
        var informationLabelString: String?
        if let weatherMode = weatherModel {
            informationLabelString = "Today: \(weatherMode.current.weather[0].descriptionWeather.firstCapitalized). The hight will be \(String(format: "%.f", weatherMode.daily[0].temp.night))°. "
        }
        return InformationTableViewCellViewModel(informationLabelString: informationLabelString)
    }
    
    func setupCell(_ viewModel: InformationTableViewCellViewModel) {
        informationLabel.text = viewModel.informationLabelString
    }
    
}
