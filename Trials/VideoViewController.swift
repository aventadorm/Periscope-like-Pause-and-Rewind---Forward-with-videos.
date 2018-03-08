//
//  VideoViewController.swift
//  Trials
//
//  Created by Mayur Phadte on 04/03/18.
//  Copyright © 2018 Mayur Phadte. All rights reserved.
//

import UIKit
import AVFoundation

class VideoViewController: UIViewController {
    
    private var videoURL: URL!
    var initialLocation : CGPoint = CGPoint(x:0.0,y:0.0)
    var yDifference : CGFloat = 0.0
    
    private var assetGenerator : AVAssetImageGenerator!
    private let rewindPreviewImageView = UIImageView()
    private let rewindCurrentTimeLabel = UILabel()
    var rewindPreviewMaxHeight: CGFloat = 112.0 {
        didSet {
            assetGenerator.maximumSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: rewindPreviewMaxHeight)
        }
    }
    
    private var asset: AVURLAsset!
    private var playerItem: AVPlayerItem!
    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer!
    
    
    private var longPressGestureRecognizer: UILongPressGestureRecognizer!
    private let rewindDimView = UIVisualEffectView()
    
    
    
    // MARK: - Constructors
    init(videoURL: URL) {
        super.init(nibName: nil, bundle: nil)
        
        self.videoURL = videoURL
        
        asset = AVURLAsset(url: videoURL)
        playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        NotificationCenter.default.addObserver(self, selector: #selector(VideoViewController.playerDidFinishPlaying),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        assetGenerator = AVAssetImageGenerator(asset: asset)
        assetGenerator.maximumSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: rewindPreviewMaxHeight)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = UIColor.black
        view.layer.addSublayer(playerLayer)
        longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(VideoViewController.longPressed))
        view.addGestureRecognizer(longPressGestureRecognizer)
        
        view.addSubview(rewindDimView)
        
    }
    func helloWorld(){
        print("Hello")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        player.play()
        
    }
    
    // MARK: - Methods
    func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: - Layout
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        playerLayer.frame = view.bounds
        rewindDimView.frame = view.bounds
        
    }

    
    
  
    @objc func playerDidFinishPlaying(note: NSNotification) {
        //print("Video Finished")
        player.seek(to: kCMTimeZero)
        player.play()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func longPressed(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            
            initialLocation = gesture.location(in: gesture.view!)
            print("Started at \(playerItem.currentTime().seconds)")
            
            player.pause()
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseOut], animations: {
                self.rewindDimView.effect = UIBlurEffect(style: .dark)
            }, completion: nil)
        } else if gesture.state == .changed {
            let changedLocation = gesture.location(in: gesture.view!)
            yDifference = changedLocation.y - initialLocation.y;
            yDifference /= (10)
            
            print("Zoom = \(yDifference)")
            
        } else {
            let finalLocation = gesture.location(in: gesture.view!)
            var xDifference = finalLocation.x - initialLocation.x;
            xDifference /= (10)
            var addTime = Float64(yDifference * xDifference * 0.008)
            print(addTime)
            let seekTime = CMTimeMakeWithSeconds(CMTimeGetSeconds(playerItem.currentTime()) + addTime, playerItem.currentTime().timescale)
            playerItem.seek(to: seekTime, completionHandler: nil)
            print("Seeking to \(seekTime)")
            player.play()
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseOut], animations: {
                self.rewindDimView.effect = nil
            }, completion: nil)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
