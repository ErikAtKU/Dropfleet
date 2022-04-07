% Copyright

implement phrMedea inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(39, 8.0, 3.0, 10.0, 5, d6(3, p), 3, g(1, 2), light(1)).
    special_var : shipSpecial* = [launch(launchAssets), open_stat, atmospheric].
    launchAssets : launchSystem* = [strikeCraft(dropships, 1, [])].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("Bombardment Turret", d6(4, p), i(2), i(1), [front(), side()], [bombardment, lowLevel]),
            weaponSystem("Mosquito Drones", d6(4, p), i(2), i(1), [front(), side(), rear], [closeAction()])
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
        ConstructorStats = getFleetBuilderStats(class_name(), shipStats_var, special_var, weaponSystemList, { () = newShip() }).

clauses
    getShipCount() = shipCount.

end implement phrMedea
