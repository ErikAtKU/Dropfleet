﻿% Copyright

implement weapon
    open core, shipClass

clauses
    simulate(Attacker, Defender, ShieldsUp, CAW, WeaponsFree, SingleLinkedDirection, Trials) = ReturnMap :-
        fleetBuilder::group(fbs(_, _, _, AttackerConstructor), AttackerCount) = Attacker,
        AttackShip = AttackerConstructor(),
        fbs(_, _, _, DefenderConstructor) = Defender,
        DefendShip = DefenderConstructor(),
        DefendShip:setShields(ShieldsUp),
        AllWeaponDamageList =
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
                                Total = getWeaponDamage(SingleSystem, HitsVar:value, CritsVar:value) * (HitsVar:value + CritsVar:value)
                        ],
                    WeaponKeySet = setM_redBlack::new(WeaponKey),
                    if alt(AltX) in WeaponKeySet then
                        [HighestDamage | _] = list::sort(SingleDamageList, core::descending),
                        AfterAlt = [HighestDamage],
                        WeaponKeySet:remove(alt(AltX))
                    else
                        AfterAlt = SingleDamageList
                    end if,
                    if true = SingleLinkedDirection and linked(_LinkedX) in WeaponKeySet then
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
                        [tuple(_, _, AfterLinked) | _] = list::sort(ArcList, core::descending)
                    else
                        AfterLinked = AfterAlt
                    end if,
                    [] <> AfterLinked
            ],
        if true = SingleLinkedDirection then
            MaxLinkedTuple = varM::new(tuple(0, 0)),
            SumLinkedTuple = varM::new(tuple(0, 0)),
            MaxDirectionalWeaponDamageList = varM::new([]),
            foreach ArcToHit in [front(narrow), side(left), side(right), rear] do
                SumLinkedTuple:value := tuple(0, 0),
                CheckArcWeaponDamageList =
                    [ tuple(WeaponKeyList, FilteredWeaponSystem) ||
                        tuple(WeaponKeyList, GroupedWeaponSystem) in AllWeaponDamageList, %+
                            FilteredWeaponSystem =
                                [ tuple(Total, Crits, SingleSystem, WeaponFunc) ||
                                    tuple(Total, Crits, SingleSystem, WeaponFunc) in GroupedWeaponSystem, %+
                                        isInArc(SingleSystem, ArcToHit),
                                        tuple(TTotal, TCrits) = SumLinkedTuple:value,
                                        SumLinkedTuple:value := tuple(TTotal + Total, TCrits + Crits)
                                ],
                            [] <> FilteredWeaponSystem
                    ],
                if MaxLinkedTuple:value < SumLinkedTuple:value then
                    MaxLinkedTuple:value := SumLinkedTuple:value,
                    MaxDirectionalWeaponDamageList:value := CheckArcWeaponDamageList
                end if
            end foreach,
            DirectionalWeaponDamageList = MaxDirectionalWeaponDamageList:value
        else
            DirectionalWeaponDamageList = AllWeaponDamageList
        end if,
        if true = WeaponsFree then
            WeaponDamageList = DirectionalWeaponDamageList
        else
            NonCAWList =
                list::sort(
                    [ tuple(NonCawDamage:value, WeaponKeyList, FilteredWeaponSystem) ||
                        tuple(WeaponKeyList, GroupedWeaponSystem) in DirectionalWeaponDamageList, %+
                            NonCawDamage = varM::new(tuple(0, 0)),
                            FilteredWeaponSystem =
                                [ tuple(Total, Crits, SingleSystem, WeaponFunc) ||
                                    tuple(Total, Crits, SingleSystem, WeaponFunc) in GroupedWeaponSystem, %+
                                        not(isCloseAction(SingleSystem)),
                                        tuple(TTotal, TCrits) = NonCawDamage:value,
                                        NonCawDamage:value := tuple(TTotal + Total, TCrits + Crits)
                                ],
                            [] <> FilteredWeaponSystem
                    ],
                    core::descending),
            if dreadnought = AttackShip:getShipSpecial_nd() then
                Take = 2
            else
                Take = 1
            end if,
            NonCawFinal = list::take(Take, NonCAWList),
            WeaponDamageList =
                [ tuple(WeaponKeyList, FilteredWeaponSystem) ||
                    tuple(_, WeaponKeyList, FilteredWeaponSystem) in NonCawFinal
                    or
                    tuple(WeaponKeyList, GroupedWeaponSystem) in DirectionalWeaponDamageList, %+
                        FilteredWeaponSystem =
                            [ tuple(Total, Crits, SingleSystem, WeaponFunc) ||
                                tuple(Total, Crits, SingleSystem, WeaponFunc) in GroupedWeaponSystem, %+
                                    isCloseAction(SingleSystem)
                            ],
                        [] <> FilteredWeaponSystem
                ]
        end if,
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
        PointDefenseRolls = DefendShip:getPointDefense(),
        foreach _ = std::fromTo(1, Trials) do
            DamageVar = varM_integer::new(0),
            CAWVar = varM::new([]),
            %Standard Block
            foreach tuple(WeaponKey, SingleDamageList) in WeaponDamageList do
                foreach tuple(_, _, SingleSystem, WeaponFunc) in SingleDamageList and not(isCloseAction(SingleSystem)) do
                    tuple(Hits, Crits) = WeaponFunc(),
                    WepDamage = getWeaponDamage(SingleSystem, Hits, Crits),
                    WepSpecial = getWeaponSpecial(SingleSystem),
                    DamageVar:add(applySaves(WepSpecial, WepDamage, Hits, Crits, DefendShip))
                end foreach
            end foreach,
            %Caw Block
            foreach tuple(WeaponKey, SingleDamageList) in WeaponDamageList do
                foreach tuple(_, _, SingleSystem, WeaponFunc) in SingleDamageList and isCloseAction(SingleSystem) do
                    tuple(Hits, Crits) = WeaponFunc(),
                    CAWVar:value := [tuple(getWeaponSpecial(SingleSystem), getWeaponDamage(SingleSystem, Hits, Crits), Hits, Crits) | CAWVar:value]
                end foreach
            end foreach,
            %Launch Block
            foreach SingleDamageList in LaunchDamageList do
                foreach tuple(_, _, SingleSystem, WeaponFunc) in SingleDamageList do
                    tuple(Hits, Crits) = WeaponFunc(),
                    CAWVar:value := [tuple(getLaunchSpecial(SingleSystem), getLaunchDamage(SingleSystem), Hits, Crits) | CAWVar:value]
                end foreach
            end foreach,
            PDCount = dice::getPD(PointDefenseRolls),
            CAWDamage = applyPointDefense(CAWVar:value, PDCount, DefendShip),
            Damage = CAWDamage + DamageVar:value,
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
        (DiceFunction = DiceFunction1 and _ = std::fromTo(1, AttackerCount)
            or if squadron(SquadronCount) in Special and ! and SquadronCount <= AttackerCount then
                DiceFunction =
                    { () =
                            [ Die ||
                                _ = std::fromTo(1, SquadronDiceCount), %+
                                    Die = dice::new(LockRoll, CritRoll),
                                    if true = Particle then
                                        Die:setParticle()
                                    end if
                            ] :-
                        SquadronDiceCount = dice::getCount(nd6plus(1, 0))
                    }
            else
                fail
            end if).
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
    getWeaponDamage : (shipClass::weaponSystem, integer Hits, integer Crits) -> integer Damage.
