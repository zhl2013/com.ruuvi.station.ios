import Foundation
import Future

class RuuviTagTankCoordinator: RuuviTagTank {

    var sqlite: RuuviTagPersistence!
    var realm: RuuviTagPersistence!
    var idPersistence: IDPersistence!
    var backgroundPersistence: BackgroundPersistence!
    var connectionPersistence: ConnectionPersistence!

    func create(_ ruuviTag: RuuviTagSensor) -> Future<Bool, RUError> {
        if let mac = ruuviTag.mac, let uuid = ruuviTag.luid {
            idPersistence.set(mac: mac, for: uuid)
        }
        if ruuviTag.mac != nil {
            return sqlite.create(ruuviTag)
        } else {
            return realm.create(ruuviTag)
        }
    }

    func update(_ ruuviTag: RuuviTagSensor) -> Future<Bool, RUError> {
        if ruuviTag.mac != nil {
            return sqlite.update(ruuviTag)
        } else {
            return realm.update(ruuviTag)
        }
    }

    func delete(_ ruuviTag: RuuviTagSensor) -> Future<Bool, RUError> {
        let promise = Promise<Bool, RUError>()
        if ruuviTag.mac != nil {
            sqlite.delete(ruuviTag).on(success: { [weak self] success in
                if let luid = ruuviTag.luid {
                    self?.backgroundPersistence.deleteCustomBackground(for: luid)
                    self?.connectionPersistence.setKeepConnection(false, for: luid)
                } else if let mac = ruuviTag.mac {
                    // FIXME:
//                    self?.backgroundPersistence.deleteCustomBackground(for: mac)
//                    self?.connectionPersistence.setKeepConnection(false, for: mac)
                } else {
                    assertionFailure()
                }
                promise.succeed(value: success)
            }, failure: { error in
                promise.fail(error: error)
            })
        } else {
            realm.delete(ruuviTag).on(success: { [weak self] success in
                if let luid = ruuviTag.luid {
                    self?.backgroundPersistence.deleteCustomBackground(for: luid)
                    self?.connectionPersistence.setKeepConnection(false, for: luid)
                } else if let mac = ruuviTag.mac {
                    // FIXME:
//                    self?.backgroundPersistence.deleteCustomBackground(for: mac)
//                    self?.connectionPersistence.setKeepConnection(false, for: mac)
                } else {
                    assertionFailure()
                }
                promise.succeed(value: success)
            }, failure: { error in
                promise.fail(error: error)
            })
        }
        return promise.future

    }

    func create(_ record: RuuviTagSensorRecord) -> Future<Bool, RUError> {
        if record.mac != nil {
            return sqlite.create(record)
            // FIXME check if luid for ruuviTagId is ok
        } else if let mac = idPersistence.mac(for: record.ruuviTagId.luid) {
            return sqlite.create(record.with(mac: mac))
        } else {
            return realm.create(record)
        }
    }

    func create(_ records: [RuuviTagSensorRecord]) -> Future<Bool, RUError> {
        let promise = Promise<Bool, RUError>()
        let sqliteRecords = records.filter({ $0.mac != nil })
        let realmRecords = records.filter({ $0.mac == nil })
        let sqliteOperation = sqlite.create(sqliteRecords)
        let realmOpearion = realm.create(realmRecords)
        Future.zip(sqliteOperation, realmOpearion).on(success: { _ in
            promise.succeed(value: true)
        }, failure: { error in
            promise.fail(error: error)
        })
        return promise.future
    }

    func deleteAllRecords(_ ruuviTagId: String) -> Future<Bool, RUError> {
        let promise = Promise<Bool, RUError>()
        let sqliteOperation = sqlite.deleteAllRecords(ruuviTagId)
        let realmOpearion = realm.deleteAllRecords(ruuviTagId)
        Future.zip(sqliteOperation, realmOpearion).on(success: { _ in
            promise.succeed(value: true)
        }, failure: { error in
            promise.fail(error: error)
        })
        return promise.future
    }

     func deleteAllRecords(_ ruuviTagId: String, before date: Date) -> Future<Bool, RUError> {
        let promise = Promise<Bool, RUError>()
        let sqliteOperation = sqlite.deleteAllRecords(ruuviTagId, before: date)
        let realmOpearion = realm.deleteAllRecords(ruuviTagId, before: date)
        Future.zip(sqliteOperation, realmOpearion).on(success: { _ in
            promise.succeed(value: true)
        }, failure: { error in
            promise.fail(error: error)
        })
        return promise.future
    }
}
