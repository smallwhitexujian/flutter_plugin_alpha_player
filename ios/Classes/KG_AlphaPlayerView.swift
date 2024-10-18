//
//  NG_AlphaPlayerView.swift
//  AlphaPlayer
//
//  Created by ZhgSignorino on 2023/4/24.
//
import BDAlphaPlayer
import UIKit

/// 回调事件
protocol KG_AlphaPlayerCallBackActionDelegate {
    
    /// 开始播放
    func alphaPlayerStartPlay()
    
    /// 播放结束回调 isNormalFinsh 是否正常播放结束 （True 是  false 播放报错）
    func alphaPlayerDidFinishPlaying(isNormalFinsh:Bool,errorStr:String?)
    
    /// 回调每一帧的持续时间
    func videoFrameCallBack(duration:TimeInterval)
}

/// 播放器
class KG_AlphaPlayerView: UIView,BDAlphaPlayerMetalViewDelegate {

    /// 代理
    var delegate:KG_AlphaPlayerCallBackActionDelegate?
    
    /// 播放器视图
    var playerMetalView :BDAlphaPlayerMetalView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isHidden = true
        _initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func _initViews() -> Void {
        __initMetalView()
    }

    /// 初始化播放器视图
    private func __initMetalView() -> Void {
        if playerMetalView == nil {
            playerMetalView = BDAlphaPlayerMetalView(delegate: self)
            self.addSubview(playerMetalView!)
        }
    }
    
    // MARK: - BDAlphaPlayerMetalViewDelegate
    /// 播放结束回调
    func metalView(_ metalView: BDAlphaPlayerMetalView, didFinishPlayingWithError error: Error) {
        self.isHidden = true;
        if (error == nil) {
            if (delegate != nil) {
                delegate?.alphaPlayerDidFinishPlaying(isNormalFinsh: true, errorStr: nil)
            }
        }else {
            if (delegate != nil) {
                delegate?.alphaPlayerDidFinishPlaying(isNormalFinsh: false, errorStr: "播放器结束")
            }
        }
    }
    /// 回调每一帧的持续时间
    func frameCallBack(_ duration: TimeInterval) {
        if (delegate != nil) {
            delegate?.videoFrameCallBack(duration: duration)
        }
    }
    
    // MARK: - public
    
    /// 开始播放视频
     // @param filePath /data/user/0/App/gift/file
     // @param fileName 文件名字
     // @param playerOrientation 屏幕样式 （0 竖屏 1 横屏）

    func startPlayerWithFilePath(filePath:String?,fileName:String?,playerOrientation:Int) {
        if (filePath == nil || fileName == nil) {
            print("filePath or fileName is null")
            return
        }
        var name = fileName;
        if fileName?.contains(".mp4") == false {
            name = fileName! + ".mp4"
        }
        if playerMetalView == nil {
            __initMetalView()
        }
        let isExist = subStringWithFilePath(filePath: filePath!, fileName: name!);
        if isExist {
            self.isHidden = false;
            if (delegate != nil) {
                delegate?.alphaPlayerStartPlay()
            }
           _startPlayer(filePath: filePath!,playerOrientation: playerOrientation)
        }
    }
    
    /// 停止播放 -- 停止显示而不调用didFinishPlayingWithError方法，不会触发停止回调
    func stopAlphaPlayer() {
        playerMetalView?.stop()
        removeAlphaPlayerViewFromSuperView()
    }
    
    /// 通过调用didFinishPlayingWithError方法停止显示，会触发停止回调
    func playerStopWithFinishPlayingCallback() {
        playerMetalView?.stopWithFinishPlayingCallback()
    }
    
    /// 从父视图移除播放视图
    func removeAlphaPlayerViewFromSuperView() {
        playerMetalView?.removeFromSuperview()
        playerMetalView = nil
    }
    
