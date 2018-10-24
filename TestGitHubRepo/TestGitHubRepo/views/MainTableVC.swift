//
//  ViewController.swift
//  TestGitHubRepo
//
//  Created by Zimma on 24/10/2018.
//  Copyright © 2018 Zimma. All rights reserved.
//

import UIKit

class MainTableVC: UITableViewController {
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = UIActivityIndicatorView.Style.gray
        indicator.isHidden = true
        return indicator
    }()
    
    
    let globalURL = "https://api.github.com/search/repositories?q="
    var repoArray = [Repo]()
    private let cellId = "RepoCell"
    var searchTitle = "Начните поиск!"
    var sortUpDown: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(RepoCell.self, forCellReuseIdentifier: cellId)

        navBarSettup()
        onOffSortButton()
        
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repoArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RepoCell
        cell.nameLabel.text = repoArray[indexPath.row].fullName
        cell.starsDataLablel.text = String(repoArray[indexPath.row].stars)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = RepoInfoVC()
        let repo = repoArray[indexPath.row]
        vc.repoData = repo
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    private func navBarSettup() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTap(button:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "1-0-2", style: .plain, target: self, action: #selector(sortRepo(button:)))
        navigationItem.leftBarButtonItem?.tintColor = GlobalColors.darkTextColor
        navigationItem.rightBarButtonItem?.tintColor = GlobalColors.darkTextColor
        navigationItem.title = searchTitle
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: GlobalColors.darkTextColor]
    }
    
    //Left BurButton
    @objc func searchButtonTap(button: UIButton) {
        
        let alertVc = UIAlertController(title: "Поиск", message: "Введите название репозитория", preferredStyle: .alert)
        
        alertVc.addTextField { (searchTextField) in
            searchTextField.placeholder = "Начните ввод"
        }
        
        let ok = UIAlertAction(title: "oK", style: .default) { (UIAlertAction) in
            if alertVc.textFields![0].text! != "" {
                self.searchTitle = alertVc.textFields![0].text!
                self.navigationItem.title = self.searchTitle
                self.activityIndicator.startAnimating()
                self.activityIndicator.isHidden = false
                self.checkConnection {
                    self.loadData(nameOfRepo: self.searchTitle)
                    self.sortUpDown = nil
                }
            } else {
                return
            }
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertVc.addAction(ok)
        alertVc.addAction(cancel)
        present(alertVc, animated: true)
        
    }
    
    //Right BurButton
    @objc func sortRepo(button: UIButton) {
        if sortUpDown == nil || !sortUpDown! {
            let sortedArray = repoArray.sorted(by: { $0.stars < $1.stars })
            repoArray = sortedArray
            tableView.reloadData()
            navigationItem.rightBarButtonItem?.title = "0-1-2"
            sortUpDown = true
            
        } else {
            let sortedArray = repoArray.sorted(by: { $0.stars > $1.stars })
            repoArray = sortedArray
            tableView.reloadData()
            navigationItem.rightBarButtonItem?.title = "2-1-0"
            sortUpDown = false
        }

        
    }
    
    private func loadData(nameOfRepo: String) {
        guard let url = URL(string: self.globalURL + self.searchTitle) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }
            guard error == nil else { return }
            
            do {
                let repo = try JSONDecoder().decode(Items.self, from: data)
                DispatchQueue.main.async {
                    self.repoArray = repo.items
                    self.tableView.reloadData()
                    self.navigationItem.rightBarButtonItem?.title = "1-0-2"
                    self.onOffSortButton()
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
                
            } catch let error {
                print("Error: \(error)")
            }
            
            }.resume()
    }
    
    private func checkConnection(complition: @escaping ()->()) {
        
        CheckNetwork.isInternetAvailable(webSiteToPing: globalURL) { (status, mess) in
            if let mess = mess {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Внимание", message: mess, preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "Хорошо", style: .cancel, handler: nil)
                    alert.addAction(cancel)
                    self.present(alert, animated: true)
                }
            } else {
                complition()
            }
        }
    }
    
    private func onOffSortButton() {
        if !repoArray.isEmpty {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
}
