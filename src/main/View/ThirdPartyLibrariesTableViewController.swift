//
//  ThirdPartyLibrariesTableViewController.swift
//  MyMovies
//
//  Created by Antonio Fernández Martín on 18/09/2020.
//  Copyright © 2020 Antonio Fernández Martín. All rights reserved.
//

import UIKit

class ThirdPartyLibrariesTableViewController: UITableViewController {

    let nameLibraries = ["SDOSLoader", "SDOSEnvironment", "SDOSPluggableApplicationDelegate", "SDWebImage"]
    let libraries = ["https://github.com/SDOSLabs/SDOSLoader", "https://github.com/SDOSLabs/SDOSEnvironment", "https://github.com/SDOSLabs/SDOSPluggableApplicationDelegate", "https://github.com/SDWebImage/SDWebImage"]
    
    @IBOutlet var librariesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        librariesTableView.sectionFooterHeight = 0.0
        librariesTableView.tableFooterView = UIView(frame:CGRect.zero)
        librariesTableView.delegate = self
        librariesTableView.dataSource = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameLibraries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "library", for: indexPath)
        
        cell.textLabel?.text = nameLibraries[indexPath.row]
        cell.textLabel?.textColor = .black
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: libraries[indexPath.row]) {
            UIApplication.shared.open(url)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 100))

        let sectionText = UILabel()
        sectionText.frame = CGRect.init(x: 15, y: 15, width: sectionHeader.frame.width-30, height: sectionHeader.frame.height-30)
        sectionText.text = NSLocalizedString("infoApp", comment: "")
        sectionText.textAlignment = .left
        sectionText.numberOfLines = 4
        sectionText.font = .systemFont(ofSize: 14, weight: .bold)
        sectionText.textColor = .black
        
        sectionHeader.addSubview(sectionText)
        
        return sectionHeader
    }
    

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
}
