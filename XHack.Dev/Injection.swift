
import Foundation

class SupremeResource {
    var id: Int
    var name: String
    var description: String
    init(
        id: Int,
        name: String,
        description: String
    ) {
        self.id = id
        self.name = name
        self.description = description
    }
}

class SupremeResourceBuilder {
    private var _id: Int = 0
    private var _name: String = ""
    private var _description: String = ""
    
    func id(_ value: Int) -> SupremeResourceBuilder {
        self._id = value
        return self
    }
    
    func name(_ value: String) -> SupremeResourceBuilder {
        self._name = value
        return self
    }
    
    func description(_ value: String) -> SupremeResourceBuilder {
        self._description = value
        return self
    }
    
    func build() -> SupremeResource {
        return SupremeResource(id: _id, name: _name, description: _description)
    }
}

class SupremeRepository {
    func getResource() -> SupremeResource {
        return SupremeResourceBuilder()
            .id(1)
            .name("test")
            .description("supreme description")
            .build()
    }
}

class SupremeService {
    private var _repo: SupremeRepository
    init(_ repository: SupremeRepository) {
        self._repo = repository
    }
    
    func getLatestResourceName() -> String {
        return self._repo.getResource().name
    }
}

class Program {
    func main() {
        let supremeRepository = SupremeRepository()
        let supremeService = SupremeService(supremeRepository)
        print(supremeService.getLatestResourceName())
    }
}
