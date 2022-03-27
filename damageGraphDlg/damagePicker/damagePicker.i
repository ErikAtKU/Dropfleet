% Copyright

interface damagePicker supports control
    open core

predicates
    addShipList : (tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}*).

predicates
    setPoints : (integer Points).

predicates
    getFleetRange : ()
        -> tuple{boolean SA, boolean WF, boolean CAW, boolean Launch, boolean LinkedOverlapping, integer Count, shipClass::fleetBuilderStats Ship}*.

end interface damagePicker
