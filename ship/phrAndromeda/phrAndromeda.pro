% Copyright

implement phrAndromeda inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(47, 8.0, 3.0, 10.0, 5, d6(3, p), 3, g(2, 4), light(1)).
    special_var : shipSpecial* = [launch(launchAssets)].
    launchAssets : launchSystem* = [strikeCraft(phrFightersBombers, 1, [])].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* := [weaponSystem("Wasp Drones", d6(3, p), nd3plus(1, 1), i(1), [front(), side(), rear], [closeAction()])].

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
    getFleetBuilderStats() = ConstructorStats :-
        ConstructorStats = getFleetBuilderStats(class_name(), shipStats_var, special_var, weaponSystemList, { () = newShip() }).

clauses
    getShipCount() = shipCount.

end implement phrAndromeda
