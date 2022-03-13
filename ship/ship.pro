implement ship
    open shipClass

facts
    shipClass_var : shipClass.
    shieldsUp : boolean := false.
    damage : integer := 0.

clauses
    new(ShipClass) :-
        shipClass_var := ShipClass.

clauses
    getShipPoints() = shipClass_var:shipPoints().

clauses
    getScan() = shipClass_var:scan().

clauses
    getSignature() = shipClass_var:signature(shieldsUp).

clauses
    getThrust() = shipClass_var:thrust().

clauses
    getHull() = shipClass_var:hull() - damage.

clauses
    getArmour() = shipClass_var:armour(false).

clauses
    getShields_dt() = shipClass_var:armour(true) :-
        true = shieldsUp.

clauses
    getPointDefense() = shipClass_var:pointDefense(shieldsUp).

clauses
    getTonnage() = shipClass_var:tonnage().

clauses
    getWeaponSystem_nd(SingleKey, Weapons) :-
        WepMap = mapM_redBlack::new(),
        foreach Wep = shipClass_var:getWeaponSystem_nd() and weaponSystem(_Name, _Lock, _Attack, _Damage, _Arc, WeaponSpecial) = Wep do
            Key =
                [ SpecialKey ||
                    Special in WeaponSpecial, %+
                        if linked(LinkedInt) = Special then
                            SpecialKey = linked(LinkedInt)
                        elseif alt(AltVal) = Special then
                            SpecialKey = alt(AltVal)
                        else
                            fail
                        end if
                ],
            List = WepMap:get_default(list::sort(Key), []),
            WepMap:set(Key, [Wep | List])
        end foreach,
        SingleKey = WepMap:getKey_nd(),
        if [] = SingleKey then
            WeaponsList = WepMap:get_default(SingleKey, []),
            Weapons in list::map(WeaponsList, { (Elem) = [Elem] })
        else
            Weapons = WepMap:get_default(SingleKey, [])
        end if.

clauses
    getShipSpecial_nd() = shipClass_var:getShipSpecial_nd().

clauses
    setShields(ShieldsUp) :-
        shieldsUp := ShieldsUp.

end implement ship
