% Copyright

implement ucmLysander inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(27, 6.0, 0.0, 12.0, 2, d6(6, p), 2, g(1, 3), light(1)).
    special_var : shipSpecial* = [atmospheric, launch(launchAssets), open_stat, fullCloak, rare].
    launchAssets : launchSystem* = [strikeCraft(dropships, 1, [])].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* := [weaponSystem("Barracuda Missile Bays", d6(4, p), i(2), i(1), [front(), side(), rear], [closeAction()])].

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

end implement ucmLysander
