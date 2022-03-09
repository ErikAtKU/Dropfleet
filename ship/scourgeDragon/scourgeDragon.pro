% Copyright

implement scourgeDragon inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(265, 8.0, 12.0, 8.0, 18, d6(3, p), 12, g(1, 1), superHeavy(1)).
    special_var : shipSpecial* = [launch(launchAssets)].
    launchAssets : launchSystem* =
        [
            torpedo(scourgeTorpedo, 1, [limited(2), corruptor]),
            torpedo(scourgeTorpedo, 1, [limited(2), corruptor]),
            strikeCraft(scourgeFightersBombers, 3, [])
        ].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("Oculus Beam Array", d6(3, p), i(2), i(2), [front()], [scald]),
            weaponSystem("Furnace Fangs", d6(4, p), i(4), i(1), [front(narrow)], [alt(1), scald, burnthrough(10)]),
            weaponSystem("Furnace Fangs", d6(2, p), i(2), i(1), [front(narrow)], [alt(1), scald, burnthrough(5), flash]),
            weaponSystem("Plasma Cyclone", d6(2, p), nd6plus(1, 2), i(1), [front(), side(), rear], [closeAction(), scald])
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

end implement scourgeDragon
