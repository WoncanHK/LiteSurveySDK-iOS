//
//  ViewController.swift
//  LiteSurveySDK-Demo
//
//  Created by Woncan on 2024/11/7.
//

import UIKit
import LiteSurvey

class ViewController: UIViewController {

    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var powerLabel: UILabel!
    
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var accuracyLabel: UILabel!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var portTextField: UITextField!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var mountPointTextField: UITextField!
    @IBOutlet weak var ntripSwitch: UISwitch!
    
    @IBOutlet weak var firmwareUpgradeTipsLable: UILabel!
    
    var liteSurveyDevice: LiteSurveyDevice?
    var locationModel: LiteSurveyLocationModel?
    var deviceInfoModel: LiteSurveyDeviceInfoModel?
    var batteryInfoModel: BatteryInfoModel?
    var laserState:Bool = false
    var rtcmState:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = LiteSurveyDeviceScanner.shared.connectAvailableEaAccessory(delegate: self)
        //Log
        LiteSurveyDevice.setLoggingLevel(level: .debug)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.addressTextField.resignFirstResponder()
        self.portTextField.resignFirstResponder()
        self.accountTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        self.mountPointTextField.resignFirstResponder()
    }
    
    // MARK: start
    public func startListening() {
        toSearch()
    }
    
    // MARK: end
    public func endListening() {
        if liteSurveyDevice != nil {
            toDisconnect()
        }
        liteSurveyDevice = nil
    }
    
    // MARK: search device
    public func toSearch() {
        LiteSurveyDeviceScanner.shared.startScan(delegate: self)
    }
    
    // MARK: disconnect
    public func toDisconnect() {
        liteSurveyDevice?.disconnect()
    }
    
    func setData(){
        deviceNameLabel.text = self.liteSurveyDevice?.displayName
        powerLabel.text = "\(batteryInfoModel?.percentageRemaining ?? 0)%"
        var stateDesc = "Single"
        switch self.locationModel?.fixStatus {
        case .fixed:
            stateDesc = "Fixed"
        case .DGNSS:
            stateDesc = "DGNSS"
        case .float:
            stateDesc = "Float"
        default:
            break
        }
        accuracyLabel.text = stateDesc
        var latitudeDirection = ""
        var longitudeDiretion = ""
        if self.locationModel!.coordinate.latitude > 0 {
            latitudeDirection = "N"
        }else{
            latitudeDirection = "S"
        }
        if self.locationModel!.coordinate.longitude > 0 {
            longitudeDiretion = "E"
        }else{
            longitudeDiretion = "W"
        }
        let lat = String(format: "%.9f", self.locationModel!.coordinate.latitude)
        let log = String(format: "%.9f", self.locationModel!.coordinate.longitude)
        self.latitudeLabel.text = "\(lat)° \(latitudeDirection)"
        self.longitudeLabel.text = "\(log)° \(longitudeDiretion)"
        let alitude = String(format: "%.2fm", self.locationModel!.altitude)
        self.altitudeLabel.text = alitude
    }

    @IBAction func searchDevicesEvent(_ sender: Any) {
        startListening()
    }
    
    @IBAction func disconnectNtripEvent(_ sender: Any) {
        self.liteSurveyDevice?.stopNtripConnection()
    }
   
    
    @IBAction func setGnssSystemsEvent(_ sender: Any) {
        self.liteSurveyDevice?.setGnssSystems(enableGPS: false,enableGLONASS: true,enableGALILEO: false,enableQZSS: false,enableBeidou: false)
    }
    
    
    @IBAction func ntripConnectSwitchValueChangeEvent(_ sender: UISwitch) {
        if sender.isOn {
            if self.addressTextField.text!.count > 0 , self.portTextField.text!.count > 0,self.passwordTextField.text!.count > 0 ,self.accountTextField.text!.count > 0 ,self.mountPointTextField.text!.count > 0{
                let model = NtripAccountModel()
                model.address = self.addressTextField.text!
                model.port = Int32(Int(self.portTextField.text!) ?? 8002)
                model.username = self.accountTextField.text!
                model.password = self.passwordTextField.text!
                model.mountpoint = self.mountPointTextField.text!
                self.liteSurveyDevice?.startNtripConnection(ntripAccount: model, transmitNmeaPosition: true)
            }else{
                self.ntripSwitch.isOn = false
            }
        }else{
            self.liteSurveyDevice?.stopNtripConnection()
        }
    }
    
    @IBAction func nmeaGSAOutputSwitchValueChangeEvent(_ sender: UISwitch) {
        self.liteSurveyDevice?.setNmeaOutput(nmeaType: NmeaType.GSA, enable: sender.isOn)
    }
    
    @IBAction func nmeaGSVOutputSwitchValueChangeEvent(_ sender: UISwitch) {
        self.liteSurveyDevice?.setNmeaOutput(nmeaType: NmeaType.GSV, enable: sender.isOn)
    }
    
    @IBAction func nmeaVTGOutputSwitchValueChangeEvent(_ sender: UISwitch) {
        self.liteSurveyDevice?.setNmeaOutput(nmeaType: NmeaType.VTG, enable: false)
    }
    
    @IBAction func LaserSwitchValueChangeEvent(_ sender: UISwitch) {
        self.liteSurveyDevice?.setLaserState(enable: sender.isOn)
    }
    
    @IBAction func IMUSwitchValueChangeEvent(_ sender: UISwitch) {
        if sender.isOn {
            self.liteSurveyDevice?.setImuOutput(rateMillis: 100)
        }
    }
    
    @IBAction func RTCMOutputSwitchValueChangeEvent(_ sender: UISwitch) {
        if !sender.isOn{
            self.liteSurveyDevice?.disableRtcmOutput()
        }else{
            self.liteSurveyDevice?.enableRtcmOutput(rtcmMessageNumbers: [1074,1084,1094,1114,1124])
        }
    }
    
    @IBAction func getNtripMountpointEvent(_ sender: Any) {
        if self.addressTextField.text!.count > 0 , self.portTextField.text!.count > 0{
            self.liteSurveyDevice?.queryNtripMountpoint(address: self.addressTextField.text!, port: Int(self.portTextField.text!) ?? 0)
        }
    }
    
    @IBAction func firmwareUpgradeQueryEvent(_ sender: Any) {
        self.liteSurveyDevice?.queryFirmwareUpgrade()
    }
}

