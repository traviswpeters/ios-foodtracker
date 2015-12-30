//
//  MealTableViewController.swift
//  FoodTracker
//

import UIKit

class MealTableViewController: UITableViewController {

    // MARK: Properties
    
    var meals = [Meal]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem()
        
        // Load any saved meals, otherwise load sample data.
        if let savedMeals = loadMeals() {
            meals += savedMeals
        } else {
            // Load the sample data.
            loadSampleMeals()
        }
    }
    
    func loadSampleMeals() {
        // A helper method to load sample data into the app.
        
        let photo1 = UIImage(named: "meal1")!
        let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4)!
        
        let photo2 = UIImage(named: "meal2")!
        let meal2 = Meal(name: "Chicken and Potatoes", photo: photo2, rating: 5)!
        
        let photo3 = UIImage(named: "meal3")!
        let meal3 = Meal(name: "Pasta with Meatballs", photo: photo3, rating: 3)!
        
        meals += [meal1, meal2, meal3]

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Tells the table view how many sections to display (we only need one for this simple app).
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MealTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MealTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let meal = meals[indexPath.row]
        
        // Set each of the views in the table view cell to display the corresponding data from meal.
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            meals.removeAtIndex(indexPath.row)
            
            // Save the meals.
            saveMeals()

            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let mealDetailViewController = segue.destinationViewController as! MealViewController
            
            // Get the cell that generated this segue.
            if let selectedMealCell = sender as? MealTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedMealCell)!
                let selectedMeal = meals[indexPath.row]
                mealDetailViewController.meal = selectedMeal
                
                print("Editing meal: \(selectedMeal.name).")
            }
        }
        else if segue.identifier == "AddItem" {
            print("Adding new meal.")
        }
    }
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        /*
        This code uses the optional type cast operator (as?) to try to downcast the source view controller of the segue to type MealViewController. You need to downcast because sender.sourceViewController is of type UIViewController, but you need to work with MealViewController.
        
        The operator returns an optional value, which will be nil if the downcast wasn’t possible. If the downcast succeeds, the code assigns that view controller to the local constant sourceViewController, and checks to see if the meal property on sourceViewController is nil. If the meal property is non-nil, the code assigns the value of that property to the local constant meal and executes the if statement.
        
        If either the downcast fails or the meal property on sourceViewController is nil, the condition evaluates to false and the if statement doesn’t get executed.
        */
        if let sourceViewController = sender.sourceViewController as? MealViewController, meal = sourceViewController.meal {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                /* 
                 * Update an existing meal.
                 */
                
                // Set selected row (meal) with update meal object.
                meals[selectedIndexPath.row] = meal
                
                // This animates the updating of a row in the table view for the cell that contains updated meal information.
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            }
            else {
                /* 
                 * Add a new meal.
                 */
                
                // Computes the location in the table view where the new table view cell representing the new meal will be inserted.
                let newIndexPath = NSIndexPath(forRow: meals.count, inSection: 0)

                // Add a new meal.
                meals.append(meal)
                
                // This animates the addition of a new row to the table view for the cell that contains information about the new meal. 
                // The .Bottom animation option shows the inserted row slide in from the bottom.
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            
            // Save the meals.
            saveMeals()
        }
    }
    
    // MARK: NSCoding
    
    // Save a archived list of meals.
    func saveMeals() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save meals...")
        }
        else {
            print("Saving archive of meal list to: \(Meal.ArchiveURL.path)")
        }
    }
    
    // Load an archived list of meals.
    func loadMeals() -> [Meal]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Meal.ArchiveURL.path!) as? [Meal]
    }

}
