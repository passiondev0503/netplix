//
//  Netplix.swift
//  Netplix
//
//  Created by Octo Siswardhono on 10/11/23.
//

import Foundation

final class NetplixModule {
    static var bundle = Bundle(for: NetplixModule.self)
    static var container: NetplixContainer!
}

public class NetplixBase: NSObject {
    var container: NetplixContainer!
    
    public override init() {
        super.init()
        setup()
    }
    
    func setup(){
    }
}

public final class Netplix: NetplixBase {
    override func setup() {
        if container == nil {
            container = NetplixContainer()
            .register(Bundle.self, instance: Bundle.main)
            .register(NetplixRouter.self) { (resolver) -> NetplixRouter in
                return NetplixRouter(resolver: resolver)
            }
            .register(INetplixService.self) { (resolver) -> INetplixService in
                return NetplixService()
            }
            .register(Reachability.self) { (resolver) -> Reachability in
                return Reachability()
            }
        }
        NetplixModule.container = container
    }
}
