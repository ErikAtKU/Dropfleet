% Copyright

implement phrRemus inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(460, 16.0, 14.0, 6.0, 30, d6(2, p), 18, g(1, 1), superHeavy(2)).
    special_var : shipSpecial* = [dreadnought, launch(launchAssets)].
    launchAssets : launchSystem* = [torpedo(phrTorpedo, 4, [limited(4)])].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("Energy Glaive Battery, Starboard", d6(3, p), i(6), i(1), [side(right)], [linked(1), overcharged]),
            weaponSystem("Energy Glaive Battery, Starboard", d6(3, p), i(6), i(1), [side(right)], [linked(1), overcharged]),
            weaponSystem("Energy Glaive, Port", d6(3, p), i(6), i(1), [side(left)], [linked(2), overcharged]),
            weaponSystem("Energy Glaive, Port", d6(3, p), i(6), i(1), [side(left)], [linked(2), overcharged]),
            weaponSystem("Apocalypse Cannon, Barrel 1", d6(2, p), i(2), i(1), [front()], [bombardment, overcharged, linked(3)]),
            weaponSystem("Apocalypse Cannon, Barrel 2", d6(2, p), i(2), i(1), [front()], [bombardment, overcharged, linked(3)]),
            weaponSystem("Apocalypse Cannon, Barrel 3", d6(2, p), i(2), i(1), [front()], [bombardment, overcharged, linked(3)]),
            weaponSystem("Apocalypse Cannon, Barrel 4", d6(2, p), i(2), i(1), [front()], [bombardment, overcharged, linked(3)]),
            weaponSystem("Hornet Drone Hive", d6(3, p), nd3plus(1, 8), i(1), [front(), side(), rear], [closeAction()])
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

clauses
    getImageFile() = string::format("../images/%s.png", class_name()).

end implement phrRemus
