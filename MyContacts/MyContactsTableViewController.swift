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




///I was under the impression that this code was mandatory for the other conversion function but I commented it out and everything still seems to have the proper colors so perhaps I was incorrect. Regardless I left it in here for you to examine if you so desired. The actual conversion function implemented is down below in the code.



///This code allows for a wider range of color selection as opposed to being limited to the built UIColor values.
///Hexideciaml color codes can be found at many sites such as:
 //http://html-color-codes.info/
 //http://www.w3schools.com/colors/colors_picker.asp
 //http://www.color-hex.com/
///This is not of my own design, I obtained it from:
 //https://www.hackingwithswift.com/example-code/uicolor/how-to-convert-a-hex-color-to-a-uicolor

/*extension UIColor {
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.startIndex.advancedBy(1)
            let hexColor = hexString.substringFromIndex(start)
            
            if hexColor.characters.count == 8 {
                let scanner = NSScanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexLongLong(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}*/


class MyContactsTableViewController: UITableViewController {
    
    //setup managed object context passed from the app delegate
    var managedObjectContext: NSManagedObjectContext!
    
    // array to store data fetched from managedObjectContext
    var contactLists = [ContactList] ()

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Call helper method everytime the MyContacts screen loads
        reloadData()
        
        //make mutable variable for number of contacts initialize to zero
        var totalContacts = 0
        
        //set the total number of contacts equal to the size of the array they are stored in
        totalContacts = contactLists.count

        //Display the name of the app and the total number of contacts in the app at any given time.
        title = "MyContacts" + String(format: " %d", totalContacts)
        
            //Alternate app heading
            //title = String(format: " %d" + " Contacts Available", totalContacts)
        
        
        //implement add button in navigation bar to call the addContact method
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addContact:")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        
        ///this changes the color of the navigation bar containing the name of the app and the add buttonto a bright green color.
        ///normally this would need to be set equal to a UIColor.
        ///for example
        ///navigationController?.navigationBar.backgroundColor = UIColor.greenColor()
        ///however by using colorwithHexString() method we can get a much more exact shade of whatever color we want.
        ///also notice how the string representation of the hexidecimal value does not have a "#" before the color value
        ///this is because the method is set up to handle string representions with or without "#", it will work either way.
        navigationController?.navigationBar.barTintColor = colorWithHexString("87F528")
        
        
        
        ///this code will override any tint settings set in the storyboard but I beleive this will be exclusive to the
        ///navigation bar's tint.
        ///I have commented it out because I do not want the override.
        ///navigationController?.navigationBar.tintColor = colorWithHexString("ff33cc")
        
        
        
        ///This code will allow you to change the color of the appName text, as far as I can tell this is only possible
        ///by using the built in UIColor functions. of which there are many including: blueColor, blackColor(), redColor,
        /// even clearColor() but for a full list of all built in colors available I would refer to the dropdowns/auto
        ///complete menus or maybe even thr API.
        navigationController?.navigationBar.titleTextAttributes = ([NSForegroundColorAttributeName: UIColor.orangeColor()])
        
        
        
        ///the code below is remnants of ideas I could not get to work properly in my personal opinion the most notable and
        ///useful of these is .LightContent which enables the switching of the metrics bar at the top of the app to be black
        ///or white but I'm not even entirely ure of this much. This functionality could very well be automatic. However, in
        ///the even that it is not automatic the proper implementation of light content could be extremely useful in a
        ///situation where a darkly colored navigation bar is desired, and the metrics be easily visible. This way if you
        ///wanted a black navigation bar the metrics could be white instead of black by using .lightcontent
        ///but again, this could be automatic.
    
