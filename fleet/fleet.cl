% Copyright

class fleet : fleet
    open core

properties
    myUCMShips : tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}* (o).
    myShaltariShips : tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}* (o).

end class fleet
