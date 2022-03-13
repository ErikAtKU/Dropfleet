% Copyright

implement weapon
    open core, shipClass

clauses
    simulate(Attacker) = ReturnMap :-
        ReturnMap = simulate(Attacker, ucmOsaka::getFleetBuilderStats(), false, false, true, true, 5000).

clauses
    simulate(Attacker, Defender, ShieldsUp, CAW, WeaponsFree, SingleLinkedDirection, Trials) = ReturnMap :-
        fleetBuilder::group(fbs(_, _, _, AttackerConstructor), AttackerCount) = Attacker,
        AttackShip = AttackerConstructor(),
        fbs(_, _, _, DefenderConstructor) = Defender,
        DefendShip = DefenderConstructor(),
        DefendShip:setShields(ShieldsUp),
        WeaponDamageList =
            [ tuple(WeaponKeySet:asList, AfterLinked) ||
                AttackShip:getWeaponSystem_nd(WeaponKey, WeaponSystem), %+
                    SingleDamageList =
                        [ tuple(Total, CritsVar:value, SingleSystem, WeaponFunc) ||
                            SingleSystem in WeaponSystem, %+
                                if isCloseAction(SingleSystem) and false = CAW then
                                    fail
                                end if,
                                DiceFunctionList =
                                    [ DiceFunction || DiceFunction = getDiceFunction_nd(SingleSystem, AttackShip, AttackerCount, DefendShip) ],
                                WeaponFunc =
                                    { () = tuple(MyHits:value, MyCrits:value) :-
                                        MyHits = varM_integer::new(0),
                                        MyCrits = varM_integer::new(0),
                                        foreach DicePool in DiceFunctionList do
                                            if BurnthroughCap = isBurnthrough(SingleSystem) then
                                                getBurnthrough(DicePool(), BurnthroughCap, HitsOut, CritsOut)
                                            else
                                                getStandard(DicePool(), HitsOut, CritsOut)
                                            end if,
                                            MyHits:add(HitsOut),
                                            MyCrits:add(CritsOut)
                                        end foreach
                                    },
                                HitsVar = varM_integer::new(0),
                                CritsVar = varM_integer::new(0),
                                foreach _ = std::fromTo(1, 100) do
                                    tuple(Hits, Crits) = WeaponFunc(),
                                    HitsVar:add(Hits),
                                    CritsVar:add(Crits)
                                end foreach,
                                Total = HitsVar:value + CritsVar:value
                        ],
                    WeaponKeySet = setM_redBlack::new(WeaponKey),
                    if alt(AltX) in WeaponKeySet then
                        [HighestDamage | _] = list::sort(SingleDamageList, core::descending),
                        AfterAlt = [HighestDamage],
                        WeaponKeySet:remove(alt(AltX))
                    else
                        AfterAlt = SingleDamageList
                    end if,
                    if true = SingleLinkedDirection and linked(LinkedX) in WeaponKeySet then
                        ArcList =
                            [ tuple(LinkedTotalVar:value, LinkedCritsVar:value, SubList) ||
                                ArcToHit in [front(narrow), side(left), side(right), rear], %+
                                    LinkedTotalVar = varM_integer::new(0),
                                    LinkedCritsVar = varM_integer::new(0),
                                    SubList =
                                        [ SubWep ||
                                            SubWep in AfterAlt, %+
                                                tuple(Total, Crits, SingleSystem, _WeaponFunc) = SubWep,
                                                isInArc(SingleSystem, ArcToHit),
                                                LinkedTotalVar:add(Total),
                                                LinkedCritsVar:add(Crits)
                                        ]
                            ],
                        [tuple(_, _, AfterLinked) | _] = list::sort(ArcList, core::descending),
                        WeaponKeySet:remove(linked(LinkedX))
                    else
                        AfterLinked = AfterAlt
                    end if,
                    [] <> AfterLinked
            ],
        LaunchDamageList =
            [ SingleDamageList ||
                ShipSpecial = AttackShip:getShipSpecial_nd(), %+
                    launch(LaunchAssets) = ShipSpecial,
                    LaunchSystem in LaunchAssets, %+
                        SingleDamageList =
                            [ tuple(Total, CritsVar:value, LaunchSystem, WeaponFunc) ||
                                DiceFunctionList = [ DiceFunction || DiceFunction = getDiceFunction_nd(LaunchSystem, AttackerCount) ],
                                WeaponFunc =
                                    { () = tuple(MyHits:value, MyCrits:value) :-
                                        MyHits = varM_integer::new(0),
                                        MyCrits = varM_integer::new(0),
                                        foreach DicePool in DiceFunctionList do
                                            getStandard(DicePool(), HitsOut, CritsOut),
                                            MyHits:add(HitsOut),
                                            MyCrits:add(CritsOut)
                                        end foreach
                                    },
                                HitsVar = varM_integer::new(0),
                                CritsVar = varM_integer::new(0),
                                foreach _ = std::fromTo(1, 500) do
                                    tuple(Hits, Crits) = WeaponFunc(),
                                    HitsVar:add(Hits),
                                    CritsVar:add(Crits)
                                end foreach,
                                Total = HitsVar:value + CritsVar:value
                            ],
                        [] <> SingleDamageList
            ],
        ReturnMap = mapM_redBlack::new(),
        foreach _ = std::fromTo(1, Trials) do
            DamageVar = varM_integer::new(0),
            HitsVar = varM_integer::new(0),
            CritsVar = varM_integer::new(0),
            %Standard Block
            foreach tuple(WeaponKey, SingleDamageList) in WeaponDamageList do
                foreach tuple(_, _, SingleSystem, WeaponFunc) in SingleDamageList and not(isCloseAction(SingleSystem)) do
                    tuple(Hits, Crits) = WeaponFunc(),
                    DamageVar:add(applySaves(SingleSystem, Hits, Crits, DefendShip))
                end foreach
            end foreach,
            %Caw Block
            PointDefenseRolls = DefendShip:getPointDefense(),
            PDCount = dice::getPD(PointDefenseRolls),
            foreach tuple(WeaponKey, SingleDamageList) in WeaponDamageList do
                foreach tuple(_, _, SingleSystem, WeaponFunc) in SingleDamageList and isCloseAction(SingleSystem) do
                    tuple(Hits, Crits) = WeaponFunc(),
                    HitsVar:add(Hits),
                    CritsVar:add(Crits)
                end foreach
            end foreach,
            %Launch Block
            foreach SingleDamageList in LaunchDamageList do
                foreach tuple(_, _, SingleSystem, WeaponFunc) in SingleDamageList do
                    tuple(Hits, Crits) = WeaponFunc(),
                    HitsVar:add(Hits),
                    CritsVar:add(Crits)
                end foreach
            end foreach,
            Damage = HitsVar:value + CritsVar:value + DamageVar:value,
            Count = ReturnMap:get_default(Damage, 0),
            ReturnMap:set(Damage, Count + 1)
        end foreach.

