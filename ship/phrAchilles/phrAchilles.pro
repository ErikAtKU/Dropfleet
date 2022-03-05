% Copyright

implement phrAchilles inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(165, 8.0, 6.0, 7.0, 13, d6(3, p), 5, g(1, 1), heavy).
    special_var : shipSpecial* = [launch(launchAssets)].
    launchAssets : launchSystem* = [torpedo(phrTorpedo, 1, [limited(1)])].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("Heavy Calibre Broadside", d6(3, p), i(4), i(1), [side(left)], [calibre([cat_heavy, cat_superHeavy]), linked(1), fusillade(2)]),
            weaponSystem("Heavy Calibre Broadside", d6(3, p), i(4), i(1), [side(right)],
                [calibre([cat_heavy, cat_superHeavy]), linked(1), fusillade(2)]),
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

end implement phrAchilles
