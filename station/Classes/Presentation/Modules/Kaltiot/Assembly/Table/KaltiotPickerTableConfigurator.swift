import Foundation

class KaltiotPickerTableConfigurator {
    func configure(view: KaltiotPickerTableViewController) {
        let r = AppAssembly.shared.assembler.resolver

        let router = KaltiotPickerRouter()
        router.transitionHandler = view

        let presenter = KaltiotPickerPresenter()
        presenter.view = view
        presenter.router = router
        presenter.activityPresenter = r.resolve(ActivityPresenter.self)
        presenter.errorPresenter = r.resolve(ErrorPresenter.self)
        presenter.keychainService = r.resolve(KeychainService.self)
        presenter.realmContext = r.resolve(RealmContext.self)
        presenter.ruuviNetworkKaltiot = r.resolve(RuuviNetworkKaltiot.self)
        presenter.ruuviTagService = r.resolve(RuuviTagService.self)
        presenter.ruuviTagPersistence = r.resolve(RuuviTagPersistence.self)

        view.output = presenter
    }
}