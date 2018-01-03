//
//  YVideoPlayer.swift
//  ToolKit
//
//  Created by Le Viet Quang on 12/9/17.
//  Copyright © 2017 Le Viet Quang. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerView: UIView {
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    // Override UIView property
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}

protocol YVideoPlayerDelegate {
    func videoReadyToPlay()
    func videoFinishPlayed()
    func videoFailedToEnd()
}

protocol YVideoPlayerDataSource {
    func videoSkipLabelView()-> UIView
    func videoSkipLabelClick()
    func videoPlaceHolder()->UIView
}

class YVideoPlayer: NSObject {
    var delegate:YVideoPlayerDelegate?
    var datasource:YVideoPlayerDataSource?
    var first_frame:String?
    var last_frame:String?
    var player_view:PlayerView?
    private var video_frame:CGRect = UIScreen.main.bounds
    private var is_auto_play:Bool = true
    private var is_loop:Bool = false
    private var video_source:String = ""
    private var video_duration:Double = 0
    @objc private var video_player:AVPlayer?
    private var first_frame_view:UIView?
    private var last_frame_view:UIView?
    private var skip_label_view:UIView?
    private var video_placeholder_view:UIView?
    
    init(VideoSource video_source:String, VideoView player_view:PlayerView, VideoLoop is_video_loop:Bool , VideoAutoPlay is_auto_play:Bool){
        super.init()
        self.video_source = video_source.isEmpty == true ? "" : video_source
        self.player_view = player_view
        self.is_loop = is_video_loop
        self.is_auto_play = is_auto_play
        
        if let playView = self.player_view, let playerLayer = playView.layer as? AVPlayerLayer {
            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        }
        
        self.createVideoFromSource()
    }
    
