% Copyright

interface damageGraph supports control
    open core

predicates
    makeDamageMap : (tuple{boolean SA, boolean WF, boolean CAW, boolean LinkedOverlapping, integer Count, shipClass::fleetBuilderStats Ship}*,
        integer Trials).

end interface damageGraph
