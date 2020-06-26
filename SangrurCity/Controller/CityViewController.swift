//
//  ViewController.swift
//  SangrurCity
//
//  Created by PARMJIT SINGH KHATTRA on 27/6/20.
//  Copyright © 2020 PARMJIT SINGH KHATTRA. All rights reserved.
// AddCity Methods UITableView DataSource Methods

import UIKit
import CoreData
class CityViewController: UIViewController {
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let constant = Constant()
    var city = [City]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCity()
    }
    // MARK:- AddCity Methods
    
    @IBAction func addCity(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "add city", message: "City Name", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCity = City(context: self.context)
            newCity.cityName = textField.text!
            self.city.append(newCity)
            self.saveCity()
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "enter city"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    
    // MARK:- saveCity Methods
    func saveCity() {
        do {
            try context.save()
        } catch  {
            print("Error Saving\(error)")
        }
        tableView.reloadData()
    }
    
    // MARK:- loadCity Methods
    func loadCity() {
        let request: NSFetchRequest<City> = City.fetchRequest()
        do {
            city = try context.fetch(request)
        } catch  {
            print("Error Loading\(error)")
        }
        
    }
}
// MARK:- UITableView DataSource Methods
extension CityViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return city.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: constant.cityCell, for: indexPath)
        cell.textLabel?.text = city[indexPath.row].cityName
        return cell
    }
}

    
// MARK:- UITableView Delegate Methods
extension CityViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: constant.goToVillage, sender: self)
    }
}
    
    // MARK:- Add SearchBar Delegate Methods

///
