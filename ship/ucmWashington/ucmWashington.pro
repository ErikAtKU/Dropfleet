% Copyright

implement ucmWashington inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(440, 14.0, 16.0, 6.0, 26, d6(2, p), 18, g(1, 1), superHeavy(2)).
    special_var : shipSpecial* = [dreadnought, launch(launchAssets), freeAdmiral(5)].
    launchAssets : launchSystem* = [strikeCraft(ucmFightersBombers, 15, [])].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("UF-9000 Mass Driver Turret, Starboard", d6(2, p), i(2), i(1), [front(), side(right)], [fusillade(2)]),
            weaponSystem("UF-9000 Mass Driver Turret, Port", d6(2, p), i(2), i(1), [front(), side(left)], [fusillade(2)]),
            weaponSystem("UF-4200 Mass Driver Turrets, Core Battery", d6(4, p), i(12), i(1), [front(), side()], []),
            weaponSystem("UF-4200 Mass Driver Turrets, Starboard Battery", d6(4, p), i(4), i(1), [front(), side(right)], []),
            weaponSystem("UF-4200 Mass Driver Turrets, Port Battery", d6(4, p), i(4), i(1), [front(), side(left)], []),
            weaponSystem("Leviathan Missile Bays", d6(3, p), nd6plus(2, 4), i(1), [front(), side(), rear], [closeAction()])
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

end implement ucmWashington
