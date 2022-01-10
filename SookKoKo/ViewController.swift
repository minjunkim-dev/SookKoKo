//
//  ViewController.swift
//  InForLoA
//
//  Created by bene9275 on 2022/01/10.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var statuePatternButton: UIButton!
    @IBOutlet weak var swordPatternButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.backButtonTitle = "돌아가기"
        navigationController?.navigationBar.tintColor = .white
        
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.image = UIImage(named: "biackiss_gate3_sword_statue_background")
        
        setPracticeButtonUI(button: statuePatternButton, title: "석상패턴 연습하기", titleColor: .white, backgroundColor: .tintColor)
        statuePatternButton.addTarget(self, action: #selector(practiceButtonClicked(button:)), for: .touchUpInside)
        
        setPracticeButtonUI(button: swordPatternButton, title: "칼패턴 연습하기", titleColor: .white, backgroundColor: .tintColor)
        swordPatternButton.addTarget(self, action: #selector(practiceButtonClicked(button:)), for: .touchUpInside)
        
    }
    
    @objc func practiceButtonClicked(button: UIButton) {
        
        // 1. 스토리보드 특정
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // 2. 스토리보드 내 많은 뷰컨트롤러 중, 전환하고자 하는 뷰컨트롤러 가져오기
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        let buttonTitle = button.currentTitle?.trimmingCharacters(in: .whitespaces)
        vc.navTitle = buttonTitle ?? ""
        
        if buttonTitle == "석상패턴 연습하기" {
            vc.imageName = "biackiss_gate3_statue"
        } else { // "칼패턴 연습하기"
            vc.imageName = "biackiss_gate3_sword"
        }
                
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setPracticeButtonUI(button: UIButton, title: String, titleColor: UIColor, backgroundColor: UIColor) {
        
        let margin = "   "
        button.setTitle(margin + title + margin, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .heavy)
        button.setTitleColor(titleColor, for: .normal)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 10
    }
}

