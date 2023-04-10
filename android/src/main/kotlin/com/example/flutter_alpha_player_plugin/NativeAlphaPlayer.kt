package com.example.flutter_alpha_player_plugin

import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.platform.PlatformView
import android.view.View
import android.content.Context
import com.example.flutter_alpha_player_plugin.VideoGiftView

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


    init{
        mContext?.let{
            alphaPlayer = VideoGiftView(it)
            alphaPlayer.initPlayerController(it)
            alphaPlayer.attachView()

            channel = MethodChannel(binaryMessenger, "flutter_alpha_player_plugin")
            channel.setMethodCallHandler(this);
        }
    }

    //MethodChannel 回调
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result){
        methodResult =result
        if(call.method.toString() == "play"){
            val path  = call.argument<String>("path")
            val name = call.argument<String>("name")
            val isLooper = call.argument<Boolean>("looping")
            alphaPlayer.startVideoGift(path ,name,2,8,isLooper)
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