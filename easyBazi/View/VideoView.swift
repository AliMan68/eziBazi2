//
//  VideoView.swift
//  
//
//  Created by AliArabgary on 10/20/18.
//


import UIKit
import AVKit
import AVFoundation

class VideoView: UIView {
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    var isLoop: Bool = false
    var observer:NSKeyValueObservation?

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func configure(url: String) {
      print("this URL from Game Dtails ===>\(url)")
        if let videoURL = URL(string: url) {
            player = AVPlayer(url: videoURL)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = bounds
            playerLayer?.videoGravity = AVLayerVideoGravity.resize
            if let playerLayer = self.playerLayer {
                layer.addSublayer(playerLayer)
            }
            
            //let playerItem = player?.currentItem
//            playerItem?.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
//            playerItem?.addObserver(self, forKeyPath: "playbackBufferFull", options: .new, context: nil)
//            playerItem?.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)

            NotificationCenter.default.addObserver(self, selector: #selector(reachTheEndOfTheVideo(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
            
        }
    }
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//         if object is AVPlayerItem {
//        switch keyPath{
//        case "playbackBufferEmpty"?:
//            print("Buffering")
//
//        case "playbackLikelyToKeepUp"?:
//            print("NO Buffer 1")
//            // Hide loader
//
//        case "playbackBufferFull"?:
//            print("NO Buffer 2")
//        default: break
//
//            }
//        }
//    }
//
    func play() {
        if player?.timeControlStatus != AVPlayerTimeControlStatus.playing {
            print("Video is playing")
            player?.play()
        }
    }
    
    func pause() {
        player?.pause()
    }
    
    func stop() {
        print("Video Stoped !!")
        player?.pause()
        player?.seek(to: kCMTimeZero)
        //deleteObserver()

    }
    func deleteObserver(){
                player?.currentItem?.removeObserver(self, forKeyPath: "playbackBufferEmpty")
                player?.currentItem?.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
                player?.currentItem?.removeObserver(self, forKeyPath: "playbackBufferFull")
    }
    
    @objc func reachTheEndOfTheVideo(_ notification: Notification) {
        print(" reach The EndOf Video")
        if isLoop {
            player?.pause()
            player?.seek(to: kCMTimeZero)
            player?.play()
        }
    }
}
