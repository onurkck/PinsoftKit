//
//  Logger.swift
//  PSKit
//
//  Created by Onur Küçük on 11.04.2022.
//

import UIKit
import Foundation

open class Logger: NSObject {
    private weak var timer: Timer?
    private let notificationCenter = NotificationCenter.default
    private var isGestureAdded = false
    private var serviceCompleted = false
    private var newLogBatch: LogBatch = LogBatch()
    private var newLogModel: LogModel = LogModel()
    private var newScreenLog: ScreenLog = ScreenLog()
    private var heatMapLog: [HeatMapLog] = [HeatMapLog]()

    private var deviceModel: String {
        var utsnameInstance = utsname()
        uname(&utsnameInstance)
        let optionalString: String? = withUnsafePointer(to: &utsnameInstance.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }
        return optionalString ?? "N/A"
    }
    override init() {
        super.init()
        let screenSize = UtilityHelper.getScreenSize()
        newLogBatch.osVersion = UtilityHelper.getOSVersion()
        newLogBatch.appName = UtilityHelper.getAppName()
        newLogBatch.appVersion = UtilityHelper.getAppVersion()
        newLogBatch.deviceId = UtilityHelper.getDeviceId()
        newLogBatch.deviceModel = UtilityHelper.getDeviceModel()
        newLogBatch.screenWidth = Int(screenSize.width)
        newLogBatch.screenHeight = Int(screenSize.height)
        checkLastLogBatch()
    }
    
    private func checkLastLogBatch(){
        if let logBatch = LogHelper.getLogBatch() {
            callService(for: logBatch)
        }
    }
    
    func configure(){
        setTimer()
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appTerminated), name: UIApplication.willTerminateNotification, object: nil)
    }
    
    private func setTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(collectScreenInfo), userInfo: nil, repeats: true)
    }
    
    @objc private func collectScreenInfo(){
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
            let window = UIApplication
                .shared
                .connectedScenes
                .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                .first { $0.isKeyWindow }
            self.addGesture(to: window)
            if let v = window?.visibleViewController {
                let className = DataHelper.extractVCName(from: NSStringFromClass(type(of: v)))
                if LogHelper.getLastKownVC() != className {
                    self.addNewScreenLog(screenName: className)
                }
            }
        }
    }
    
    private func addNewScreenLog(screenName: String){
        if let index = newLogBatch.logModels.firstIndex(where: {$0.screenName == screenName}) {
            newScreenLog.endTime = UtilityHelper.getCurrentDateString()
            newScreenLog.screenHeatMapPoints = heatMapLog.filter({$0.screenName == screenName})
            newLogBatch.logModels[index].screenLogs.append(newScreenLog)
            newScreenLog = ScreenLog()
            heatMapLog = [HeatMapLog]()
        }else {
            newScreenLog.screenName = screenName
            newScreenLog.startTime = UtilityHelper.getCurrentDateString()
            newLogModel.screenName = screenName
            newLogBatch.logModels.append(newLogModel)
            printLoggerInformations()
        }
        LogHelper.setLastKnown(vcName: screenName)
    }
    
    func printLoggerInformations(){
        print("LogBatch/ deviceModel: \(newLogBatch.deviceModel ?? "")")
        print("LogBatch/ deviceId: \(newLogBatch.deviceId ?? "")")
        print("LogBatch/ osVersion: \(newLogBatch.osVersion ?? "")")
        print("LogBatch/ appName: \(newLogBatch.appName ?? "")")
        print("LogBatch/ appVersion: \(newLogBatch.appVersion ?? "")")
        print("LogBatch/ screenWidth: \(newLogBatch.screenWidth ?? 0)")
        print("LogBatch/ screenHeight: \(newLogBatch.screenHeight ?? 0)")
        print("LogBatch/ numberOfLogModels: \(newLogBatch.logModels.count)")
        newLogBatch.logModels.forEach { logModel in
            print(" LogModel/ screenName: \(logModel.screenName ?? "")")
            print(" LogModel/ numberOfScreenLog: \(logModel.screenLogs.count)")
            logModel.screenLogs.forEach { screenLog in
                print("     ScreenLog/ screenName: \(screenLog.screenName ?? "")")
                print("     ScreenLog/ startTime: \(screenLog.startTime ?? "")")
                print("     ScreenLog/ endTime: \(screenLog.endTime ?? "")")
                print("     ScreenLog/ numberOfHeatMapPoints: \(screenLog.screenHeatMapPoints?.count ?? 0)")
            }
        }
    }
    
    private func addGesture(to window: UIWindow?){
        if !self.isGestureAdded {
            let tapGesture = UITapGestureRecognizer(target: self, action: nil)
            tapGesture.numberOfTapsRequired = 1
            tapGesture.delegate = self
            window?.addGestureRecognizer(tapGesture)
            self.isGestureAdded = true
        }
    }
    
    
    private func saveLogBatch(){
        LogHelper.set(logBatch: newLogBatch)
        callService(for: newLogBatch)
    }
    
    private func callService(for logBatch: LogBatch){
        //FIXME: - Service staffs.
        //FIXME: - Clear log batch if success
        
    }

    @objc private func appMovedToBackground(){
        saveLogBatch()
        notificationCenter.addObserver(self, selector: #selector(appBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        timer?.invalidate()
    }
    @objc private func appBecomeActive(){
        checkLastLogBatch()
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        configure()
    }
    @objc private func appTerminated(){
        LogHelper.set(logBatch: newLogBatch)
        timer?.invalidate()
        notificationCenter.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIApplication.willTerminateNotification, object: nil)
    }
}

extension Logger: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        heatMapLog.append(HeatMapLog(screenName: LogHelper.getLastKownVC(),
                                     isPortrait: UtilityHelper.isPortrait(),
                                     clickTime: UtilityHelper.getCurrentDateString(),
                                     xPoint: Int(touch.location(in: gestureRecognizer.view).x),
                                     yPoint: Int(touch.location(in: gestureRecognizer.view).y)))

        return true
    }
}
