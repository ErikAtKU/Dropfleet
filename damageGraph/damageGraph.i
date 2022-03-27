% Copyright

interface damageGraph supports control
    open core

predicates
    makeDamageMap : (
        tuple{boolean SA, boolean WF, boolean CAW, boolean Launch, boolean LinkedOverlapping, integer Count, shipClass::fleetBuilderStats Ship}*,
        shipClass::fleetBuilderStats DefendShip, integer Trials).

end interface damageGraph