clauses
    getWeaponDamage(weaponSystem(_Name, _Lock, _Attack, star, _Arc, WeaponSpecial), Hits, Crits) = Damage :-
        list::isMember(distortion, WeaponSpecial),
        !,
        Damage = Hits + Crits.
    getWeaponDamage(weaponSystem(_Name, _Lock, _Attack, Damage, _Arc, _WeaponSpecial), _Hits, _Crits) = dice::getCount(Damage).

class predicates
    getWeaponSpecial : (weaponSystem) -> shipClass::weaponSpecial*.
clauses
    getWeaponSpecial(weaponSystem(_Name, _Lock, _Attack, _Damage, _Arc, WeaponSpecial)) = WeaponSpecial.

class predicates
    getLaunchSpecial : (launchSystem) -> shipClass::weaponSpecial*.
clauses
    getLaunchSpecial(torpedo(_TS, _Launch, LaunchSpecial)) = LaunchSpecial.
    getLaunchSpecial(strikeCraft(_SC, _Launch, LaunchSpecial)) = LaunchSpecial.

class predicates
    getLaunchDamage : (launchSystem) -> integer Damage.
clauses
    getLaunchDamage(torpedo(_TS, _Launch, _LaunchSpecial)) = 1.
    getLaunchDamage(strikeCraft(_SC, _Launch, _LaunchSpecial)) = 1.

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
    applySaves : (shipClass::weaponSpecial*, integer Damage, integer Hits, integer Crits, ship DefendShip) -> integer Damage.
    %  applySaves : (shipClass::launchSystem, integer Hits, integer Crits, ship DefendShip) -> integer Damage.
