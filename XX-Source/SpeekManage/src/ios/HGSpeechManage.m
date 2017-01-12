//
//  SpeekManage.m
//  HHVideo
//
//  Created by 朱子豪 on 2016/12/29.
//  Copyright © 2016年 朱子豪. All rights reserved.
//

#import "HGSpeechManage.h"
#import <Speech/Speech.h>
#import <AVFoundation/AVFoundation.h>
@interface HGSpeechManage()<SFSpeechRecognizerDelegate>
//siri_audio文件夹
@property(nonatomic,copy)NSMutableString *path;
@property(nonatomic,copy)NSString *currentName;
//是否继续设备准备
@property(nonatomic,assign)BOOL isPrepare;
//录音设备
@property(nonatomic,strong)AVAudioEngine *audioEngine;
@property(nonatomic,strong)AVAudioRecorder *audioRecorder;
@property(nonatomic,strong)SFSpeechRecognizer *recogin;

@property(nonatomic,strong)SFSpeechAudioBufferRecognitionRequest *request;
@property(nonatomic,strong)SFSpeechRecognitionTask *task;
//队列
@property(nonatomic,strong)NSOperationQueue *recoreQueue;
@end
@implementation HGSpeechManage
-(void)pluginInitialize{
    self.path = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"speech_audio"] mutableCopy];
    NSFileManager *manager =[NSFileManager defaultManager];
    [manager createDirectoryAtPath:self.path withIntermediateDirectories:YES attributes:nil error:nil];
}
-(NSOperationQueue *)recoreQueue{
    if(!_recoreQueue){
        _recoreQueue=[[NSOperationQueue alloc]init];
    }
    return _recoreQueue;
}
-(NSDictionary *)getAudioSetting{
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    //设置录音格式
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话采样率，对于一般录音已经够了
    [dicM setObject:@(8000) forKey:AVSampleRateKey];
    //设置通道,这里采用单声道
    [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
    //每个采样点位数,分为8、16、24、32
    [dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    //....其他设置等
    return dicM;
}
-(NSURL *)getSavePath{
    _currentName=[NSString stringWithFormat:@"%ld.caf",(long)[[NSDate new] timeIntervalSince1970]];
    NSString *urlStr=[self.path stringByAppendingPathComponent:_currentName];
    NSURL *url=[NSURL fileURLWithPath:urlStr];
    return url;
}
-(AVAudioRecorder *)audioRecorder{
    if (!_audioRecorder) {
        //创建录音文件保存路径
        NSURL *url=[self getSavePath];
        //创建录音格式设置
        NSDictionary *setting=[self getAudioSetting];
        //创建录音机
        _audioRecorder=[[AVAudioRecorder alloc]initWithURL:url settings:setting error:nil];
        //        _audioRecorder.delegate=self;
    }
    return _audioRecorder;
}
-(BOOL)systemVersion:(CDVInvokedUrlCommand *)cmd{
#if TARGET_IPHONE_SIMULATOR
    CDVPluginResult *resu = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"不能再模拟器上运行"];
    [self.commandDelegate sendPluginResult:resu callbackId:cmd.callbackId];
    return NO;
#define SIMULATOR_TEST
#else
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    if([phoneVersion doubleValue]<10.0){
        NSString *reson = @"必须在ios10以上";
        CDVPluginResult *resu = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:reson];
        [self.commandDelegate sendPluginResult:resu callbackId:cmd.callbackId];
        return NO;
    }
    return YES;
#endif
}
-(BOOL)isRecogin:(CDVInvokedUrlCommand *)cmd{
    if(self.request){
        CDVPluginResult *resu = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"正在录音"];
        [self.commandDelegate sendPluginResult:resu callbackId:cmd.callbackId];
        return YES;
    }
    return NO;
}

-(void)supportLanages:(CDVInvokedUrlCommand *)cmd;{
    NSMutableArray *lans =[NSMutableArray array];
    [[SFSpeechRecognizer supportedLocales] enumerateObjectsUsingBlock:^(NSLocale * _Nonnull obj, BOOL * _Nonnull stop) {
        [lans addObject:obj.localeIdentifier];
    }];
    CDVPluginResult *resu = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:lans];
    [self.commandDelegate sendPluginResult:resu callbackId:cmd.callbackId];
}
-(void)requestSpeech:(CDVInvokedUrlCommand *)cmd{
    if(![self systemVersion:cmd]){return;}
    if([self isRecogin:cmd]){return;}
    
    SFSpeechRecognizerAuthorizationStatus auth = [SFSpeechRecognizer authorizationStatus];
    
    if(auth == SFSpeechRecognizerAuthorizationStatusAuthorized){
        [self prepare:cmd];
        CDVPluginResult *resu = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"获取权限成功"];
        [self.commandDelegate sendPluginResult:resu callbackId:cmd.callbackId];
        return;
    }
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        NSString *reson;
        if(status == SFSpeechRecognizerAuthorizationStatusAuthorized){
            reson =@"有权限";
            [self prepare:cmd];
            CDVPluginResult *resu = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"获取权限成功"];
            [self.commandDelegate sendPluginResult:resu callbackId:cmd.callbackId];
        }else{
            CDVPluginResult *resu = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"获取权限失败"];
            [self.commandDelegate sendPluginResult:resu callbackId:cmd.callbackId];
        }
    }];
    
}

