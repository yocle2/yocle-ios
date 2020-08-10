
iOSMp3Recorder
==============
https://github.com/chbuxing1011/iOSMp3Recorder

AVAudioRecorder + lame Mp3 Encoder

##This demo shows:

1.Choose the audio format (MP4AAC, PCM, LoseLess …. )

2.Change the output, Speaker or mic( ear pod ).

3.Convert the Linear PCM To Mp3

##Reference:

http://www.cocoachina.com/bbs/read.php?tid=82730&keyword=lame

http://stackoverflow.com/questions/1022992/how-to-get-avaudioplayer-output-to-the-speaker


## by alantypoon 20190126

[cannot compile libmp3lame.a under x86_64]
http://www.itdaan.com/blog/2018/02/15/7eae3d87247ccbc7104cc670770381a0.html
http://sourceforge.net/projects/lame/files/lame/3.99/
https://github.com/kewlbear/lame-ios-build
extract all the files to lame like this
root
	- build-lame.sh
	- lame/

execute build-lame.sh

[crash when recording]

打開info.plist表 添加  Privacy - Photo Library Additions Usage Description  這個權限並在 value 添加説明 “APP訪問你的相冊 請允許”  再運行就OK了
https://hk.saowen.com/a/75a3aab702d8589c431124a973424dbc376983e2f927df31b4f0d0b08f297cf9

This app has crashed because it attempted to access privacy-sensitive data without a usage description. The app’s Info.plist must contain an NSPhotoLibraryUsageDescription key with a string value explaining to the user how the app uses this data.
http://www.cnblogs.com/Rong-Shengcom/p/5962850.html

Key        :  Privacy - Microphone Usage Description    
Value    :  $(PRODUCT_NAME) microphone use
https://iosdevcenters.blogspot.com/2016/09/infoplist-privacy-settings-in-ios-10.html
