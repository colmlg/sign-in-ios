import RxSwift

class ModuleService: BaseAPIService {
    
    func getModules() -> Observable<[Module]> {
        return get(endPoint: "/module")
    }
    
    func getModuleDetails(id: String) -> Observable<GetModuleResponse> {
        return get(endPoint: "/module/" + id)
    }
}
