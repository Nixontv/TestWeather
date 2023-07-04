//
//  MainViewController.swift
//  WeatherTestApp
//
//  Created by Nikita Velichko on 4.07.23.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, CAAnimationDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var descriptionNameLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var weatherTableView: UITableView!
    @IBOutlet weak var todayLabel: UILabel!
    
    // MARK: - Properties
    
    private let locationManager = CLLocationManager()
    private let networkService = DataFetcherService()
    private var weatherModel: WeatherModel?
    
    var loadingView = LoadViewController()
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLoadingView()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.updateWeather(notification:)),
                                               name: Notification.Name("UpdateWeather"),
                                               object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        switch Reachability.isConnectedToNetwork() {
        case true:
            setupVC()
        case false:
            loadingView.showError(types: .networkError)
        }
    }
    
    //MARK: - Animations
    
    private func addLoadingView() {
        loadingView = LoadViewController()
        
        view.addSubview(loadingView.view)
        self.loadingView.view.alpha = 1
        self.loadingView.view.frame = self.view.bounds
    }
    
    private func removeLoadingView() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.animate(withDuration: 0.7) {
                self.loadingView.view.alpha = 0
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loadingView.view.removeFromSuperview()
        }
    }
    
    // MARK: - Setups
    
    @objc func updateWeather(notification: Notification) {
        switch Reachability.isConnectedToNetwork() {
        case true:
            setupVC()
        case false:
            loadingView.showError(types: .networkError)
        }
    }
    
    private func setupVC() {
        setupLocationManager()
        setupTableView()
    }

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func setupTableView() {
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        
        weatherTableView.register(UINib(nibName: "DailyTableViewCell", bundle: nil), forCellReuseIdentifier: "DailyTableViewCell")
        weatherTableView.register(UINib(nibName: "HourlyTableViewCell", bundle: nil), forCellReuseIdentifier: "HourlyTableViewCell")
        weatherTableView.register(UINib(nibName: "InformationTableViewCell", bundle: nil), forCellReuseIdentifier: "InformationTableViewCell")
        weatherTableView.register(UINib(nibName: "DescriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "DescriptionTableViewCell")
        weatherTableView.showsVerticalScrollIndicator = false
        weatherTableView.allowsSelection = false
    }
    
}

// MARK: - TableView

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = WeatherTableViewSection(sectionIndex: section) else { return 0 }
        
        switch section {
        case .hourly:
            return 1
        case .daily:
            return 7
        case .information:
            return 1
        case .description:
            return descriptionArray.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return WeatherTableViewSection.numberOfSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = WeatherTableViewSection(sectionIndex: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .hourly:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HourlyTableViewCell", for: indexPath as IndexPath)
            guard let hourlyCell = cell as? HourlyTableViewCell else { return cell }
            
            if let weatherModel = weatherModel {
                hourlyCell.configure(model: weatherModel)
            }
            return hourlyCell
            
        case .daily:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DailyTableViewCell", for: indexPath as IndexPath)
            guard let dailyCell = cell as? DailyTableViewCell else { return cell }
            
            if let weatherModel = weatherModel {
                dailyCell.configure(model: weatherModel)
            }
            let viewModel = dailyCell.configureTableViewCellViewModelFor(indexPath.row)
            dailyCell.setupCell(viewModel)
            return dailyCell
            
        case .information:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InformationTableViewCell", for: indexPath as IndexPath)
            guard let informationCell = cell as? InformationTableViewCell else { return cell }
            
            if let weatherModel = weatherModel {
                informationCell.configure(model: weatherModel)
            }
            let viewModel = informationCell.configureTableViewCellViewModelFor(indexPath.row)
            informationCell.setupCell(viewModel)
            return informationCell
            
        case .description:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionTableViewCell", for: indexPath as IndexPath)
            guard let descriptionCell = cell as? DescriptionTableViewCell else { return cell }
            
            if let weatherModel = weatherModel {
                descriptionCell.configure(model: weatherModel)
            }
            let viewModel = descriptionCell.configureTableViewCellViewModelFor(indexPath.row)
            descriptionCell.setupCell(viewModel)
            return descriptionCell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let section = WeatherTableViewSection(sectionIndex: indexPath.section) else { return CGFloat() }
        switch section {
        case .hourly:
            return section.cellHeight
        case .daily:
            return section.cellHeight
        case .information:
            return UITableView.automaticDimension
        case .description:
            return section.cellHeight
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationManager.stopUpdatingLocation()
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        networkService.fetchWeatherData(latitude: latitude, longitude: longitude) { [weak self] (weather) in
            guard let self = self,
                  let weather = weather,
                  let currentWeather = weather.current.weather.first,
                  let dailytWeather = weather.daily.first else { return }
            self.locationNameLabel.text = weather.timezone.deletingPrefix()
            self.currentTempLabel.text = String(format: "%.f", weather.current.temp) + "°"
            self.descriptionNameLabel.text = currentWeather.descriptionWeather.firstCapitalized
            self.lowTempLabel.text = String(format: "%.f", dailytWeather.temp.min) + "°"
            self.highTempLabel.text = String(format: "%.f", dailytWeather.temp.max) + "°"
            self.todayLabel.text = "\(Date().getDayForDate()) Today"
            self.weatherModel = weather
            self.removeLoadingView()
            self.weatherTableView.reloadData()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Can't get location", error)
        loadingView.showError(types: .locationError)
    }
}
