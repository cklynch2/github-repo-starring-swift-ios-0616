//
//  ReposTableViewController.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposTableViewController: UITableViewController {
    
    let store = ReposDataStore.sharedInstance
    var starController = UIAlertController()
    var unstarController = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.accessibilityLabel = "tableView"
        self.tableView.accessibilityIdentifier = "tableView"
        
        store.getRepositoriesWithCompletion {
            NSOperationQueue.mainQueue().addOperationWithBlock({ 
                self.tableView.reloadData()
            })
        }
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store.repositories.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("repoCell", forIndexPath: indexPath)

        let repository:GithubRepository = self.store.repositories[indexPath.row]
        cell.textLabel?.text = repository.fullName

        return cell
    }
    
    // When a cell in the table view is selected, toggle the starred status and display a UIAlertController saying either "You just starred REPO NAME" or "You just unstarred REPO NAME".
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedRepo = self.store.repositories[indexPath.row]
        configureAlertControllers(selectedRepo.fullName)
        
        store.toggleStarStatusForRepository(selectedRepo) { (toggleStar) in
            if toggleStar {
                self.presentViewController(self.starController, animated: true, completion: nil)
            } else if !toggleStar {
                self.presentViewController(self.unstarController, animated: true, completion: nil)
            }
        }
    }
    
    
    func configureAlertControllers(repoName: String) {
        starController = UIAlertController(title: "⭐️STAR⭐️", message: "You just starred \(repoName).", preferredStyle: .Alert)
        starController.accessibilityLabel = "You just starred REPO NAME"
        addDismissActionToAlert(starController)
        
        unstarController = UIAlertController(title: "💔UNSTAR💔", message: "You just unstarred \(repoName).", preferredStyle: .Alert)
        unstarController.accessibilityLabel = "You just unstarred REPO NAME"
        addDismissActionToAlert(unstarController)
    }
    
    
    func addDismissActionToAlert(alert: UIAlertController) {
        let okStarAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }
        alert.addAction(okStarAction)
    }

}
