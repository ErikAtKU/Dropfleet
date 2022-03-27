% Copyright

class fleet : fleet
    open core

predicates
    resetCount : ().

predicates
    tryConsult : () determ.

predicates
    trySave : () determ.

properties
    myUCMShips : tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}*.
    myScourgeShips : tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}*.
    myPHRShips : tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}*.
    myShaltariShips : tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}*.
    myResistanceShips : tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}*.
    myLowerPoints : integer.
    myUpperPoints : integer.

end class fleet