// MARK: LiteSurveyDeviceDelegate
extension ViewController: LiteSurveyDeviceDelegate {
    
    // MARK: Receive Data
    func deviceDidConnect(device: LiteSurveyDevice) {
        
        switch device.deviceType {
        case .GnssReceiver:
            liteSurveyDevice = device
        default:
            break
        }
    }
    
    // MARK: Device disconnect
    func deviceDidDisconnect(device: LiteSurveyDevice) {
        print("deviceDidDisconnect")
        if (device == liteSurveyDevice){
            liteSurveyDevice = nil
        }
        
    }
    
    // MARK: Receive Location
    func didReceiveLocation(_ location: LiteSurveyLocationModel) {
        locationModel = location
        setData()
    }
    
    // MARK: Receive DeviceInfo
    func didReceiveDeviceInfo(device: LiteSurveyDevice, deviceInfo: LiteSurveyDeviceInfoModel) {
        deviceInfoModel = deviceInfo
        print(deviceInfo.serialNumber)
    }
    
    // MARK: Receive BatteryInfo
    func didReceiveBatteryInfo(_ batteryInfo: BatteryInfoModel) {
        batteryInfoModel = batteryInfo
    }
    
    // MARK: Receive Nmea
    func didReceiveNmeaMessage(_ nmeaMessage: String) {
    }
    
    // MARK: Receive SatelliteInfo
    func didReceiveSatelliteInfo(_ satelliteInfoList: [SatelliteInfoModel]) {
    }
    
    // MARK: Receive RtcmMessage
    func didReceiveRtcmMessage(_ rtcmMessage: Data) {
    }
    
    
    // MARK: Receive Mountpoint
    func ntripMountpointQueryDidFinishWithResult(_ mountpointList: [String]) {
        self.mountPointTextField.text = mountpointList.first
    }
    
    // MARK: Receive MountpointError
    func ntripMountpointQueryDidFailWithError(_ errorMessage: String) {
    }
    
    // MARK: Receive newFirmwareAvailable
    func didReceiveFirmwareUpgradeAvailability(_ newFirmwareAvailable: Bool) {
        DispatchQueue.main.async {
            self.firmwareUpgradeTipsLable.text = newFirmwareAvailable ? "New firmware available" : "Firmware upgrade not available"
        }
    }
    
    // MARK: Receive firmwareUpgrade progressPercentage
    func firmwareUpgradeDidProgress(_ progressPercentage: Int) {
    }
    
    // MARK: Receive firmwareUpgrade errorMessage
    func firmwareUpgradeDidFailWithError(_ errorMessage: String) {
    }
    
    // MARK: Receive ntrip Connection Status
    func ntripConnectionStatusDidChange(_ ntripConnectionStatus: NtripConnectionStatus) {
        switch ntripConnectionStatus {
        case .success:
            
            break
        case .socketClosed:
            break
        case .failed:
            break
        default:
            break
        }
    }
    
    // MARK: Receive ntrip Connection errorMessage
    func ntripConnectionDidFailWithError(_ errorMessage: String) {
        self.ntripSwitch.isOn = false
    }
    
}
