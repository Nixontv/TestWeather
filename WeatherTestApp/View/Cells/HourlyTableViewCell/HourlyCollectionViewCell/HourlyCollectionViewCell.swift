//
//  HourlyCollectionViewCell.swift
//  WeatherTestApp
//
//  Created by Nikita Velichko on 4.07.23.
//

import UIKit

struct HourlyCollectionViewCellViewModel {
    let tempLabelString: String?
    let timeLabelString: String?
    let humidityLabelString: String?
    let iconImage: UIImage?
    let urlString: String?
}

class HourlyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var humidityLavel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setupCell(_ viewModel: HourlyCollectionViewCellViewModel) {
        if viewModel.timeLabelString == "Now" {
            timeLabel.text = "Now"
            timeLabel.font = UIFont.boldSystemFont(ofSize: 17)
            tempLabel.text = viewModel.tempLabelString
            tempLabel.font = UIFont.boldSystemFont(ofSize: 17)
        } else {
            timeLabel.text = viewModel.timeLabelString
            tempLabel.text = viewModel.tempLabelString
        }
        
        if viewModel.iconImage != nil {
            weatherIcon.image = viewModel.iconImage
        } else {
            weatherIcon.downloaded(from: viewModel.urlString ?? "")
        }
        
        humidityLavel.text = viewModel.humidityLabelString
    }
    
}