    /// 添加播放视图到父视图
    func addAlphaPlayerViewToParentView() {
        if playerMetalView != nil {
            playerMetalView?.removeFromSuperview()
            self.addSubview(playerMetalView!)
        }else {
            __initMetalView()
        }
    }
    
    /// 当前播放的Mp4视频播放时长
    func totalDurationOfPlayingVideo() -> TimeInterval {
        if playerMetalView != nil {
            return playerMetalView?.totalDurationOfPlayingEffect() ?? 0
        }
        return 0
    }
    
    /// 播放器状态 （0 停止 1 播放）
    func currentVideoPlayState() -> Int {
        if playerMetalView?.state == BDAlphaPlayerPlayState.play {
            return 1
        }else {
            return 0
        }
    }
    
    /// Resource model for MP4.
    func playerResourceModel() -> BDAlphaPlayerResourceModel? {
        return playerMetalView?.model
    }
    
    // MARK: - private
    
    /// 开始播放 (私有方法)
    private func _startPlayer(filePath:String,playerOrientation:Int) {
        let config = BDAlphaPlayerMetalConfiguration.default()
        config.directory = filePath //路径
        config.renderSuperViewFrame = self.frame
        if playerOrientation == 0 {
            config.orientation = BDAlphaPlayerOrientation.portrait
        }else{
            config.orientation = BDAlphaPlayerOrientation.landscape
        }
        playerMetalView?.play(with: config)
    }
    
    /// 处理文件路径
    private func subStringWithFilePath(filePath:String,fileName:String) -> Bool {
        if (filePath.contains(".mp4") == true) {
            if let subIndex = filePath.lastIndex(of:"/") { /// 截取出来文件夹的路径（/data/user/0/App/gift/123456）
                let subFilePath = filePath[..<subIndex]
                let configSubFilePath = String((subFilePath.appending("/config.json")))
                let isExists = configFileIsExists(configFilePath: configSubFilePath,fileName: fileName) as Bool
                if isExists {
                    return true
                }
            }
            return false
        }else { //不包含文件具体的名字 /data/user/0/App/gift/123456
            let configSubFilePath = String((filePath.appending("/config.json")))
            let isExists = configFileIsExists(configFilePath: configSubFilePath,fileName: fileName)
            if isExists {
                return true
            }else{
                return false
            }
        }
    }
    
    ///  检测是否存在config文件
    private func configFileIsExists(configFilePath:String,fileName:String) -> Bool {
        if FileManager.default.fileExists(atPath:configFilePath) { /// 存储直接读取
            NSLog("------->%@","config存在")
//            let json_data = NSData(contentsOfFile: configFilePath)
//            if json_data != nil {
//                let configDic = jsonUnencodeMethod(data: json_data! as Data)
//                print(configDic)
//            }
            return true
        } else { /// 不存在存储 (path = heartbeats.mp4)
            let portraitDic:[String : Any] = ["align":2,"path":fileName]
            let landscapeDic:[String : Any] = ["path":fileName,"align":8]

            let configDic:[String : Any] = ["portrait":portraitDic,"landscape":landscapeDic]
            
            let json_data = jsonEncodeMethod(dic: configDic)
            
            if json_data != nil {
                json_data?.write(toFile: configFilePath, atomically: true)
                return true
            }else{
                return false
            }
        }
    }
    
    /// JSON 格式化
    private func jsonEncodeMethod(dic:Dictionary<String, Any>) -> NSData? {
        if let json_data = try? JSONSerialization .data(withJSONObject: dic, options: JSONSerialization.WritingOptions.prettyPrinted) {
            return json_data as NSData
        }
        return nil
    }
    
    /// JSON 反序列化
    private func jsonUnencodeMethod(data:Data) -> [String : Any]? {
        if let configDic = try? JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions.allowFragments) {
            return configDic as? [String : Any]
        }
        return nil
    }
    
    /// 释放播放器
    deinit {
        stopAlphaPlayer()
        removeAlphaPlayerViewFromSuperView()
    }
    
    // MARK: - lazy
    
}
