//
//  MonyTableViewController.swift
//  TestProjectMonyList
//
//  Created by Zimma on 05/09/2018.
//  Copyright © 2018 Zimma. All rights reserved.
//

import UIKit

class MonyTableViewController: UITableViewController {
    
    var monyArray = [Mony]()
    let globalURL = "http://phisix-api3.appspot.com/stocks.json"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        _ = Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { (timer) in
            self.loadData()
        }
        
        
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return monyArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "MonyCell", for: indexPath) as! MonyTableViewCell
        
        cell.nameLblCell.text = monyArray[indexPath.row].name
        cell.priceLblCell.text = String(monyArray[indexPath.row].volume)
        cell.amountLblCell.text = String(monyArray[indexPath.row].price.amount.rounded(toPlaces: 2))

        return cell
    }
    
    @IBAction func refrashTableAction(_ sender: UIBarButtonItem) {
        loadData()
    }
    
    //MARK: - Check connection & Load Data
    func loadData() {
        
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)]
        self.navigationItem.title = "Загружаем..."
        
        NetworkLayer.isInternetAvailable(webSiteToPing: globalURL) { (status, mess) in
            
            if let mess = mess {
                let alert = UIAlertController(title: "Внимание", message: mess, preferredStyle: .alert)
                let ok = UIAlertAction(title: "Повторить", style: .default, handler: { (_) in
                    self.loadData()
                })
                alert.addAction(ok)
                self.present(alert, animated: true)
                
            } else {
                
                guard let url = URL(string: self.globalURL) else { return }
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    
                    guard let data = data else { return }
                    guard error == nil else { return }
                    
                    do {
                        let monyLoad = try JSONDecoder().decode(Stock.self, from: data)
                        DispatchQueue.main.async {
                            self.monyArray = monyLoad.stock
                            self.tableView.reloadData()
                            
                            self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                            self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)]
                            self.navigationItem.title = "Mony"
                        }
                        
                    } catch let error {
                        print("Ошибка :( \(error)")
                    }
                    }.resume()
            }
        }
    }
}

//MARK: - Double extension
extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
