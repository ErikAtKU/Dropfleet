% Copyright

implement shaltariMercury inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = shaltariStats(60, 12.0, sig(3.0, 16.0), 12.0, 5, arm(d6(5, p), d6(4, p)), 6, g(2, 3), light(2)).
    special_var : shipSpecial* = [].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("Disruption Beamers", d6(3, p), i(2), i(1), [front()], []),
            weaponSystem("Pulse Ioniser Bank", star, i(3), i(1), [front()], [mauler(6)])
        ].

clauses
    new() :-
        shipCount := shipCount + 1,
        if Name in nameList and not(list::isMember(Name, usedNameList)) then
            usedNameList := [Name | usedNameList]
        else
            Name = string::format("%s_%d", class_name(), shipCount)
        end if,
        shipClass::new(shipStats_var, special_var, weaponSystemList, Name).

clauses
    newShip() = Ship :-
        New = new(),
        Ship = ship::new(New).

clauses
    resetNames() :-
        usedNameList := [],
        shipCount := 0.

clauses
    getFleetBuilderStats() = fbs(ConstructorStats, class_name(), special_var, { () = newShip() }) :-
        ConstructorStats = getFleetBuilderStats(shipStats_var).

clauses
    getShipCount() = shipCount.

clauses
    getImageFile() = string::format("../images/%s.png", class_name()).

end implement shaltariMercury
