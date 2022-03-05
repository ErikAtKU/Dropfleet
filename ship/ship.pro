implement ship

facts
    shipClass_var : shipClass.
    shieldsUp : boolean := false.
    damage : integer := 0.

clauses
    new(ShipClass) :-
        shipClass_var := ShipClass.

properties
    shipPoints : integer (o).
    scan : real (o).
    signature : real (o).
    thrust : real (o).
    hull : integer (o).
    armour : shipClass::roll (o).
    pointDefense : integer (o).

clauses
    shipPoints() = shipClass_var:shipPoints().
    scan() = shipClass_var:scan().
    signature() = shipClass_var:signature(shieldsUp).
    thrust() = shipClass_var:thrust().
    hull() = shipClass_var:hull().
    armour() = shipClass_var:armour(shieldsUp).
    pointDefense() = shipClass_var:pointDefense(shieldsUp).

clauses
    getWeaponSystem_nd() = shipClass_var:getWeaponSystem_nd().

clauses
    getShipSpecial_nd() = shipClass_var:getShipSpecial_nd().

clauses
    getScan() = scan.

clauses
    getSignature() = signature.

clauses
    getArmour() = armour.

clauses
    getPointDefense() = pointDefense.

clauses
    getShipPoints() = shipPoints.

clauses
    getHull() = hull - damage.

clauses
    getThrust() = thrust.

end implement ship
