import Swinject
import BTKit

class BusinessAssembly: Assembly {

    // swiftlint:disable:next function_body_length
    func assemble(container: Container) {

        container.register(AlertService.self) { r in
            let service = AlertServiceImpl()
            service.alertPersistence = r.resolve(AlertPersistence.self)
            service.calibrationService = r.resolve(CalibrationService.self)
            return service
        }.inObjectScope(.container).initCompleted { (r, service) in
            // swiftlint:disable force_cast
            let s = service as! AlertServiceImpl
            // swiftlint:enable force_cast
            s.localNotificationsManager = r.resolve(LocalNotificationsManager.self)
        }

        container.register(AppStateService.self) { r in
            let service = AppStateServiceImpl()
            service.settings = r.resolve(Settings.self)
            service.advertisementDaemon = r.resolve(RuuviTagAdvertisementDaemon.self)
            service.propertiesDaemon = r.resolve(RuuviTagPropertiesDaemon.self)
            service.webTagDaemon = r.resolve(WebTagDaemon.self)
            service.heartbeatDaemon = r.resolve(RuuviTagHeartbeatDaemon.self)
            service.pullWebDaemon = r.resolve(PullWebDaemon.self)
            service.backgroundTaskService = r.resolve(BackgroundTaskService.self)
            return service
        }.inObjectScope(.container)

        container.register(BackgroundTaskService.self) { r in
            if #available(iOS 13, *) {
                let service = BackgroundTaskServiceiOS13()
                service.webTagOperationsManager = r.resolve(WebTagOperationsManager.self)
                return service
            } else {
                let service = BackgroundTaskServiceiOS12()
                return service
            }
        }.inObjectScope(.container)

        container.register(CalibrationService.self) { r in
            let service = CalibrationServiceImpl()
            service.calibrationPersistence = r.resolve(CalibrationPersistence.self)
            service.ruuviTagPersistence = r.resolve(RuuviTagPersistence.self)
            return service
        }

        container.register(ExportService.self) { r in
            let service = ExportServiceTemp()
            service.realmContext = r.resolve(RealmContext.self)
            return service
        }

        container.register(GATTService.self) { r in
            let service = GATTServiceQueue()
            service.connectionPersistence = r.resolve(ConnectionPersistence.self)
            service.ruuviTagPersistence = r.resolve(RuuviTagPersistence.self)
            service.background = r.resolve(BTBackground.self)
            return service
        }.inObjectScope(.container)

        container.register(LocationService.self) { _ in
            let service = LocationServiceApple()
            return service
        }

        container.register(MigrationManager.self) { r in
            let manager = MigrationManagerToVIPER()
            manager.backgroundPersistence = r.resolve(BackgroundPersistence.self)
            manager.settings = r.resolve(Settings.self)
            return manager
        }

        container.register(PullWebDaemon.self) { r in
            let daemon = PullWebDaemonOperations()
            daemon.settings = r.resolve(Settings.self)
            daemon.webTagOperationsManager = r.resolve(WebTagOperationsManager.self)
            return daemon
        }.inObjectScope(.container)

        container.register(RuuviTagAdvertisementDaemon.self) { r in
            let daemon = RuuviTagAdvertisementDaemonBTKit()
            daemon.settings = r.resolve(Settings.self)
            daemon.foreground = r.resolve(BTForeground.self)
            daemon.ruuviTagPersistence = r.resolve(RuuviTagPersistence.self)
            return daemon
        }.inObjectScope(.container)

        container.register(RuuviTagHeartbeatDaemon.self) { r in
            let service = RuuviTagHeartbeatDaemonBTKit()
            service.background = r.resolve(BTBackground.self)
            service.localNotificationsManager = r.resolve(LocalNotificationsManager.self)
            service.connectionPersistence = r.resolve(ConnectionPersistence.self)
            service.ruuviTagPersistence = r.resolve(RuuviTagPersistence.self)
            service.alertService = r.resolve(AlertService.self)
            service.settings = r.resolve(Settings.self)
            service.pullWebDaemon = r.resolve(PullWebDaemon.self)
            return service
        }.inObjectScope(.container)

        container.register(RuuviTagPropertiesDaemon.self) { r in
            let daemon = RuuviTagPropertiesDaemonBTKit()
            daemon.ruuviTagPersistence = r.resolve(RuuviTagPersistence.self)
            daemon.foreground = r.resolve(BTForeground.self)
            return daemon
        }.inObjectScope(.container)

        container.register(RuuviTagService.self) { r in
            let service = RuuviTagServiceImpl()
            service.calibrationService = r.resolve(CalibrationService.self)
            service.ruuviTagPersistence = r.resolve(RuuviTagPersistence.self)
            service.backgroundPersistence = r.resolve(BackgroundPersistence.self)
            service.connectionPersistence = r.resolve(ConnectionPersistence.self)
            return service
        }

        container.register(WeatherProviderService.self) { r in
            let service = WeatherProviderServiceImpl()
            service.owmApi = r.resolve(OpenWeatherMapAPI.self)
            service.locationManager = r.resolve(LocationManager.self)
            service.locationService = r.resolve(LocationService.self)
            return service
        }

        container.register(WebTagDaemon.self) { r in
            let daemon = WebTagDaemonImpl()
            daemon.webTagService = r.resolve(WebTagService.self)
            daemon.settings = r.resolve(Settings.self)
            daemon.webTagPersistence = r.resolve(WebTagPersistence.self)
            return daemon
        }.inObjectScope(.container)

        container.register(WebTagOperationsManager.self) { r in
            let manager = WebTagOperationsManager()
            manager.alertService = r.resolve(AlertService.self)
            manager.weatherProviderService = r.resolve(WeatherProviderService.self)
            manager.webTagPersistence = r.resolve(WebTagPersistence.self)
            return manager
        }

        container.register(WebTagService.self) { r in
            let service = WebTagServiceImpl()
            service.webTagPersistence = r.resolve(WebTagPersistence.self)
            service.weatherProviderService = r.resolve(WeatherProviderService.self)
            return service
        }
    }
}