    deinit {
        self.video_player?.pause()
        self.video_player?.seek(to: kCMTimeZero)
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: self.video_player?.currentItem)
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemFailedToPlayToEndTime, object: self.video_player?.currentItem)
    }
    
    func settingVideo(FirstFrame first_frame:String?, LastFrame last_frame:String?){
        if let value1 = first_frame {
            self.first_frame = value1
        }
        else {
            self.first_frame = ""
        }
        
        if let value2 = last_frame {
            self.last_frame = value2
        }
        else {
            self.last_frame = ""
        }
        
        if let first_frame_url = self.first_frame {
            if(!first_frame_url.isEmpty){
                self.first_frame_view = UIView()
                self.first_frame_view?.frame = (self.player_view?.frame)!
                let fimg_view = UIImageView.init(frame: (self.player_view?.frame)!)
                if let fimg = UIImage.imageFrom(Path: first_frame_url){
                    fimg_view.image = fimg
                }
                self.first_frame_view?.addSubview(fimg_view)
                self.player_view?.addSubview(self.first_frame_view!)
            }
        }
        
        if let last_frame_url = self.last_frame {
            if !last_frame_url.isEmpty {
                self.last_frame_view = UIView()
                self.last_frame_view?.frame = (self.player_view?.frame)!
                let limg_view = UIImageView.init(frame: (self.player_view?.frame)!)
                if let limg = UIImage.imageFrom(Path: last_frame_url) {
                    limg_view.image = limg
                }
                self.last_frame_view?.addSubview(limg_view)
                self.last_frame_view?.isHidden = true
                self.player_view?.addSubview(self.last_frame_view!)
            }
        }
        
        self.player_view?.sendSubview(toBack: self.last_frame_view!)
        self.player_view?.bringSubview(toFront: self.first_frame_view!)
        
        self.videoSkipLabelView()
        
        if self.is_auto_play == false {
            self.videoPlaceHolder()
        }
    }
    
    func playVideo(){
        self.video_player?.play()
        self.perform(#selector(hideFirstFrameView), with: nil, afterDelay: 0.1)
    }
    
    @objc private func hideFirstFrameView(){
        if let view = self.first_frame_view {
            view.isHidden = true
        }
    }
    
    private func createVideoFromSource(){
        let file = self.video_source.components(separatedBy: ".")
        
        guard let path = Bundle.main.path(forResource: file[0], ofType:file[1]) else {
            debugPrint( "\(file.joined(separator: ".")) not found")
            return
        }
        let item = AVPlayerItem(url: URL(fileURLWithPath: path))
        self.video_player = AVPlayer(playerItem: item)
        self.registerNotification(playerItem: item)
        
        self.player_view?.player = self.video_player
        
        if self.is_auto_play == true {
            self.video_player?.play()
            self.perform(#selector(hideFirstFrameView), with: nil, afterDelay: 0.1)
        }
        
    }
    
    private func registerNotification(playerItem:AVPlayerItem){
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: playerItem, queue: nil) { (sender) in
            DispatchQueue.main.async {
                self.playerDidReachEnd(sender: sender)
            }
        }
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemFailedToPlayToEndTime, object: playerItem, queue: nil) { (sender) in
            DispatchQueue.main.async {
                self.didFailedToEnd(sender: sender)
            }
        }
    }
    
    @objc private func playerDidReachEnd(sender:Notification){
        if let view = self.last_frame_view {
            view.isHidden = false
            self.player_view?.bringSubview(toFront: view)
        }
        
        if self.is_loop == false {
            self.delegate?.videoFinishPlayed()
        }
        else {
            self.video_player?.seek(to: kCMTimeZero)
            self.video_player?.play()
        }
    }
    
    @objc private func didFailedToEnd(sender:Notification){
        if let view = self.last_frame_view {
            view.isHidden = false
            self.player_view?.bringSubview(toFront: view)
        }
        self.delegate?.videoFailedToEnd()
    }
    
    @objc private func videoSkipLabelView(){
        if let skip_view = self.datasource?.videoSkipLabelView() {
            let skip_button = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: skip_view.frame.size.width, height: skip_view.frame.size.height))
            skip_button.backgroundColor = UIColor.clear
            skip_view.addSubview(skip_button)
            skip_button.addTarget(self, action: #selector(videoSkipLabelClick), for: .touchUpInside)
            self.skip_label_view = skip_view
            self.player_view?.addSubview(self.skip_label_view!)
            
            self.player_view?.sendSubview(toBack: self.last_frame_view!)
            self.player_view?.bringSubview(toFront: self.first_frame_view!)
            self.player_view?.bringSubview(toFront: self.skip_label_view!)
        }
    }
    
    @objc private func videoPlaceHolder()
    {
        if let holder_view = self.datasource?.videoPlaceHolder() {
            let holder_button = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: holder_view.frame.size.width, height: holder_view.frame.size.height))
            holder_button.backgroundColor = UIColor.clear
            holder_view.addSubview(holder_button)
            holder_button.addTarget(self, action: #selector(videoPlaceHolerClick), for: .touchUpInside)
            self.video_placeholder_view = holder_view
            self.player_view?.addSubview(self.video_placeholder_view!)
            
            self.player_view?.sendSubview(toBack: self.last_frame_view!)
            self.player_view?.bringSubview(toFront: self.first_frame_view!)
            self.player_view?.bringSubview(toFront: self.skip_label_view!)
            self.player_view?.bringSubview(toFront: self.video_placeholder_view!)
        }
    }
    
    @objc private func videoSkipLabelClick(){
        self.video_player?.pause()
        self.video_player?.seek(to: kCMTimeZero)
        if let view = self.last_frame_view {
            view.isHidden = false
            self.player_view?.bringSubview(toFront: view)
        }
        self.datasource?.videoSkipLabelClick()
    }
    
    @objc private func videoPlaceHolerClick(){
        self.video_player?.seek(to: kCMTimeZero)
        self.video_player?.play()
        self.video_placeholder_view?.isHidden = true
    }
    
    private func configLayerView(){
        
    }
}
