% Copyright

implement scourgeNosferatu inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(460, 14.0, 18.0, 8.0, 26, d6(3, p), 20, g(1, 1), superHeavy(2)).
    special_var : shipSpecial* = [dreadnought, fullCloak, launch(launchAssets), stealth].
    launchAssets : launchSystem* = [strikeCraft(scourgeFightersBombers, 5, [])].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("Oculus Beam Super Phalanx", d6(3, p), i(8), i(2), [front()], [scald]),
            weaponSystem("Oculus Beam Array, Starboard", d6(3, p), i(2), i(2), [front(), side(right)], [linked(1), scald]),
            weaponSystem("Oculus Beam Array, Starboard", d6(3, p), i(2), i(2), [front(), side(right)], [linked(1), scald]),
            weaponSystem("Oculus Beam Array, Port", d6(3, p), i(2), i(2), [front(), side(left)], [linked(2), scald]),
            weaponSystem("Oculus Beam Array, Port", d6(3, p), i(2), i(2), [front(), side(left)], [linked(2), scald]),
            weaponSystem("Plasma Flood", d6(3, p), nd6plus(2, 3), i(1), [front(), side(), rear], [closeAction(), scald])
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

end implement scourgeNosferatu