clauses
    applySaves(WeaponSpecial, WepDamage, Hits, Crits, DefendShip) = Damage :-
        Roll = DefendShip:getArmour(),
        HitsDice = dice::new(Roll),
        DamageVar = varM_integer::new(WepDamage * (Hits + Crits)),
        foreach _ = std::fromTo(1, Hits) and _ = std::fromTo(1, WepDamage) do
            if _ = HitsDice:getRoll_dt() then
                DamageVar:dec()
            end if
        end foreach,
        foreach
            ShieldRoll = DefendShip:getShields_dt() and CritsDice = dice::new(ShieldRoll) and _ = std::fromTo(1, Crits)
            and _ = std::fromTo(1, WepDamage)
        do
            if _ = CritsDice:getRoll_dt() then
                DamageVar:dec()
            end if
        end foreach,
        Damage = DamageVar:value.

class predicates
    applyPointDefense : (tuple{shipClass::weaponSpecial*, integer Damage, integer Hits, integer Crits}*, integer PD, ship DefendShip)
        -> integer Damage.
    %  applyPointDefense : (shipClass::launchSystem, integer Hits, integer Crits, ship DefendShip, integer HitsOut [out], integer CritsOut [out]).
clauses
    applyPointDefense([], _PD, _DefendShip) = 0 :-
        !.
    applyPointDefense(SpecialList, PD, DefendShip) = OutDamage :-
        PDAttack in SpecialList, %+
            tuple(WeaponSpecial, WepDamage, Hits, Crits) = PDAttack,
            (list::isMember(particle, WeaponSpecial) orelse list::isMember(closeAction(beam), WeaponSpecial)),
        !,
        NextList = list::remove(SpecialList, PDAttack),
        Damage = applySaves(WeaponSpecial, WepDamage, Hits, Crits, DefendShip),
        OutDamage = Damage + applyPointDefense(NextList, PD, DefendShip).
    applyPointDefense(SpecialList, PD, DefendShip) = OutDamage :-
        PDAttack in SpecialList, %+
            tuple(WeaponSpecial, WepDamage, Hits, Crits) = PDAttack,
            list::isMember(scald, WeaponSpecial),
        !,
        NextList = list::remove(SpecialList, PDAttack),
        Damage = applySaves(WeaponSpecial, WepDamage, Hits, Crits, DefendShip),
        OutDamage = Damage + applyPointDefense(NextList, PD, DefendShip).

    applyPointDefense(SpecialList, PD, DefendShip) = OutDamage :-
        PDAttack in SpecialList, %+
            tuple(WeaponSpecial, WepDamage, Hits, Crits) = PDAttack,
            Special in WeaponSpecial, %+
                (mauler(_) = Special orelse closeAction(standard) = Special),
        !,
        NextList = list::remove(SpecialList, PDAttack),
        Damage = applySaves(WeaponSpecial, WepDamage, Hits, Crits, DefendShip),
        OutDamage = Damage + applyPointDefense(NextList, PD, DefendShip).

    applyPointDefense(SpecialList, PD, DefendShip) = OutDamage :-
        PDAttack in SpecialList, %+
            tuple(WeaponSpecial, WepDamage, Hits, Crits) = PDAttack,
            list::isMember(closeAction(swarmer), WeaponSpecial),
        !,
        NextList = list::remove(SpecialList, PDAttack),
        Damage = applySaves(WeaponSpecial, WepDamage, Hits, Crits, DefendShip),
        OutDamage = Damage + applyPointDefense(NextList, PD, DefendShip).

    applyPointDefense([tuple(WeaponSpecial, WepDamage, Hits, Crits) | NextList], PD, DefendShip) = OutDamage :-
        !,
        Damage = applySaves(WeaponSpecial, WepDamage, Hits, Crits, DefendShip),
        OutDamage = Damage + applyPointDefense(NextList, PD, DefendShip).

end implement weapon
