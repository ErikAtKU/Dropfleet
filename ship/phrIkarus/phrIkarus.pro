% Copyright

implement phrIkarus inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(115, 8.0, 6.0, 8.0, 11, d6(3, p), 5, g(1, 2), medium).
    special_var : shipSpecial* = [launch(launchAssets)].
    launchAssets : launchSystem* = [strikeCraft(phrFightersBombers, 2, [])].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("Medium Calibre Battery", d6(4, p), i(4), i(1), [side(left)], [linked(1), fusillade(2)]),
            weaponSystem("Medium Calibre Battery", d6(4, p), i(4), i(1), [side(right)], [linked(1), fusillade(2)]),
            weaponSystem("Medium Calibre Turret", d6(4, p), i(2), i(1), [front()], []),
            weaponSystem("Wasp Drones", d6(3, p), nd3plus(1, 1), i(1), [front(), side(), rear], [closeAction()])
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

end implement phrIkarus
