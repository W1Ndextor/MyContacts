//
//  MyContactsTableViewController.swift
//  MyContacts
//
//  Created by student on 3/22/16.
//  Copyright © 2016 Josh. All rights reserved.
//

import UIKit

//import core data to use NSManagedObjects
import CoreData

class MyContactsTableViewController: UITableViewController {
    
    //setup managed object context passed from the app delegate
    var managedObjectContext: NSManagedObjectContext!
    
    // array to store data fetched from managedObjectContext
    var contactLists = [ContactList] ()

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Call helper method everytime the MyContacts screen loads
        reloadData()
        
        //implement add button in navigation bar to call the addContact method
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addContact:")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Helper method to execute fetch of data and reload to display the data fethced.
    func reloadData () {
        //create instance of a fetch request
        let fetchRequest = NSFetchRequest(entityName: "ContactList")
        
        //execute fetch request for ContactList and catch any potential errors
        do {
            if let results = try managedObjectContext.executeFetchRequest(fetchRequest) as?
                [ContactList] {
                contactLists = results
                tableView.reloadData()
            }
        } catch {
            fatalError("There was an error fetching contacts!")
        }
    }
    //////////////////
    func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.grayColor()
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    //////////////////////////////
    
    //implementing addContact method
    func addContact(sender: AnyObject?) {
        
        //create instance of alertController
        let alert = UIAlertController(title: "Add", message: "Contact", preferredStyle: .Alert)
        
        
        ////////////////////
        let color1 = colorWithHexString("F52887")
        let color2 = colorWithHexString("ff0000")
        alert.view.backgroundColor = color1
        alert.view.tintColor = color2
        alert.view
        alert.view.layer.cornerRadius = 36
        //alert.view.layer
        /////////////////////////
        //alert.view.backgroundColor = UIColor.brownColor()
        
        
        //define what happenes when the alert add button is pushed
        let addAction = UIAlertAction(title: "Add", style: .Default) { (action) -> Void in
            
            //setting up alert textfields based on/equal to user input
            if let nameTextField = alert.textFields?[0], emailTextField = alert.textFields?[1], phoneTextField = alert.textFields?[2], contactListEntity = NSEntityDescription.entityForName("ContactList", inManagedObjectContext: self.managedObjectContext), name = nameTextField.text, email = emailTextField.text, phone = phoneTextField.text{
                
                //adding to core data
                let newContactList = ContactList(entity: contactListEntity, insertIntoManagedObjectContext: self.managedObjectContext)
                
                newContactList.name = name
                newContactList.email = email
                newContactList.phone = phone
                
                do {
                    try self.managedObjectContext.save()
                } catch {
                    print("Error saving the anaged object context!")
                }
                //fetch data that was inserted and reload the tableView to display it
                self.reloadData()
            }
        }
        
        //define what happens when the alert cancle button is pushed which is nothing.
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action) -> Void in
        
        }
        
        //set placeholdr text for alert textfields.
        alert.addTextFieldWithConfigurationHandler { (textField) in textField.placeholder = "Name"
        }
        
        alert.addTextFieldWithConfigurationHandler { (textField) in textField.placeholder = "Email"
        }
        
        alert.addTextFieldWithConfigurationHandler { (textField) in textField.placeholder = "Phone"
        }
        
        //add the created buttons to the alert
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        //present the viewcontroller alert
        presentViewController(alert, animated: true, completion: nil)
    }


    // MARK: - Table view data source

    //changed from 0 to 1 because 1 section is desired
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    //changed from 0 to contactLists.count because as many rows as there is data is desired.
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contactLists.count
    }

    //specify which cell to deque and configure for data.
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactListCell", forIndexPath: indexPath)

        // Configure the cell...for all data required--that is--name, email and phone.
        //storing the cell in an immutable variable
        let contactList = contactLists[indexPath.row]
        //populating cell data
        cell.textLabel?.text = contactList.name
        cell.detailTextLabel?.text = contactList.email + " " + contactList.phone
        //returning cell
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
