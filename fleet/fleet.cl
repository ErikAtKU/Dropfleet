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
    myUCMShips : fleetCount*.
    myScourgeShips : fleetCount*.
    myPHRShips : fleetCount*.
    myShaltariShips : fleetCount*.
    myResistanceShips : fleetCount*.

end class fleet
