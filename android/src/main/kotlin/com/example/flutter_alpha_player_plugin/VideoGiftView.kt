package com.example.flutter_alpha_player_plugin

import android.annotation.SuppressLint
import android.content.Context
import android.text.TextUtils
import android.util.AttributeSet
import android.util.Log
import android.widget.FrameLayout
import android.widget.RelativeLayout
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.LifecycleRegistry
import com.ss.ugc.android.alpha_player.IMonitor
import com.ss.ugc.android.alpha_player.IPlayerAction
import com.ss.ugc.android.alpha_player.controller.IPlayerController
import com.ss.ugc.android.alpha_player.controller.PlayerController
import com.ss.ugc.android.alpha_player.model.AlphaVideoViewType
import com.ss.ugc.android.alpha_player.model.Configuration
import com.ss.ugc.android.alpha_player.model.DataSource
import com.ss.ugc.android.alpha_player.model.ScaleType
import com.ss.ugc.android.alpha_player.player.DefaultSystemPlayer
import java.io.File

/**
 * 视频动画展示界面
 */
@SuppressLint("ResourceType")
class VideoGiftView: FrameLayout,LifecycleOwner {

    constructor(context: Context):super(context)

    constructor(context: Context,attributeSet: AttributeSet?):super(context,attributeSet)

    constructor(context: Context, attributeSet: AttributeSet?=null, defStyleAttr:Int=0):super(context,attributeSet,defStyleAttr)
    companion object{
        const val TAG ="VideoGiftView"
    }

    private var mVideoContainer :RelativeLayout
    private val mRegistry = LifecycleRegistry(this)
    private lateinit var mPlayerController: IPlayerController


    init {
        //创建一个空的布局
        mVideoContainer = RelativeLayout(context)
        mVideoContainer.layoutParams =RelativeLayout.LayoutParams(
            android.view.ViewGroup.LayoutParams.MATCH_PARENT,
            android.view.ViewGroup.LayoutParams.MATCH_PARENT)
        removeAllViews()
        addView(mVideoContainer)
    }

    private var playListener: IPlayerAction = object : IPlayerAction {
        override fun endAction() {
            Log.e(TAG, "endAction: ", )
        }

        override fun onVideoSizeChanged(videoWidth: Int, videoHeight: Int, scaleType: ScaleType) {
            Log.e(TAG, "onVideoSizeChanged: ", )
        }

        override fun startAction() {
            Log.e(TAG, "startAction: ", )
        }

    }

    //初始化播放器的控制器
    fun initPlayerController(
        context: Context,
        playerAction: IPlayerAction = playListener
    ) {
        val configuration = Configuration(context, this)
        // 支持GLSurfaceView&GLTextureView, 默认使用GLSurfaceView
        configuration.alphaVideoViewType = AlphaVideoViewType.GL_TEXTURE_VIEW
        //也可以设置自行实现的Player, demo中提供了基于ExoPlayer的实现
        mPlayerController = PlayerController.get(configuration, DefaultSystemPlayer())
        mPlayerController.setPlayerAction(playerAction)
        mPlayerController.setMonitor(object : IMonitor {
            override fun monitor(
                result: Boolean,
                playType: String,
                what: Int,
                extra: Int,
                errorInfo: String
            ) {
                Log.e(
                    TAG,
                    "call monitor(), state: $result, playType = $playType, what = $what, extra = $extra, errorInfo 错误信息展示 = $errorInfo"
                )
            }

        })
    }



    /**
     * 开始播放
     *  文件路径需要/结尾
     *
     * @param filePath 文件存放路径
     *      /data/user/0/ 应用包名/files
     *      //getApplicationContext().getFilesDir().getAbsolutePath()
     * @param fileName 文件名称
     *  根据手机当前属于横屏和竖屏，进行视频压缩比
     * @param portraitPath 设置竖向参数 2
     * @param landscapePath 设置横向参数 8
     * @param isLooping = false 是否循环，默认不循环，
     */
    fun startVideoGift(filePath:String?,fileName:String?,portraitPath:Int = 2,landscapePath :Int = 8,isLooping:Boolean? = false){
        if (TextUtils.isEmpty(filePath)&& !filePath!!.endsWith(File.separator)) {
            Log.e(TAG, "startVideoGift: filePath is null or filePath is not '/' end$filePath")
            return
        }
        val name = if (fileName!!.endsWith(".mp4")){
            fileName
        } else {
            fileName.split(".mp4").toString()
        }
        //数据转化，合成播放视频，透明的数据源
        val dataSource = DataSource()
            .setBaseDir(filePath!!)
            .setPortraitPath(name, portraitPath)
            .setLandscapePath(name, landscapePath)
            .setLooping(isLooping!!)//是否循环
        startDataSource(dataSource)
    }

    //展示画面
    private fun startDataSource(dataSource: DataSource) {
        if (!dataSource.isValid()) {
            Log.e(TAG, "startDataSource: dataSource is invalid.")
        }
        mPlayerController.start(dataSource)
    }

    //同步窗体,动画站位布局填充到window
    fun attachView() {
        mPlayerController.attachAlphaView(mVideoContainer)
    }

    //移除动画窗体
    fun detachView() {
        mPlayerController.detachAlphaView(mVideoContainer)
    }

    //释放动画相关资源
    fun releasePlayerController() {
        mPlayerController.let {
            it.detachAlphaView(mVideoContainer)
            it.release()
        }
    }

    override fun getLifecycle(): Lifecycle {
       return mRegistry
    }

    override fun onAttachedToWindow() {
        super.onAttachedToWindow()
        mRegistry.currentState= Lifecycle.State.CREATED
    }

    override fun onDetachedFromWindow() {
        super.onDetachedFromWindow()
        mRegistry.currentState = Lifecycle.State.DESTROYED
    }

    override fun onWindowVisibilityChanged(visibility: Int) {
        super.onWindowVisibilityChanged(visibility)
        if (visibility == VISIBLE) {
            mRegistry.handleLifecycleEvent(Lifecycle.Event.ON_START)
            mRegistry.handleLifecycleEvent(Lifecycle.Event.ON_RESUME)
        }else if (visibility == GONE || visibility == INVISIBLE){
            mRegistry.handleLifecycleEvent(Lifecycle.Event.ON_PAUSE)
            mRegistry.handleLifecycleEvent(Lifecycle.Event.ON_STOP)
        }

    }
}

