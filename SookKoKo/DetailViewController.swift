//
//  DetailViewController.swift
//  InForLoA
//
//  Created by bene9275 on 2022/01/10.
//

import UIKit

import Toast

// 8방향을 인덱스로 표현
// 북쪽부터 시작(즉, 0은 북쪽 방향을 의미)
// 인덱스가 증가할 때마다 시계 방향으로 움직임을 의미
enum Direction: Int, CaseIterable {
    case north
    case northEast
    case east
    case southEast
    case south
    case southWest
    case west
    case northWest
}

class DetailViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var northButton: UIButton!
    @IBOutlet weak var northEastButton: UIButton!
    @IBOutlet weak var eastButton: UIButton!
    @IBOutlet weak var southEastButton: UIButton!
    @IBOutlet weak var southButton: UIButton!
    @IBOutlet weak var southWestButton: UIButton!
    @IBOutlet weak var westButton: UIButton!
    @IBOutlet weak var northWestButton: UIButton!
    
    
    
    // "칼패턴 연습하기"
    // "석상패턴 연습하기"
    var navTitle: String = ""
    
    // "biackiss_gate3_sword": 칼
    // "biackiss_gate3_statue": 석상
    var imageName: String = ""
    
    // 버튼 방향(8방향)
    let directions = Direction.allCases
    
    
    var buttons: [UIButton] = []
    
    
    
    /*
     "https://www.fmkorea.com/3607473135"를 참고하였음.
     */
    // 패턴 후보
    var patterns: [[Direction]] = [[]]
    // 정답 후보
    var answers: [[Direction]] = [[]]
    
    // 패턴
    var pattern: [Direction] = []
    // 정답
    var answerDirection: Direction?
    
    
    var style: ToastStyle = {
        ToastManager.shared.isTapToDismissEnabled = true
        ToastManager.shared.isQueueEnabled = false
        
        var style = ToastStyle()
        style.cornerRadius = 10
        style.messageAlignment = .center
        style.messageColor = .white
        style.backgroundColor = UIColor.systemGray3
        
        return style
    }()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = navTitle
        
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.image = UIImage(named: "biackiss_gate3_sword_statue_background")
        
        setPatterns()
        setAnswers()
        
        test()
    }
    
    func test() {
        print(#function)
        
        setButtons()
        
        let randomIndex = Int.random(in: 0..<patterns.count)
        // 패턴을 랜덤하게 결정
        getPattern(index: randomIndex)
        // 결정된 패턴의 정답 찾기
        getAnswer(index: randomIndex)
        // 결정된 패턴과 정답에 따라 버튼을 세팅
        activateButton()
    }
    
    func getPattern(index: Int) {
        pattern = patterns[index]
    }
    
    func getAnswer(index: Int) {
        if answers[index].count == 1 {
            answerDirection = answers[index].first!
        } else { // 특정 패턴의 정답이 2개 이상이면 정답 또한 랜덤으로 결정
            let answerDirections = answers[index]
            answerDirection = answerDirections.randomElement()
        }
    }
    
    func setPatterns() {
        if navTitle == "석상패턴 연습하기" {
            
            // 석상패턴은 총 8개
            patterns = [
                [directions[0], directions[1], directions[3], directions[5], directions[7]],
                [directions[1], directions[2], directions[4], directions[6], directions[7]],
                [directions[0], directions[1], directions[3], directions[4], directions[7]],
                [directions[0], directions[2], directions[4], directions[6], directions[7]],
                [directions[1], directions[3], directions[4], directions[5], directions[7]],
                [directions[2], directions[4], directions[5], directions[6], directions[7]],
                [directions[0], directions[3], directions[4], directions[6], directions[7]],
                [directions[1], directions[2], directions[3], directions[4], directions[7]],
            ]
            
        } else { // "칼패턴 연습하기"
            
            // 칼패턴은 총 7개
            patterns = [
                [directions[0], directions[2], directions[4], directions[6]],
                [directions[1], directions[2], directions[5], directions[6]],
                [directions[2], directions[3], directions[5], directions[6]],
                [directions[1], directions[3], directions[5], directions[7]],
                [directions[0], directions[2], directions[3], directions[5]],
                [directions[0], directions[3], directions[5], directions[6]],
                [directions[0], directions[1], directions[3], directions[5]],
            ]
        }
    }
    
    func setAnswers() {
        // 각 패턴도 정답이 다를 수 있음
        // 즉, 최종 패턴 수 = Sumation{ (패턴 자체 수) x (각 패턴 당 가능한 정답 수) }
        
        if navTitle == "석상패턴 연습하기" {
            answers = [
                [directions[0]],
                [directions[1], directions[2]],
                [directions[3]],
                [directions[7]],
                [directions[4]],
                [directions[5]],
                [directions[6]],
                [directions[3]],
            ]
        } else { // "칼패턴 연습하기"
            answers = [
                [directions[0], directions[4]],
                [directions[6]],
                [directions[3]],
                [directions[7]],
                [directions[2]],
                [directions[3]],
                [directions[1], directions[5]],
            ]
        }
        
    }
    
    func activateButton() {
        let isActiveButton = pattern.map { self.buttons[$0.rawValue] }
        isActiveButton.forEach { button in
            button.isHidden = false
            button.isEnabled = true
        }
    }
    
    @objc func checkAnswer(button: UIButton) {
        
        var message: String = ""
        if button.tag == self.answerDirection?.rawValue {
            message = "정답입니다!"
        } else {
            message = """
            오답입니다!
            선택: \(Direction(rawValue: button.tag)!) / 정답: \(answerDirection!)
            """
        }
        
        /* deactivate buttons */
        for button in self.buttons {
            button.isEnabled = false
        }
                
        self.view.makeToast(message, duration: 3.0, position: .center, title: "", image: nil, style: style) { didTap in
            self.test()
        }
    }

    func setButtons() {
    
        buttons = [
            self.northButton,
            self.northEastButton,
            self.eastButton,
            self.southEastButton,
            self.southButton,
            self.southWestButton,
            self.westButton,
            self.northWestButton,
        ]
        
        
        for (index, button) in buttons.enumerated() {
            setButtonUI(button: button, direction: Direction(rawValue: index)!)
        }
    
    }
    
    func setButtonUI(button: UIButton, direction: Direction) {
        let image = UIImage(named: self.imageName)
        button.setImage(image, for: .normal)
        button.contentMode = .scaleAspectFit
        button.isHidden = true
        button.isEnabled = false
        button.tag = direction.rawValue
        button.addTarget(self, action: #selector(checkAnswer(button:)), for: .touchUpInside)
    }
}
