% Copyright

implement shaltariPlutonium inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = shaltariStats(520, 16.0, sig(10.0, 36.0), 8.0, 26, arm(d6(4, p), d6(4, p)), 20, g(1, 1), superHeavy(2)).
    special_var : shipSpecial* = [dreadnought, launch(launchAssets)].
    launchAssets : launchSystem* = [strikeCraft(gates, 4, [])].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("Distortion Cannons", d6(3, p), i(4), star, [front()], [distortion]),
            weaponSystem("Twin Particle Lance Turret", d6(3, p), i(2), i(2), [front(), side()], [particle, fusillade(2)]),
            weaponSystem("Disintegrator Battery, Starboard", d6(3, p), i(4), i(1), [front(), side(right)], [linked(1)]),
            weaponSystem("Disintegrator Battery, Starboard", d6(3, p), i(4), i(1), [front(), side(right)], [linked(1)]),
            weaponSystem("Disintegrator Battery, Port", d6(3, p), i(4), i(1), [front(), side(left)], [linked(2)]),
            weaponSystem("Disintegrator Battery, Port", d6(3, p), i(4), i(1), [front(), side(left)], [linked(2)]),
            weaponSystem("Harpoon Deluge", d6(4, p), i(12), i(1), [front(), side(), rear], [closeAction()])
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

end implement shaltariPlutonium
