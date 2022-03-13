% Copyright

implement scourgeCthulu inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(470, 14.0, 18.0, 8.0, 26, d6(3, p), 20, g(1, 1), superHeavy(2)).
    special_var : shipSpecial* = [dreadnought, fullCloak, stealth, launch(launchAssets)].
    launchAssets : launchSystem* = [strikeCraft(scourgeFightersBombers, 8, [])].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("Furnace Triad", d6(4, p), i(12), i(1), [front(narrow)], [burnthrough(20), flash, scald]),
            weaponSystem("Oculus Beam Array, Starboard", d6(3, p), i(2), i(2), [front(), side(right)], [linked(1), scald]),
            weaponSystem("Oculus Beam Array, Starboard", d6(3, p), i(2), i(2), [front(), side(right)], [linked(1), scald]),
            weaponSystem("Oculus Beam Array, Port", d6(3, p), i(2), i(2), [front(), side(left)], [linked(2), scald]),
            weaponSystem("Oculus Beam Array, Port", d6(3, p), i(2), i(2), [front(), side(left)], [linked(2), scald]),
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
    getFleetBuilderStats() = ConstructorStats :-
        ConstructorStats = getFleetBuilderStats(class_name(), shipStats_var, special_var, { () = newShip() }).

clauses
    getShipCount() = shipCount.

end implement scourgeCthulu