        //let col2 = UIColor(hue: 0, saturation: 0.66, brightness: 0.66, alpha: 1)
        ///let orange = UIColor(hexString: "#ff9933")
        //UIStatusBarStyle.LightContent
        
        
        ////end broken code
        
    }
    
    
    ///this is another attempt at implementing .lightcontent
    //override func preferredStatusBarStyle() -> UIStatusBarStyle {
       // return UIStatusBarStyle.LightContent
    //}
    
    

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
    
    ///This method will take a hexidecimal color value  as a string and converts it to a UIColor
    ///This allows for a wider range of color selection as opposed to being limited to the built UIColor values
    ///Hexideciaml color codes can be found at many sites such as:
     //http://html-color-codes.info/
     //http://www.w3schools.com/colors/colors_picker.asp
     //http://www.color-hex.com/
    ///This method is not of my own design I obtained it from:
     //http://stackoverflow.com/questions/24263007/how-to-use-hex-colour-values-in-swift-ios
    
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
    
   
    
    //implementing addContact method
    func addContact(sender: AnyObject?) {
        
        //create instance of alertController
        let alert = UIAlertController(title: "Add", message: "Contact", preferredStyle: .Alert)
        
        
        ///as can be seen here not only can we call the conversion conversion method to use hex color codes we can also call the set a variable equal to that method call passing the desired value
        let scarlet_orange = colorWithHexString("E63900")
       
        
        
        ///so here I make a variable named darkblue and I pass the method a hex value for a shade of dark blue.
        let darkblue = colorWithHexString("09147C")
        
        
        
        ///Please note that the alert background  color was intended to be orange. However, due to certain properties which I did not look into changing, the color will be lighter once it is applied to the alert window. so Instead of using orange I simply used scarlet which when applied became lightened to an orange shade.
        
        
        
        ///setting alert window color
        alert.view.backgroundColor = scarlet_orange
        
        
        
        ///additionally instead of using conversions of hex to UIColors you could simply use the built in UIColors such as orangeColor() for example : alert.view.backgroundColor = UIColor.orangeColor()
        
        
        
        ///set alert window tint; this only changes the color values of the add and cancel buttons it does not apply to every thing in the window and I am not entirely sure why though I did look into it a bit, this is still inconclsuive in my findings.
        alert.view.tintColor = darkblue
        
        
    
        ///I tried to mess around with textfield color, insertion point, and alert window label but I moved on to other things after a little while
        
        
        
        ///this is a nifty little line of code, let me explain:
        ///apparently when you set the alert window background color it simply puts a shaded rectangle behind the window and the "frosted transparency" of the window as I call it will simply allow the color to bleed through. The reason we saw those ugly looking corners on the window after class was because of this rectangle. By changing it to about 36 (which was simply a random number I entered to test the code) seemed to make it fill the alert window perfectly. This is because the code seems to fillet down the corners of the rectangle. But what I think i really cool about this code is that it can be used to create some interesting gradient effects, for example try changing the value from 36 to 90 and then run the app and you'll see what I mean on the corners of the alert window. this code is worth playing around with.
        alert.view.layer.cornerRadius = 36
        
        
        
        ///there are many other alert window properties which can be tinkered with includeing shadows, and the width of the alert window border, Again i would reference either the auto complete dropdown windows or maybe the API/
        
        
        
        ///below is simply some code I was tinkering around with that I couldnt get to completely work.
        
        //alert.view.layer.opacity = -100.0
        //alert.view.alpha = -100.0
        //alert.view.layer.opaque = true
        //alert.view.layer.opacity = -50.00
        //alert.view.layer
        //alert.view.alpha = 50.0
        
        
        ///end broken code
      
        
        
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
                    //update the number of contacts in real time
                    self.viewDidLoad()
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

        
        
        ///below you will find code which attempts to implement a color change on a cell when a contact is selected however i could not get it to work properly the default gray value was an eye strain and it needed to go because of my broght green text. I simply changed the selesction style to none as you can see by my code, I figured it wasnt an enormous deal because this is simply a list and selection seems like a rather menial feature at this stage in the implementation. I suspect that the issues here had to do with color settings set in the storyboard file but i am not entirely sure. also worth noting is that there were a few other options such as cell.selectionStyle = .Blue but these also didnt work, I suspect for the same reason.
        
        
        
        ///removing selection highlighting...works
        cell.selectionStyle = .None
        
        
        
        // Configure the cell...for all data required--that is--name, email and phone.
        //storing the cell in an immutable variable
        let contactList = contactLists[indexPath.row]
        //populating cell data
        cell.textLabel?.text = contactList.name
        cell.detailTextLabel?.text = contactList.email + " " + contactList.phone
        //returning cell
        return cell
    
        
        
        ///here is the broken selection code, it is under retrurn cell for organization purposes but was initally above it confirming that this was not the cause of error.
        
        
        //let color5 = colorWithHexString("40E0D0")
    
        
        //if(cell.selected){
          //  cell.selectedBackgroundView?.tintColor = UIColor.redColor()
       // }//else{
            //cell.contentView.backgroundColor = color5
       // }

        
        
        //if(cell.selected){
          // cell.contentView.backgroundColor = UIColor.redColor()
       // }else{
        //   cell.contentView.backgroundColor = color5
        //}
       ///if(cell.selected == true){
         ///   cell.backgroundView?.backgroundColor = UIColor.redColor()
        ///}
        //cell.selected = cell.contentView
        
        
        ///end broken code
        
        
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        //check if delete edit is being made
        if editingStyle == .Delete {
            
            //get that items row and store the element of the array it is contained in into the variable item
            let item = contactLists[indexPath.row]
            
            //delete the item
            managedObjectContext.deleteObject(item)
            
            do {
                //save the deletion edit
                try self.managedObjectContext.save()
                //update the number of contacts in real time
                self.viewDidLoad()
            } catch {
                //catch any errors
                print("Error saving the managed object context")
            }
            //relaod the table view
            reloadData()
        }
    }
    
    

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
