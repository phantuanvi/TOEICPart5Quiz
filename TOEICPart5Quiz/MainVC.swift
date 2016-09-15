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
    func jsonParsingFromFile(_ nameFile: String) -> [QuestionAndAnswer] {
        var questionTest = [QuestionAndAnswer]()
        
        let path: NSString = Bundle.main.path(forResource: nameFile, ofType: "json")! as NSString
        let data: Data = try! Data(contentsOf: URL(fileURLWithPath: path as String), options: NSData.ReadingOptions.dataReadingMapped)
        
        let dict: NSDictionary! = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
        
        if let dictTempt = dict as? Dictionary<String, AnyObject> {
            if let arrDict = dictTempt["results"] as? [[String:Any]] {
                // addQuestionToArr()
                for arr in arrDict {
                    
                    let question = arr["question"] as! String
                    let answerCorrect = arr["answerCorrect"] as! String
                    let answerArray = [arr["answer1"] as! String, arr["answer2"] as! String, arr["answer3"] as! String, arr["answer4"] as! String]
                    let oneQuestion = QuestionAndAnswer(question: question, answerArray: answerArray, answerCorrect: answerCorrect)
                    
                    questionTest.append(oneQuestion)
                }
            }
        }
        
        print("Parsing from file \(nameFile).json done. Have \(questionTest.count) questions")
        return questionTest
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "quizSegue" {
            
            let nextScene = segue.destination as! QuizVC
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let test = questionFullTestArray[(indexPath as NSIndexPath).row]
                nextScene.questionsFullTest = test
            }
        }
    }

}

extension MainVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameTests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = nameTests[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.textColor = TEXTCOLOR
        cell.backgroundColor = MAINCOLOR
        
        return cell
    }
    
}
