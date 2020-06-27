//
//  VillageViewController.swift
//  SangrurCity
//
//  Created by PARMJIT SINGH KHATTRA on 27/6/20.
//  Copyright © 2020 PARMJIT SINGH KHATTRA. All rights reserved.
//

import UIKit
import CoreData
class VillageViewController: UIViewController {

    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let constant = Constant()
    var village = [Village]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadVillage()
        
    }
  // MARK:- AddVillage Methods
    
    @IBAction func addVillage(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Village", message: "Village Name", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newVillage = Village(context: self.context)
            newVillage.villageName = textField.text!
            self.village.append(newVillage)
            self.saveVillage()
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "enter village"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    // MARK:- saveVillage Methods
    func saveVillage() {
        do {
            try context.save()
        } catch  {
            print("Error Saving\(error)")
        }
        tableView.reloadData()
    }
    
        // MARK:- loadVillage Methods
    func loadVillage(with request: NSFetchRequest<Village> = Village.fetchRequest()) {
        do {
           village = try context.fetch(request)
        } catch  {
            print("Error loading\(error)")
        }
        tableView.reloadData()
    }
    
}
    // MARK:- UITableView DataSource Methods
extension VillageViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return village.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: constant.villageCell, for: indexPath)
        cell.textLabel?.text = village[indexPath.row].villageName
        return cell
    }
}
        
    // MARK:- UITableView Delegate Methods
extension VillageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        context.delete(village[indexPath.row])
        village.remove(at: indexPath.row)
        saveVillage()
    }
}
        
        // MARK:- Add SearchBar Delegate Methods
extension VillageViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadVillage()
            DispatchQueue.main.async {
                self.tableView.resignFirstResponder()
            }
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Village> = Village.fetchRequest()
        let predicate = NSPredicate(format: "villageName CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "villageName", ascending: true)]
        request.predicate = predicate
        loadVillage(with: request)
    }
}

