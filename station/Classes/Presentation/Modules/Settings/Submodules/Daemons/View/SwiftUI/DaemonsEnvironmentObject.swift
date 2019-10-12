#if canImport(SwiftUI) && canImport(Combine)
import Combine
import SwiftUI

@available(iOS 13, *)
final class DaemonsEnvironmentObject: ObservableObject  {
    @Published var daemons = [DaemonsViewModel]()
}
#endif