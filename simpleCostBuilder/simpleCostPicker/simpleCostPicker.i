% Copyright

interface simpleCostPicker supports control
    open core

predicates
    addShipList : (tuple{integer Min, integer Max, shipClass::fleetBuilderStats}*).

predicates
    getFleetRange : () -> tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}*.
    getTotalCost : () -> integer.

end interface simpleCostPicker
