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
        
        DispatchQueue.global(qos: DispatchQoS.userInitiated.qosClass).async {
            self.test1 = self.jsonParsingFromFile("part501")
            
            self.questionFullTestArray[0] = self.test1
            
            DispatchQueue.main.async {
                print("element in questionFullTestArray: \(self.questionFullTestArray.count)")
            }
        }
    }
    
    // MARK: - my function
    // Parsing Data from JSON file
    func jsonParsingFromFile(_ nameFile: String) -> [QuestionAndAnswer] {
        var questionTest = [QuestionAndAnswer]()
        
        let path: NSString = Bundle.main.path(forResource: nameFile, ofType: "json")! as NSString
        let data: Data = try! Data(contentsOf: URL(fileURLWithPath: path as String), options: [])
        questionTest = listQAsFromJSONData(jsonData: data)
        
        print("Parsing from file \(nameFile).json done. Have \(questionTest.count) questions")
        return questionTest
    }
    
    // List Question and answer from JSON Data
    func listQAsFromJSONData(jsonData: Data) -> [QuestionAndAnswer] {
        guard let dict = try? JSONSerialization.jsonObject(with: jsonData, options: []),
            let dictTemp = dict as? Dictionary<String, Any>,
            let jsonQAs = dictTemp["results"] as? [Dictionary<String, Any>] else {return []}
        
        return jsonQAs.flatMap({ (qADesc: Dictionary) -> QuestionAndAnswer? in
            guard let question = qADesc["question"] as? String,
                let answerCorrect = qADesc["answerCorrect"] as? String,
                let answer1 = qADesc["answer1"] as? String,
                let answer2 = qADesc["answer2"] as? String,
                let answer3 = qADesc["answer3"] as? String,
                let answer4 = qADesc["answer4"] as? String
                else {return nil}
            return QuestionAndAnswer(question: question, answerArray: [answer1, answer2, answer3, answer4], answerCorrect: answerCorrect)
        })
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
