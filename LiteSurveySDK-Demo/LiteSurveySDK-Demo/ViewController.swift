//
//  ViewController.swift
//  LiteSurveySDK-Demo
//
//  Created by Woncan on 2024/11/7.
//

import UIKit

class ViewController: UIViewController,LiteSurveyDeviceDelegate {

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
    
    var liteSurveyInterface: LiteSurveyDeviceInterface?
    var locationModel: LiteSurveyLocationModel?
    var deviceInfoModel: LiteSurveyDeviceInfoModel?
    var batteryInfoModel: BatteryInfoModel?
    var laserState:Bool = false
    var rtcmState:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        liteSurveyInterface = LiteSurveyDeviceInterface(delegate: self)
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
        if liteSurveyInterface != nil {
            toDisconnect()
        }
        liteSurveyInterface = nil
    }
    
    // MARK: search device
    public func toSearch() {
        liteSurveyInterface?.startScan()
    }
    
    // MARK: disconnect
    public func toDisconnect() {
        liteSurveyInterface?.disconnect()
    }
    
    func setData(){
        //deviceNameLabel.text = deviceInfoModel?.deviceModel ?? ""
        deviceNameLabel.text = self.liteSurveyInterface?.displayName
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
        self.liteSurveyInterface?.stopNtripConnection()
    }
   
    
    @IBAction func setGnssSystemsEvent(_ sender: Any) {
        self.liteSurveyInterface?.setGnssSystems(false,enableGLONASS: true,enableGALILEO: false,enableQZSS: false,enableBeidou: false)
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
                self.liteSurveyInterface?.startNtripConnection(model, transmitNmeaPosition: true)
            }else{
                self.ntripSwitch.isOn = false
            }
        }else{
            self.liteSurveyInterface?.stopNtripConnection()
        }
        
    }
    
    @IBAction func nmeaGSAOutputSwitchValueChangeEvent(_ sender: UISwitch) {
        self.liteSurveyInterface?.setNmeaOutput(NmeaType.GSA, enable: sender.isOn)
    }
    
    @IBAction func nmeaGSVOutputSwitchValueChangeEvent(_ sender: UISwitch) {
        self.liteSurveyInterface?.setNmeaOutput(NmeaType.GSV, enable: sender.isOn)
    }
    
    @IBAction func nmeaVTGOutputSwitchValueChangeEvent(_ sender: UISwitch) {
        self.liteSurveyInterface?.setNmeaOutput(NmeaType.VTG, enable: false)
    }
    
    @IBAction func LaserSwitchValueChangeEvent(_ sender: UISwitch) {
        self.liteSurveyInterface?.setLaserState(sender.isOn)
    }
    
    @IBAction func IMUSwitchValueChangeEvent(_ sender: UISwitch) {
        if sender.isOn {
            self.liteSurveyInterface?.setImuOutput(100)
        }
    }
    
    @IBAction func RTCMOutputSwitchValueChangeEvent(_ sender: UISwitch) {
        if !sender.isOn{
            self.liteSurveyInterface?.disableRtcmOutput()
        }else{
            self.liteSurveyInterface?.setRtcmOutput([1074,1084,1094,1114,1124])
        }
    }
    
    @IBAction func getNtripMountpointEvent(_ sender: Any) {
        if self.addressTextField.text!.count > 0 , self.portTextField.text!.count > 0{
            self.liteSurveyInterface?.queryNtripMountpoint(self.addressTextField.text!, port: self.portTextField.text!)
        }
    }
    
    @IBAction func firmwareUpgradeQueryEvent(_ sender: Any) {
        self.liteSurveyInterface?.queryFirmwareUpgrade()
    }
}

// MARK: LiteSurveyDeviceDelegate
extension ViewController {
    
    // MARK: Receive Data
    func deviceDidConnect() {
        print("deviceDidConnect")
    }
    
    // MARK: Device disconnect
    func deviceDidDisconnect() {
        print("deviceDidDisconnect")
    }
    
    // MARK: Receive Location
    func didReceiveLocation(_ location: LiteSurveyLocationModel!) {
        locationModel = location
        setData()
    }
    
    // MARK: Receive DeviceInfo
    func didReceiveDeviceInfo(_ deviceInfo: LiteSurveyDeviceInfoModel!) {
        deviceInfoModel = deviceInfo
    }
    
    // MARK: Receive BatteryInfo
    func didReceiveBatteryInfo(_ batteryInfo: BatteryInfoModel!) {
        batteryInfoModel = batteryInfo
    }
    
    // MARK: Receive Nmea
    func didReceiveNmeaMessage(_ nmeaMessage: String!) {
        //print("nmeaMessage:\(nmeaMessage!)")
    }
    
    // MARK: Receive SatelliteInfo
    func didReceiveSatelliteInfo(_ satelliteInfoList: [SatelliteInfoModel]!) {
        
//        for model in satelliteInfoList {
//            print("satelliteInfo GnssSystem:\(model.system)")
//        }
    }
    
    // MARK: Receive RtcmMessage
    func didReceiveRtcmMessage(_ rtcmMessage: Data!) {
        //print("rtcmMessage:\(rtcmMessage!)")
    }
    
    func didReceiveImuData(_ imuInfo: ImuInfoModel!) {
        //print("\(imuInfo!)")
    }
    
    // MARK: Receive Mountpoint
    func ntripMountpointQueryDidFinish(withResult mountpointList: [String]!) {
        self.mountPointTextField.text = mountpointList.first
    }
    
    // MARK: Receive MountpointError
    func ntripMountpointQueryDidFailWithError(_ errorMessagre: String!) {
        print("ntripMountpointQueryDidFailWithError:\(errorMessagre!)")
    }
    
    // MARK: Receive newFirmwareAvailable
    func didReceiveFirmwareUpgradeAvailability(_ newFirmwareAvailable: Bool) {
        print("firmwareUpgradeAvailability:\(newFirmwareAvailable)")
        DispatchQueue.main.async {
            self.firmwareUpgradeTipsLable.text = newFirmwareAvailable ? "New firmware available" : "Firmware upgrade not available"
        }
    }
    
    // MARK: Receive firmwareUpgrade progressPercentage
    func firmwareUpgradeDidProgress(_ progressPercentage: Int32) {
        print("firmwareUpgradeprogressPercentage:\(progressPercentage)%")
    }
    
    // MARK: Receive firmwareUpgrade errorMessage
    func firmwareUpgradeDidFailWithError(_ errorMessage: String!) {
        print("firmwareUpgradeDidFailWithError:\(errorMessage!)")
    }
    
    // MARK: Receive ntrip Connection Status
    func ntripConnectionStatusDidChange(_ ntripConnectionStatus: NtripConnectionStatus) {
        print("ntripConnectionStatusDidChange:\(ntripConnectionStatus)")
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
    func ntripConnectionDidFailWithError(_ errorMessage: String!) {
        print("ntripConnectionDidFailWithError:\(errorMessage!)")
        self.ntripSwitch.isOn = false
    }
}
