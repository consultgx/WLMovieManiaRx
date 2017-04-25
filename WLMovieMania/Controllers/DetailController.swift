//
//  DetailController.swift
//  WLMovieMania
//
//  Created by Dhall, Gautam on 4/21/17.
//  Copyright © 2017 GD. All rights reserved.
//

import Foundation

import UIKit

var STARTY = 20
var YGAP = 60
var YGAPMARGIN = 10
var XMARGIN = 20
var CONTROLHT = YGAP - YGAPMARGIN
var SCROLLCSIZE = 1000

class DetailController: UIViewController,UIScrollViewDelegate {
    
    var scrollView: UIScrollView!
    var containerView : UIView!
    
    var overview:UITextView!
    var original_title:UILabel!
    var original_language:UILabel!
    var titleLbl:UILabel!
    var popularity:UILabel!
    var vote_count:UILabel!
    var vote_average:UILabel!
    
    var detail: Movie?
    
    func configureView() {
        if let m = detail {
            titleLbl!.text = "Title: " + m.title
            original_language!.text = "Language: " + m.original_language
            original_title!.text = "Original Title: " + m.original_title
            overview!.text = "Overview: " + m.overview
            popularity!.text = "Popularity: " + String(m.popularity)
            vote_count!.text = "Vote Count: " + String(m.vote_count)
            vote_average!.text = "Vote Average: " + String(m.vote_average)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        configureView()
    }
    
    func label()->UILabel{
        let lbl = UILabel()
        lbl.textColor = UIColor.purple
        lbl.numberOfLines = 4
        lbl.textAlignment = .left
        lbl.lineBreakMode = .byWordWrapping
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.sizeToFit()
        lbl.layer.borderColor = UIColor.gray.cgColor
        lbl.layer.borderWidth = 0.3
        lbl.layer.cornerRadius = 10
        return lbl
    }
    func txtView() -> UITextView{
        let tv = UITextView()
        tv.textColor = UIColor.purple
        tv.textAlignment = .left
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.sizeToFit()
        tv.layer.borderColor = UIColor.gray.cgColor
        tv.layer.borderWidth = 0.3
        tv.layer.cornerRadius = 10
        tv.bounces = true
        tv.isScrollEnabled = true
        return tv
    }
    
    func setUp(){
        scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.white
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 2.0
        scrollView.bounces = true
        scrollView.contentSize = CGSize(width: Int(UIScreen.main.bounds.size.width), height: SCROLLCSIZE)
        containerView = UIView()
        containerView.backgroundColor = UIColor.clear
        scrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: view.bounds.size.height)
        containerView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
        scrollView.addSubview(containerView)
        self.view.addSubview(scrollView)
        
        var yFactor = STARTY
            
        titleLbl = label()
        titleLbl.frame = CGRect(x:XMARGIN,y:yFactor,width:Int(UIScreen.main.bounds.size.width)-2*XMARGIN,height:CONTROLHT)
        containerView.addSubview(titleLbl)
        yFactor += YGAP
        
        original_title = label()
        original_title.frame = CGRect(x:XMARGIN,y:yFactor,width:Int(UIScreen.main.bounds.size.width)-2*XMARGIN,height:CONTROLHT)
        containerView.addSubview(original_title)
        yFactor += YGAP

        original_language = label()
        original_language.frame = CGRect(x:XMARGIN,y:yFactor,width:Int(UIScreen.main.bounds.size.width)-2*XMARGIN,height:CONTROLHT)
        containerView.addSubview(original_language)
        yFactor += YGAP
        
        popularity = label()
        popularity.frame = CGRect(x:XMARGIN,y:yFactor,width:Int(UIScreen.main.bounds.size.width)-2*XMARGIN,height:CONTROLHT)
        containerView.addSubview(popularity)
        yFactor += YGAP
      
        vote_count = label()
        vote_count.frame = CGRect(x:XMARGIN,y:yFactor,width:Int(UIScreen.main.bounds.size.width)-2*XMARGIN,height:CONTROLHT)
        containerView.addSubview(vote_count)
        yFactor += YGAP
        
        vote_average = label()
        vote_average.frame = CGRect(x:XMARGIN,y:yFactor,width:Int(UIScreen.main.bounds.size.width)-2*XMARGIN,height:CONTROLHT)
        containerView.addSubview(vote_average)
        yFactor += YGAP
       
        overview = txtView()
        overview.frame = CGRect(x:XMARGIN,y:yFactor,width:Int(UIScreen.main.bounds.size.width)-2*XMARGIN,height:CONTROLHT + 300)
        containerView.addSubview(overview)
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

