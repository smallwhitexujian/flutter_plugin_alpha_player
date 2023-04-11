package com.example.flutter_alpha_player_plugin

import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.platform.PlatformView
import android.view.View
import android.content.Context
import android.util.Log
import android.os.Looper
import android.os.Handler
import com.example.flutter_alpha_player_plugin.VideoGiftView
import com.ss.ugc.android.alpha_player.IPlayerAction
import com.ss.ugc.android.alpha_player.model.ScaleType
import com.ss.ugc.android.alpha_player.IMonitor

///原生界面需要实现PlatformView
internal class NativeAlphaPlayer(
    binaryMessenger: BinaryMessenger,
    context: Context?,
    id:Int?,
    createParams:Map<String,Any>?):MethodChannel.MethodCallHandler,PlatformView{
        
    private var methodResult: MethodChannel.Result? = null
    private val mContext :Context? = context
    private lateinit var alphaPlayer: VideoGiftView
    private lateinit var channel : MethodChannel
    private var handler : Handler = Handler(Looper.getMainLooper())


    init{
        mContext?.let{
            alphaPlayer = VideoGiftView(it)
            alphaPlayer.initPlayerController(it,object :IPlayerAction{
                override fun endAction() {
                    _onFlutterMethodCall("endAction","{\"code\":\"${-1}\",\"fun\":\"endAction\"}")
                }
        
                override fun onVideoSizeChanged(videoWidth: Int, videoHeight: Int, scaleType: ScaleType) {
                    _onFlutterMethodCall("onVideoSizeChanged", "{\"code\":\"${0}\",\"fun\":\"onVideoSizeChanged\",\"videoWidth\":\"${videoWidth}\",\"videoHeight\":\"${videoHeight}\",\"scaleType\":\"${scaleType}\"}")
                }
        
                override fun startAction() {
                    _onFlutterMethodCall("startAction","{\"code\":\"${0}\",\"fun\":\"startAction\"}")
                }
            },
            object :IMonitor{
                override fun monitor(
                        result: Boolean,
                        playType: String,
                        what: Int,
                        extra: Int,
                        errorInfo: String
                    ) {
                        _onFlutterMethodCall("monitor", "{\"code\":\"${0}\",\"fun\":\"monitor\",\"result\":\"${result}\",\"playType\":\"${playType}\",\"what\":\"${what}\",\"extra\":\"${extra}\",\"errorInfo\":\"${errorInfo}\"}")
                    }
                }
            )
            alphaPlayer.attachView()

            channel = MethodChannel(binaryMessenger, "flutter_alpha_player_plugin")
            channel.setMethodCallHandler(this);
        }
    }

    //MethodChannel 回调 Flutter-》Android
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result){
        methodResult =result
        when(call.method){
            //播放视频
            "playVideo"->{
                val path  = call.argument<String>("path")
                val name = call.argument<String>("name")
                val isLooper = call.argument<Boolean>("looping")
                alphaPlayer.startVideoGift(path ,name,2,8,isLooper)
                result.success(0)
            }
            //同步视图
            "attachView"->{
                alphaPlayer.attachView()
                result.success(0)
            }
            //移除视图
            "detachView"->{
                alphaPlayer.detachView()
                result.success(0)
            }
            //释放播放器
            "releasePlayer"->{
                alphaPlayer.releasePlayerController();
                result.success(0)
            }
        }
    }
    // android -> flutter 
    /**
     * @param method 方法名称，唯一关系绑定，
     * @param arguments 参数或者数据 目前默认json
     */
    private fun _onFlutterMethodCall(method:String,arguments:Any){
        handler.post {
            channel.invokeMethod(method, arguments)
        }
    }

    //获取View
    override fun getView(): View? { 
        return alphaPlayer;
    }

    //销毁View
    override fun dispose() { 
        alphaPlayer.detachView()
        alphaPlayer.releasePlayerController()
    }
}