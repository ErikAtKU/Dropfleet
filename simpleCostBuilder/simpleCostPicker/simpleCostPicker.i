% Copyright

interface simpleCostPicker supports control
    open core

predicates
    addShipList : (shipClass::fleetBuilderStats*).

predicates
    getFleetRange : () -> tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}*.
    getTotalCost : () -> integer.

end interface simpleCostPicker
