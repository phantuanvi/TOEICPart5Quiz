//
//  MainVC.swift
//  TOEICPart5Quiz
//
//  Created by Tuan-Vi Phan on 4/2/16.
//  Copyright © 2016 Tuan-Vi Phan. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - variables
    let nameTests = ["Test 1"]
    var questionFullTestArray = [[QuestionAndAnswer]()]
    var test1 = [QuestionAndAnswer]()

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = false
        
        test1 = jsonParsingFromFile("part501")
        
        questionFullTestArray[0] = test1
        print("element in questionFullTestArray: \(questionFullTestArray.count)")
    }
    
    // MARK: - my function
    // Parsing Data from JSON file
    func jsonParsingFromFile(nameFile: String) -> [QuestionAndAnswer] {
        var questionTest = [QuestionAndAnswer]()
        let arrDict: NSMutableArray = []
        
        let path: NSString = NSBundle.mainBundle().pathForResource(nameFile, ofType: "json")!
        let data: NSData = try! NSData(contentsOfFile: path as String, options: NSDataReadingOptions.DataReadingMapped)
        
        let dict: NSDictionary! = (try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
        
        for var i = 0; i < (dict.valueForKey("results") as! NSArray).count; i++ {
            arrDict.addObject((dict.valueForKey("results") as! NSArray).objectAtIndex(i))
        }
        
        // addQuestionToArr()
        for arr in arrDict {
            
            let question = arr["question"] as! String
            let answerCorrect = arr["answerCorrect"] as! String
            let answerArray = [arr["answer1"] as! String, arr["answer2"] as! String, arr["answer3"] as! String, arr["answer4"] as! String]
            let oneQuestion = QuestionAndAnswer(question: question, answerArray: answerArray, answerCorrect: answerCorrect)
            
            questionTest.append(oneQuestion)
        }
        
        print("Parsing from file \(nameFile).json done. Have \(questionTest.count) questions")
        return questionTest
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "quizSegue" {
            
            let nextScene = segue.destinationViewController as! QuizVC
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let test = questionFullTestArray[indexPath.row]
                nextScene.questionsFullTest = test
            }
        }
    }

}

extension MainVC: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension MainVC: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameTests.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = nameTests[indexPath.row]
        return cell
    }
    
}
