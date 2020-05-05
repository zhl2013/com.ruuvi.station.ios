import Foundation
import Future

class CalibrationServiceImpl: CalibrationService {
    var calibrationPersistence: CalibrationPersistence!

    func calibrateHumiditySaltTest(currentValue: Double, for ruuviTag: RuuviTagSensor) {
        let date = Date()
        let offset = 75.0 - currentValue
        if let luid = ruuviTag.luid {
            calibrationPersistence.setHumidity(date: date, offset: offset, for: luid)
        } else if let mac = ruuviTag.mac {
            // FIXME
//            calibrationPersistence.setHumidity(date: date, offset: offset, for: mac)
        } else {
            assertionFailure()
        }
    }

    func calibrateHumidityTo100Percent(currentValue: Double, for ruuviTag: RuuviTagSensor) {
        let date = Date()
        let offset = 100.0 - currentValue
        if let luid = ruuviTag.luid {
            calibrationPersistence.setHumidity(date: date, offset: offset, for: luid)
        } else if let mac = ruuviTag.mac {
            // FIXME
            // calibrationPersistence.setHumidity(date: date, offset: offset, for: mac)
        } else {
            assertionFailure()
        }

    }

    func cleanHumidityCalibration(for ruuviTag: RuuviTagSensor) {
        if let luid = ruuviTag.luid {
            calibrationPersistence.setHumidity(date: nil, offset: 0, for: luid)
        } else if let mac = ruuviTag.mac {
            // FIXME
            // calibrationPersistence.setHumidity(date: nil, offset: 0, for: mac)
        } else {
            assertionFailure()
        }

    }

    func humidityOffset(for luid: LocalIdentifier) -> (Double, Date?) {
        return calibrationPersistence.humidityOffset(for: luid)
    }
}