-(void)prepare:(CDVInvokedUrlCommand *)cmd{
    self.audioEngine = [[AVAudioEngine alloc]init];
    NSString *lan = cmd.arguments[0];
    if(lan==nil){lan=@"en_US";}
    NSLocale *local = [[NSLocale alloc]initWithLocaleIdentifier:lan];
    self.recogin = [[SFSpeechRecognizer alloc]initWithLocale:local];
    [self audioRecorder];
    self.recogin.queue = self.recoreQueue;
    self.recogin.delegate=self;
    self.isPrepare=YES;
    
}
-(void)clear:(CDVInvokedUrlCommand *)cmd{
    if([self.audioEngine isRunning]){
        CDVPluginResult *resu = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"正在speech"];
        [self.commandDelegate sendPluginResult:resu callbackId:cmd.callbackId];
        return;
    }
    self.audioEngine = nil;
    self.recogin =nil;
    self.audioRecorder=nil;
    self.isPrepare=NO;
    CDVPluginResult *resu = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"清除成功"];
    [self.commandDelegate sendPluginResult:resu callbackId:cmd.callbackId];
}
-(void)startSpeech:(CDVInvokedUrlCommand *)cmd{
    if(![self systemVersion:cmd]){return;}
    if(!self.isPrepare){
        [self _clear:CDVCommandStatus_ERROR ID:cmd.callbackId errMsg:@"设备还没准备 prepare必须被调用"];
        return;
    }
    if(self.request){
        CDVPluginResult *resu = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"正在录音,待会再试"];
        [self.commandDelegate sendPluginResult:resu callbackId:cmd.callbackId];
        return;
    }
    SFSpeechRecognizerAuthorizationStatus auth = [SFSpeechRecognizer authorizationStatus];
    if(auth != SFSpeechRecognizerAuthorizationStatusAuthorized){
        //没还有进行权限请求
        [self _clear:CDVCommandStatus_ERROR ID:cmd.callbackId errMsg:@"需要进行权限请求"];
        return;
    }
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error;
    [session setCategory:AVAudioSessionCategoryRecord error:&error];
    [session setMode:AVAudioSessionModeMeasurement error:&error];
    [session setActive:YES error:&error];
    if(error){
        [self _clear:CDVCommandStatus_ERROR ID:cmd.callbackId errMsg:@"录音设备初始化失败"];
        [session setActive:NO error:nil];
        return ;
    }
    
    self.request = [[SFSpeechAudioBufferRecognitionRequest alloc]init];
    
    if(![self.audioEngine inputNode]){
        [self _clear:CDVCommandStatus_ERROR ID:cmd.callbackId errMsg:@"无输入设备"];
        [session setActive:NO error:nil];
        return;
    }
    if(!self.request){
        [self _clear:CDVCommandStatus_ERROR ID:cmd.callbackId errMsg:@"request 请求失败"];
        [session setActive:NO error:nil];
        return ;
    }
    //音频文件
    
    
    self.request.shouldReportPartialResults = YES;
    //创建识别任务
    self.task= [self.recogin recognitionTaskWithRequest:self.request resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        //数据处理
        if(result){
            NSString *content = result.bestTranscription.formattedString;
            
            CDVPluginResult *resu = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:content];
            [resu setKeepCallbackAsBool:YES];
            [self.commandDelegate sendPluginResult:resu callbackId:cmd.callbackId];
            if(result.isFinal){
                
                NSMutableDictionary *result=[NSMutableDictionary dictionary];
                [result setObject:@"录音结束" forKey:@"reason"];
                [result setObject:self.currentName forKey:@"fileName"];
                
                CDVPluginResult *resu = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
                [self.commandDelegate sendPluginResult:resu callbackId:cmd.callbackId];
                
            }
        }
        if(error){
            [self _clear:CDVCommandStatus_ERROR ID:cmd.callbackId errMsg:@"出现错误"];
        }
        if(error || result.isFinal){
            [session setActive:NO error:nil];
            [self.audioEngine stop];
            [self.audioRecorder stop];
            [self.audioEngine.inputNode removeTapOnBus:0];
            self.task = nil;
            self.request =nil;
            self.audioRecorder=nil;
        }
    }];
    //获得录音文件
    AVAudioFormat *format = [self.audioEngine.inputNode outputFormatForBus:0];
    
    __weak  SFSpeechAudioBufferRecognitionRequest*weakReq =self.request;
    
    [self.audioEngine.inputNode installTapOnBus:0 bufferSize:1024 format:format block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        [weakReq appendAudioPCMBuffer:buffer];
    }];
    
    //准备
    [self.audioEngine prepare];
    //开始录音
    [self.audioEngine startAndReturnError:&error];
    [self.audioRecorder record];
    if(error){
        weakReq=nil;
        [session setActive:NO error:nil];
        [self _clear:CDVCommandStatus_ERROR ID:cmd.callbackId errMsg:@"启动失败"];
    }
    
}
-(void)endSpeech:(CDVInvokedUrlCommand *)cmd{
    if(self.audioEngine.isRunning){
        [self.audioEngine stop];
        [self.request endAudio];
        [self.audioRecorder stop];
        [self _clear:CDVCommandStatus_OK ID:cmd.callbackId errMsg:@"关闭成功"];
    }
}
-(void)getAudioFile:(CDVInvokedUrlCommand *)cmd{
    NSString *fileName = cmd.arguments[0][0];
    BOOL isdata = [cmd.arguments[0][1] boolValue];
    if(fileName == nil){
        [self _clear:CDVCommandStatus_ERROR ID:cmd.callbackId errMsg:@"必须参数为'fileName'"];
        return;
    }
    NSString *path = [self.path stringByAppendingPathComponent:fileName];
    NSFileManager *manager = [NSFileManager defaultManager];
    if(![manager fileExistsAtPath:path]){
        [self _clear:CDVCommandStatus_ERROR ID:cmd.callbackId errMsg:@"指定的文件不存在"];
        return;
    }
    if(!isdata){
        //返回fileURL
        NSURL *a = [NSURL fileURLWithPath:path];
        CDVPluginResult *res = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:a.absoluteString];
        [self.commandDelegate sendPluginResult:res callbackId:cmd.callbackId];
        return;
    }
    //返回base64
    [self.commandDelegate runInBackground:^{
        NSData *data  = [NSData dataWithContentsOfFile:path];
        NSString *base = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        CDVPluginResult *res = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:base];
        [self.commandDelegate sendPluginResult:res callbackId:cmd.callbackId];
        
    }];
}
//文件操作
-(void)operatefiles:(CDVInvokedUrlCommand *)cmd{
    NSDictionary *dic = cmd.arguments[0];
    NSArray *files = dic[@"files"];
    int opera = [dic[@"operation"] intValue];
    //得到文件
    NSFileManager *manager = [NSFileManager defaultManager];
    if(opera==1){
        NSMutableArray *fileName = [[manager contentsOfDirectoryAtPath:self.path error:nil] mutableCopy];
        //        .DS_Store
        [fileName removeObject:@".DS_Store"];
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:fileName];
        [self.commandDelegate sendPluginResult:result callbackId:cmd.callbackId];
        return;
    }
    //删除文件
    NSArray *targets;
    if(opera == 2){
        if(files.count>=1){
            targets = files;
        }else{
            targets = [manager contentsOfDirectoryAtPath:self.path error:nil];
        }
        __block NSError *err;
        [targets enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [manager removeItemAtPath:[self.path stringByAppendingPathComponent:obj] error:&err];
            if(err){
                *stop=YES;
                [self _clear:CDVCommandStatus_ERROR ID:cmd.callbackId errMsg:[NSString stringWithFormat:@"%@ 删除失败",obj]];
            }
        }];
        if(!err){
            [self _clear:CDVCommandStatus_OK ID:cmd.callbackId errMsg:@"删除完成"];
        }
        return;
    }
    [self _clear:CDVCommandStatus_ERROR ID:cmd.callbackId errMsg:@"操作码错误 "];
}

-(void)_clear:(CDVCommandStatus)statu  ID:(NSString *)ID errMsg:(NSString *)msg{
    CDVPluginResult *resu = [CDVPluginResult resultWithStatus:statu messageAsString:msg];
    [self.commandDelegate sendPluginResult:resu callbackId:ID];
    
    [self.audioEngine stop];
    [self.audioRecorder stop];
    self.request=nil;
    self.task=nil;
    self.audioRecorder=nil;
}

#pragma -mark 代理
-(void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available{
    
}
@end
