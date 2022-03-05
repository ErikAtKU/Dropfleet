% Copyright

implement shaltariDiamond inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = shaltariStats(290, 12.0, sig(4.0, 20.0), 8.0, 18, arm(d6(4, p), d6(4, p)), 12, g(1, 1), superHeavy(1)).
    special_var : shipSpecial* = [launch(launchAssets)].
    launchAssets : launchSystem* = [strikeCraft(gates, 1, [])].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("Disintegrator Battery", d6(3, p), i(4), i(1), [front(), side(left)], []),
            weaponSystem("Disintegrator Battery", d6(3, p), i(4), i(1), [front(), side(right)], []),
            weaponSystem("Particle Lance Triad", d6(2, p), i(2), i(2), [front(narrow)], [particle, bloom, crippling, fusillade(1)]),
            weaponSystem("Harpoon Torrent", d6(4, p), i(6), i(1), [front(), side(), rear], [closeAction()])
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

end implement shaltariDiamond
