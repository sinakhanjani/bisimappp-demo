
//
//  MapSearchViewController.swift
//  Bisim App
//
//  Created by Sinakhanjani on 8/23/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

protocol HandleMapSearch: class {
    func searchBarSelectedItem(_ prediction: Prediction)
}

class MapSearchViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var predictions: [Prediction]?
    weak var handleMapSearchDelegate: HandleMapSearch?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // Action
    @IBAction func closeButtonPressed(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
//
    // Method
    func updateUI() {
        registerForKeyboardNotifications()
        searchBar.delegate = self
        searchBar.tintColor = .darkGray
        searchBar.setValue("انصراف", forKey:"_cancelButtonText")
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.font: UIFont(name: IRAN_SANS_BOLD_MOBILE_FONT, size: 16)!]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: IRAN_SANS_BOLD_MOBILE_FONT, size: 15)!], for: .normal)
    }

    func getJson(searchedText: String?) {
        guard let searchedText = searchedText else { return }
        guard let url = URL(string: "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(searchedText)&inputtype=textquery&key=AIzaSyAf0sKw2uMrV9n8r28Dz-AYc4T5-ctnQ8k&language=fa".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) else { return }
        let request = URLRequest.init(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error.debugDescription)
            }
            guard let data = data else { return }
            guard let decodedJson = try? JSONDecoder().decode(GoogleSearch.self, from: data) else { return }
            self.predictions = decodedJson.predictions
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            }.resume()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            getJson(searchedText: searchText.lowercased())
        } else {
            self.predictions = [Prediction]()
        }
        self.tableView.reloadData()
    }
    
    static func showModal() -> MapSearchViewController {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let nav = storyboard.instantiateViewController(withIdentifier: SEARCH_NAV_ID) as! UINavigationController
        let mapSearchVC = nav.viewControllers.first as! MapSearchViewController
        return mapSearchVC
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector:
            #selector(keyboardWasShown(_:)),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:
            #selector(keyboardWillBeHidden(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(_ notificiation: NSNotification) {
        guard let info = notificiation.userInfo,
            let keyboardFrameValue =
            info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue
            else { return }
        
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
    }
    

}

extension MapSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let predictions = self.predictions, !predictions.isEmpty {
            return predictions.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SEARCH_CELL, for: indexPath)
        if let predictions = self.predictions, !predictions.isEmpty {
            cell.textLabel?.text = predictions[indexPath.row].description
            return cell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let prediction = self.predictions else { return }
        handleMapSearchDelegate?.searchBarSelectedItem(prediction[indexPath.row])
        self.view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
}
