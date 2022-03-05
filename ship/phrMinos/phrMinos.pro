% Copyright

implement phrMinos inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(285, 10.0, 12.0, 6.0, 22, d6(3, p), 10, g(1, 1), superHeavy(1)).
    special_var : shipSpecial* = [launch(launchAssets)].
    launchAssets : launchSystem* = [torpedo(phrTorpedo, 1, [limited(1)]), torpedo(phrTorpedo, 1, [limited(1)])].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("Heavy Calibre Cannonade", d6(3, p), i(6), i(1), [side(left)], [calibre([cat_heavy, cat_superHeavy])]),
            weaponSystem("Heavy Calibre Cannonade", d6(3, p), i(6), i(1), [side(right)], [calibre([cat_heavy, cat_superHeavy])]),
            weaponSystem("Neutron Missiles", d6(2, p), nd3plus(1, 1), i(2), [front(), side()], [crippling, closeAction()])
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

end implement phrMinos