class predicates
    getDiceFunction_nd : (weaponSystem, ship Attacker, integer AttackerCount, ship Defender) -> function{dice*} nondeterm.
clauses
    getDiceFunction_nd(weaponSystem(Name, star, Attack, Damage, Arc, Special), Attacker, AttackerCount, Defender) = DiceFunction :-
        mauler(_Burnthrough) in Special, %+
            !,
            LockRoll = Defender:getArmour(),
            DiceFunction = getDiceFunction_nd(weaponSystem(Name, LockRoll, Attack, Damage, Arc, Special), Attacker, AttackerCount, Defender),
            _ = std::fromTo(1, AttackerCount).
    getDiceFunction_nd(weaponSystem(Name, BaseLockRoll, Attack, _Damage, _Arc, Special), _, AttackerCount, Defender) = DiceFunction :-
        Particle = if list::isMember(particle, Special) then true else false end if,
        d6(Lock, Diemod) = BaseLockRoll,
        !,
        if calibre(CalibreList) in Special and ! and Calibre in CalibreList
            and %+
                shipClass::matchRosterCatTonnage_dt(Calibre, Defender:getTonnage())
        then
            LockRoll = d6(math::max(1, Lock - 1), Diemod),
            if Calibre in [cat_heavy, cat_superHeavy] then
                CritRoll = d6(Lock + 1, Diemod)
            else
                CritRoll = d6(Lock + 2, Diemod)
            end if
        else
            LockRoll = BaseLockRoll,
            CritRoll = d6(Lock + 2, Diemod)
        end if,
        ExtraSquadronCount = if squadron(SquadronCount) in Special and ! and SquadronCount <= AttackerCount then nd6plus(1, 0) else i(0) end if,
        DiceFunction1 =
            { () =
                    [ Die ||
                        _ = std::fromTo(1, DiceCount), %+
                            Die = dice::new(LockRoll, CritRoll),
                            if true = Particle then
                                Die:setParticle()
                            end if
                    ] :-
                DiceCount = dice::getCount(Attack)
            },
        DiceFunction2 =
            { () =
                    [ Die ||
                        _ = std::fromTo(1, SquadronDiceCount), %+
                            Die = dice::new(LockRoll, CritRoll),
                            if true = Particle then
                                Die:setParticle()
                            end if
                    ] :-
                SquadronDiceCount = dice::getCount(ExtraSquadronCount)
            },
        (DiceFunction = DiceFunction1 and _ = std::fromTo(1, AttackerCount) or DiceFunction = DiceFunction2).
    getDiceFunction_nd(_WeaponSystem, _Attacker, _AttackerCount, _Defender) = { () = [] }.

