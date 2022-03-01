% Copyright

implement phrAjax inherits shipClass

constants
    nameList : string* = [].
    shipStats_var : shipStats = stats(95, 8.0, 6.0, 8.0, 11, d6(3, p), 5, g(1, 2), medium).
    special_var : shipSpecial* = [].

class facts
    shipCount : integer := 0.
    usedNameList : string* := [].
    weaponSystemList : weaponSystem* :=
        [
            weaponSystem("Light Calibre Battery", d6(5, p), i(6), i(1), [side(left)], [calibre([cat_light]), linked(1), fusillade(3)]),
            weaponSystem("Light Calibre Battery", d6(5, p), i(6), i(1), [side(left)], [calibre([cat_light]), linked(1), fusillade(3)]),
            weaponSystem("Light Calibre Battery", d6(5, p), i(6), i(1), [side(right)], [calibre([cat_light]), linked(1), fusillade(3)]),
            weaponSystem("Light Calibre Battery", d6(5, p), i(6), i(1), [side(right)], [calibre([cat_light]), linked(1), fusillade(3)]),
            weaponSystem("Supernova Laser", d6(3, p), i(1), i(1), [front(narrow)], [burnthrough(3), flash]),
            weaponSystem("Wasp Drones", d6(3, p), nd3plus(1, 1), i(1), [front(), side(), rear], [closeAction()])
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

end implement phrAjax
