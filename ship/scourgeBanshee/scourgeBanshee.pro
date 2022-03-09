% Copyright

implement scourgeBanshee inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(180, 6.0, 8.0, 10.0, 14, d6(4, p), 8, g(1, 1), heavy).
    special_var : shipSpecial* = [stealth, fullCloak, launch(launchAssets)].
    launchAssets : launchSystem* = [torpedo(scourgeTorpedo, 1, [limited(2), corruptor])].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("Oculus Beam Array", d6(3, p), i(2), i(2), [front()], [scald]),
            weaponSystem("Plasma Tempest", d6(3, p), nd6plus(2, 4), i(1), [front(), side()], [scald, closeAction()])
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

end implement scourgeBanshee