class predicates
    getDiceFunction_nd : (launchSystem, integer AttackerCount) -> function{dice*} nondeterm.
clauses
    getDiceFunction_nd(strikeCraft(fighterBomber_stats(Left, Right), Launch, LaunchSpecial), AttackerCount) = DiceFunction :-
        DiceFunction = getDiceFunction_nd(strikeCraft(Left, Launch, LaunchSpecial), AttackerCount)
        or
        DiceFunction = getDiceFunction_nd(strikeCraft(Right, Launch, LaunchSpecial), AttackerCount).
    getDiceFunction_nd(strikeCraft(bomber_stats(_Name, _Thrust, BaseLockRoll, Attack, _Damage, _Special), Launch, _LaunchSpecial), AttackerCount) =
            DiceFunction :-
        d6(Lock, Diemod) = BaseLockRoll,
        LockRoll = BaseLockRoll,
        CritRoll = d6(Lock + 2, Diemod),
        DiceFunction =
            { () =
                    [ Die ||
                        _ = std::fromTo(1, DiceCountVar:value), %+
                            Die = dice::new(LockRoll, CritRoll)
                    ] :-
                DiceCountVar = varM_integer::new(0),
                foreach _ = std::fromTo(1, Launch) do
                    DiceCountVar:add(dice::getCount(Attack))
                end foreach
            },
        _ = std::fromTo(1, AttackerCount).

class predicates
    isInArc : (shipClass::weaponSystem, arc ArcToHit) determ.
clauses
    isInArc(weaponSystem(_Name, _Lock, _Attack, _Damage, Arc, _WeaponSpecial), ArcToHit) :-
        SingleArc in Arc, %+
            if side(all) = SingleArc then
                side(_) = ArcToHit
            elseif front(all) = SingleArc then
                front(_) = ArcToHit
            else
                SingleArc = ArcToHit
            end if,
        !.

class predicates
    isCloseAction : (shipClass::weaponSystem) determ.
clauses
    isCloseAction(weaponSystem(_Name, _Lock, _Attack, _Damage, _Arc, WeaponSpecial)) :-
        closeAction(_) in WeaponSpecial,
        !.
    isCloseAction(weaponSystem(_Name, _Lock, _Attack, _Damage, _Arc, WeaponSpecial)) :-
        mauler(_) in WeaponSpecial,
        !.

class predicates
    isBurnthrough : (shipClass::weaponSystem) -> integer BurnthroughCap determ.
clauses
    isBurnthrough(weaponSystem(_Name, _Lock, _Attack, _Damage, _Arc, WeaponSpecial)) = BurnthroughCap :-
        burnthrough(BurnthroughCap) in WeaponSpecial,
        !.
    isBurnthrough(weaponSystem(_Name, _Lock, _Attack, _Damage, _Arc, WeaponSpecial)) = BurnthroughCap :-
        mauler(BurnthroughCap) in WeaponSpecial,
        !.

class predicates
    isAltWeapon : (shipClass::weaponSystem) determ.
clauses
    isAltWeapon(weaponSystem(_Name, _Lock, _Attack, _Damage, _Arc, WeaponSpecial)) :-
        alt(_) in WeaponSpecial,
        !.

