% Copyright

interface fleetPicker supports control
    open core

predicates
    addShipList : (shipClass::fleetBuilderStats*).
    addModelList : (tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}*).

predicates
    getFleetRange : () -> tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}*.

end interface fleetPicker
