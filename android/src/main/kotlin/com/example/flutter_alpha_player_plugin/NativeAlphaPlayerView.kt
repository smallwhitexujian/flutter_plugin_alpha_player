// package com.example.flutter_alpha_player_plugin

// import android.content.Context
// import android.view.View
// import com.tencent.qgame.animplayer.AnimConfig
// import com.tencent.qgame.animplayer.AnimView
// import com.tencent.qgame.animplayer.inter.IAnimListener
// import com.tencent.qgame.animplayer.util.ScaleType
// import io.flutter.plugin.common.BinaryMessenger
// import io.flutter.plugin.common.MethodCall
// import io.flutter.plugin.common.MethodChannel
// import io.flutter.plugin.platform.PlatformView
// import kotlinx.coroutines.Dispatchers
// import kotlinx.coroutines.GlobalScope
// import kotlinx.coroutines.launch
// import java.io.File

// internal class NativeAlphaPlayerView(binaryMessenger: BinaryMessenger,
//                                      context: Context?,
//                                      id:Int?,
//                                      createParams:Map<String,Any>?):MethodChannel.MethodCallHandler , PlatformView {
//     private val mContext: Context? = context

//     private val vapView: AnimView? = context?.let { AnimView(it) }
//     private lateinit var channel : MethodChannel
//     private var methodResult: MethodChannel.Result? = null

//     init {
//         //填充模式
//         vapView?.setScaleType(ScaleType.FIT_XY)
//         vapView?.setAnimListener(object :IAnimListener{
//             override fun onFailed(errorType: Int, errorMsg: String?) {
//                 GlobalScope.launch(Dispatchers.Main) {
//                     methodResult?.success(HashMap<String,String>().apply {
//                         put("status","failure")
//                         put("errorMeg",errorMsg?:"unknown error")
//                     })
//                 }
//             }

//             override fun onVideoComplete() {
//                 GlobalScope.launch(Dispatchers.Main) {
//                     methodResult?.success(HashMap<String, String>().apply {
//                         put("status", "complete")
//                     })
//                 }
//             }

//             override fun onVideoDestroy() {
//             }

//             override fun onVideoRender(frameIndex: Int, config: AnimConfig?) {
//             }

//             override fun onVideoStart() {
//             }
//         })
//         channel = MethodChannel(binaryMessenger,"flutter_alpha_player_plugin")
//         channel.setMethodCallHandler(this);
//     }

//     //向原生发送消息，
//     override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
//         methodResult = result
//         when(call.method){
//             "playPath"->{
//                 call.argument<String>("path")?.let {
//                     vapView?.startPlay(File(it))
//                 }
//             }
//             "playAsset"->{
//                 call.argument<String>("asset")?.let {
//                     mContext?.assets?.let { it1 -> vapView?.startPlay(it1, "flutter_assets/$it") }
//                 }
//             }

//             "stop"->{
//                 call.argument<String>("asset")?.let {
//                     vapView?.stopPlay()
//                 }
//             }
//         }
//     }

//     override fun getView(): View? {
//         return vapView
//     }

//     override fun dispose() {
//         channel.setMethodCallHandler(null)
//     }

// }