class predicates
    getWeaponDamage : (shipClass::weaponSystem) -> shipClass::count Damage.
clauses
    getWeaponDamage(weaponSystem(_Name, _Lock, _Attack, Damage, _Arc, _WeaponSpecial)) = Damage.

clauses
    getBurnthrough(_, 0, 0, 0) :-
        !.
    getBurnthrough([], _BurnthroughCap, 0, 0) :-
        !.
    getBurnthrough(Dice, BurnthroughCap, HitsOut, CritsOut) :-
        HitCount = varM_integer::new(0),
        CritCount = varM_integer::new(0),
        BurnthroughRemaining = varM_integer::new(BurnthroughCap),
        NextDice = varM::new([]),
        foreach
            Die in Dice %+
            and Roll = Die:getRoll_dt() and 0 <= BurnthroughRemaining:dec()
        do
            NextDice:value := [Die | NextDice:value],
            if Die:isCrit(Roll) then
                CritCount:inc()
            else
                HitCount:inc()
            end if
        end foreach,
        if CritCount:value > 0 then
            list::forAll(NextDice:value, { (NextDie) :- NextDie:setBurnthroughCrit() })
        end if,
        getBurnthrough(NextDice:value, BurnthroughRemaining:value, NextHits, NextCrits),
        HitsOut = NextHits + HitCount:value,
        CritsOut = NextCrits + CritCount:value.

clauses
    getStandard(Dice, HitsOut, CritsOut) :-
        HitCount = varM_integer::new(0),
        CritCount = varM_integer::new(0),
        foreach Die in Dice and Roll = Die:getRoll_dt() do
            if Die:isCrit(Roll) then
                CritCount:inc()
            else
                HitCount:inc()
            end if
        end foreach,
        HitsOut = HitCount:value,
        CritsOut = CritCount:value.

class predicates
    applySaves : (shipClass::weaponSystem, integer Hits, integer Crits, ship DefendShip) -> integer Damage.
    %  applySaves : (shipClass::launchSystem, integer Hits, integer Crits, ship DefendShip) -> integer Damage.
clauses
    applySaves(Weapon, Hits, Crits, DefendShip) = Damage :-
        WepDamage = getWeaponDamage(Weapon),
        Roll = DefendShip:getArmour(),
        HitsDice = dice::new(Roll),
        DamageVar = varM_integer::new(Hits + Crits),
        foreach _ = std::fromTo(1, Hits) and _ = std::fromTo(1, dice::getCount(WepDamage)) do
            if _ = HitsDice:getRoll_dt() then
                DamageVar:dec()
            end if
        end foreach,
        foreach
            ShieldRoll = DefendShip:getShields_dt() and CritsDice = dice::new(ShieldRoll) and _ = std::fromTo(1, Crits)
            and _ = std::fromTo(1, dice::getCount(WepDamage))
        do
            if _ = CritsDice:getRoll_dt() then
                DamageVar:dec()
            end if
        end foreach,
        Damage = DamageVar:value.

class predicates
    applyPointDefense : (shipClass::weaponSystem, integer Hits, integer Crits, ship DefendShip, integer HitsOut [out], integer CritsOut [out]).
    %  applyPointDefense : (shipClass::launchSystem, integer Hits, integer Crits, ship DefendShip, integer HitsOut [out], integer CritsOut [out]).
clauses
    applyPointDefense(weaponSystem(_Name, _Lock, _Attack, _Damage, _Arc, WeaponSpecial), Hits, Crits, DefendShip, HitsOut, CritsOut) :-
        not(list::isMember(particle, WeaponSpecial)),
        (if closeAction(CAWType) in WeaponSpecial then
                succeed
            else
                fail
            end if
            orelse if mauler(_) in WeaponSpecial then
                CAWType = standard
            else
                fail
            end if),
        if CAWType = beam then
            HitsOut = Hits,
            CritsOut = Crits
        elseif CAWType = standard then
            HitsOut = Hits,
            CritsOut = Crits
        else
            CAWType = swarmer,
            HitsOut = Hits,
            CritsOut = Crits
        end if,
        !.
    applyPointDefense(_, Hits, Crits, _, Hits, Crits).

end implement weapon
