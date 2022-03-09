% Copyright

implement scourgeGargoyle inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(32, 6.0, 3.0, 12.0, 4, d6(5, p), 4, g(1, 2), light(1)).
    special_var : shipSpecial* = [atmospheric, launch(launchAssets), open_stat].
    launchAssets : launchSystem* = [strikeCraft(dropships, 1, [])].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("Oculus Rays", d6(3, p), i(1), i(1), [front()], [scald]),
            weaponSystem("Plasma Cloud", d6(3, p), i(2), i(1), [front(), side(), rear], [scald, closeAction()])
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

end implement scourgeGargoyle
