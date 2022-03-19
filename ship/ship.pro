implement ship
    open shipClass

facts
    shipClass_var : shipClass.
    shieldsUp : boolean := false.
    inAtmo : boolean := false.
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
    getArmour() = shipClass_var:armour(shieldsUp).

clauses
    getShields_dt() = shipClass_var:shields_dt(shieldsUp).

clauses
    getPointDefense() = BasePD + AegisPD + FighterPD :-
        BasePD = shipClass_var:pointDefense(shieldsUp),
        AegisPD = if aegis(X) = getShipSpecial_nd() then X else 0 end if,
        FighterList =
            [ PDBonus ||
                LaunchSystem = getLaunch_nd(), %+
                    fighter_stats(_, _, PDBonus, _) = getStrikeCraft_nd(LaunchSystem)
            ],
        FighterPD = list::sum(FighterList).

clauses
    getTonnage() = shipClass_var:tonnage().

clauses
    getLayer() = inAtmo.

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
    getLaunch_nd() = LaunchAsset :-
        Special = getShipSpecial_nd(), %+
            launch(LaunchAssets) = Special,
            LaunchAsset in LaunchAssets.

predicates
    getStrikeCraft_nd : (shipClass::launchSystem) -> shipClass::strikeCraftSystem nondeterm.
clauses
    getStrikeCraft_nd(shipClass::strikeCraft(System, Launch, Special)) = Return :-
        if fighterBomber_stats(Left, Right) = System then
            Return = getStrikeCraft_nd(shipClass::strikeCraft(Left, Launch, Special))
            or
            Return = getStrikeCraft_nd(shipClass::strikeCraft(Right, Launch, Special))
        else
            Return = System,
            _ = std::fromTo(1, Launch)
        end if.

clauses
    setShields(ShieldsUp) :-
        shipClass_var:canShield(),
        !,
        shieldsUp := ShieldsUp.
    setShields(_) :-
        shieldsUp := false.

clauses
    setAtmospheric(InAtmo) :-
        atmospheric = getShipSpecial_nd(),
        !,
        inAtmo := InAtmo.
    setAtmospheric(_) :-
        inAtmo := false.

end implement ship
