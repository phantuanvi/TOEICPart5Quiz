//
//  QuestionAndAnswer.swift
//  TOEICPart5Quiz
//
//  Created by Tuan-Vi Phan on 4/2/16.
//  Copyright © 2016 Tuan-Vi Phan. All rights reserved.
//

import UIKit

class QuestionAndAnswer: NSObject {
    let question: String!
    var answerArray: [String]!
    let answerCorrect: String!
    
    required init(question: String, answerArray: [String], answerCorrect: String) {
        self.question = question
        self.answerArray = answerArray
        self.answerCorrect = answerCorrect
    }
}
