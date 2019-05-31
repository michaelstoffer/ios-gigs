//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Michael Stoffer on 5/28/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    let gigController = GigController()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.gigController.bearer == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        } else {
            self.gigController.fetchAllGigs { (result) in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.gigController.gigs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)

        let gig = self.gigController.gigs[indexPath.row]
        cell.textLabel?.text = gig.title
        let df = DateFormatter()
        cell.detailTextLabel?.text = df.string(from: gig.dueDate)

        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginViewModalSegue" {
            guard let loginVC = segue.destination as? LoginViewController else { return }
            loginVC.gigController = self.gigController
        } else if segue.identifier == "AddGig" {
            guard let gigsDVC = segue.destination as? GigsDetailViewController else { return }
            gigsDVC.gigController = self.gigController
        } else if segue.identifier == "EditGig" {
            guard let indexPath = self.tableView.indexPathForSelectedRow,
                let gigsDVC = segue.destination as? GigsDetailViewController else { return }
            
            let gig = self.gigController.gigs[indexPath.row]
            
            gigsDVC.gigController = self.gigController
            gigsDVC.gig = gig
        }
    }
}
