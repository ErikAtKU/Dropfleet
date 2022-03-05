% Copyright

implement phrRomulus inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(500, 16.0, 14.0, 6.0, 30, d6(2, p), 18, g(1, 1), superHeavy(2)).
    special_var : shipSpecial* = [dreadnought].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("Hypernova Laser", d6(3, p), i(5), i(1), [front(narrow)], [burnthrough(14), overcharged]),
            weaponSystem("Energy Glaive Battery, Starboard", d6(3, p), i(6), i(1), [side(right)], [linked(1), overcharged]),
            weaponSystem("Energy Glaive Battery, Starboard", d6(3, p), i(6), i(1), [side(right)], [linked(1), overcharged]),
            weaponSystem("Energy Glaive Battery, Starboard", d6(3, p), i(6), i(1), [side(right)], [linked(1), overcharged]),
            weaponSystem("Energy Glaive Battery, Port", d6(3, p), i(6), i(1), [side(left)], [linked(2), overcharged]),
            weaponSystem("Energy Glaive Battery, Port", d6(3, p), i(6), i(1), [side(left)], [linked(2), overcharged]),
            weaponSystem("Energy Glaive Battery, Port", d6(3, p), i(6), i(1), [side(left)], [linked(2), overcharged]),
            weaponSystem("Hornet Drones", d6(3, p), nd3plus(1, 3), i(1), [front(), side(), rear], [closeAction()])
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

end implement phrRomulus
