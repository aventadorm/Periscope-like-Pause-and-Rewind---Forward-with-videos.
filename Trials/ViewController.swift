//
//  ViewController.swift
//  Trials
//
//  Created by Mayur Phadte on 04/03/18.
//  Copyright © 2018 Mayur Phadte. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let videoURL = URL(string : "http://www.sample-videos.com/video/mp4/480/big_buck_bunny_480p_30mb.mp4")
        //let videoURL = Bundle.main.url(forResource: "2", withExtension: "mp4")!
        let videoViewController = VideoViewController(videoURL: videoURL!)
        present(videoViewController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

