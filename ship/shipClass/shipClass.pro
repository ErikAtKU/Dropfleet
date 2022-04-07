implement shipClass

facts
    shipStats_var : shipStats.
    shipSpecialList : shipSpecial*.
    weaponSystemList : weaponSystem*.
    name_var : string.

clauses
    new(ShipStats, ShipSpecial, WeaponSystems, Name) :-
        shipStats_var := ShipStats,
        shipSpecialList := ShipSpecial,
        weaponSystemList := WeaponSystems,
        name_var := Name.

clauses
    shipPoints() = ShipPoints :-
        stats(ShipPoints, _Scan, _Signature, _Thrust, _Hull, _Armour, _PointDefense, _GroupSize, _Tonnage) = shipStats_var,
        !.
    shipPoints() = ShipPoints :-
        shaltariStats(ShipPoints, _Scan, _Signature, _Thrust, _Hull, _Armour, _PointDefense, _GroupSize, _Tonnage) = shipStats_var,
        !.
    shipPoints() = 0.

    scan() = Scan :-
        stats(_ShipPoints, Scan, _Signature, _Thrust, _Hull, _Armour, _PointDefense, _GroupSize, _Tonnage) = shipStats_var,
        !.
    scan() = Scan :-
        shaltariStats(_ShipPoints, Scan, _Signature, _Thrust, _Hull, _Armour, _PointDefense, _GroupSize, _Tonnage) = shipStats_var,
        !.
    scan() = 0.

    signature(_) = Signature :-
        stats(_ShipPoints, _Scan, Signature, _Thrust, _Hull, _Armour, _PointDefense, _GroupSize, _Tonnage) = shipStats_var,
        !.
    signature(ShieldsUp) = Return :-
        shaltariStats(_ShipPoints, _Scan, Signature, _Thrust, _Hull, _Armour, _PointDefense, _GroupSize, _Tonnage) = shipStats_var,
        sig(Down, Up) = Signature,
        Return = if ShieldsUp = true then Up else Down end if,
        !.
    signature(_) = 0.

    thrust() = Thrust :-
        stats(_ShipPoints, _Scan, _Signature, Thrust, _Hull, _Armour, _PointDefense, _GroupSize, _Tonnage) = shipStats_var,
        !.
    thrust() = Thrust :-
        shaltariStats(_ShipPoints, _Scan, _Signature, Thrust, _Hull, _Armour, _PointDefense, _GroupSize, _Tonnage) = shipStats_var,
        !.
    thrust() = 0.

    hull() = Hull :-
        stats(_ShipPoints, _Scan, _Signature, _Thrust, Hull, _Armour, _PointDefense, _GroupSize, _Tonnage) = shipStats_var,
        !.
    hull() = Hull :-
        shaltariStats(_ShipPoints, _Scan, _Signature, _Thrust, Hull, _Armour, _PointDefense, _GroupSize, _Tonnage) = shipStats_var,
        !.
    hull() = 0.

    armour(_) = Armour :-
        stats(_ShipPoints, _Scan, _Signature, _Thrust, _Hull, Armour, _PointDefense, _GroupSize, _Tonnage) = shipStats_var,
        !.
    armour(ShieldsUp) = Return :-
        shaltariStats(_ShipPoints, _Scan, _Signature, _Thrust, _Hull, Armour, _PointDefense, _GroupSize, _Tonnage) = shipStats_var,
        arm(Down, Up) = Armour,
        Return = if ShieldsUp = false then Down else dice::getBest(Down, Up) end if,
        !.
    armour(_) = star.

    shields_dt(true) = Up :-
        shaltariStats(_ShipPoints, _Scan, _Signature, _Thrust, _Hull, Shields, _PointDefense, _GroupSize, _Tonnage) = shipStats_var,
        arm(_Down, Up) = Shields.

    pointDefense(_) = PointDefense :-
        stats(_ShipPoints, _Scan, _Signature, _Thrust, _Hull, _Armour, PointDefense, _GroupSize, _Tonnage) = shipStats_var,
        !.
    pointDefense(false) = PointDefense :-
        shaltariStats(_ShipPoints, _Scan, _Signature, _Thrust, _Hull, _Armour, PointDefense, _GroupSize, _Tonnage) = shipStats_var,
        !.
    pointDefense(_) = 0.

    groupSize() = GroupSize :-
        stats(_ShipPoints, _Scan, _Signature, _Thrust, _Hull, _Armour, _PointDefense, GroupSize, _Tonnage) = shipStats_var,
        !.
    groupSize() = GroupSize :-
        shaltariStats(_ShipPoints, _Scan, _Signature, _Thrust, _Hull, _Armour, _PointDefense, GroupSize, _Tonnage) = shipStats_var,
        !.
    groupSize() = g(0, 0).

    tonnage() = Tonnage :-
        stats(_ShipPoints, _Scan, _Signature, _Thrust, _Hull, _Armour, _PointDefense, _GroupSize, Tonnage) = shipStats_var,
        !.
    tonnage() = Tonnage :-
        shaltariStats(_ShipPoints, _Scan, _Signature, _Thrust, _Hull, _Armour, _PointDefense, _GroupSize, Tonnage) = shipStats_var,
        !.
    tonnage() = light(0).

    name() = name_var.

    canShield() :-
        _ = shields_dt(true).

clauses
    getWeaponSystem_nd() = WeaponSystem :-
        WeaponSystem in weaponSystemList.

clauses
    getShipSpecial_nd() = ShipSpecial :-
        ShipSpecial in shipSpecialList.

clauses
    getFleetBuilderStats(ClassName, Stats, Special, Weapons, Constructor) = fbs(ConstructorStats, ClassName, Special, Constructor, Description) :-
        stats(ShipPointsOut, Scan, Signature, Thrust, Hull, Armour, PointDefense, GroupSizeOut, TonnageOut) = Stats,
        Description =
            makeDescription(ClassName, ShipPointsOut, Scan, string::format("      %-17s", toInches(Signature)), Thrust, Hull,
                string::format("   %-15s", rollToString(Armour)), PointDefense, GroupSizeOut, TonnageOut, Special, Weapons),
        ConstructorStats = conStats(ShipPointsOut, GroupSizeOut, TonnageOut).
    getFleetBuilderStats(ClassName, Stats, Special, Weapons, Constructor) = fbs(ConstructorStats, ClassName, Special, Constructor, Description) :-
        shaltariStats(ShipPointsOut, Scan, Signature, Thrust, Hull, Armour, PointDefense, GroupSizeOut, TonnageOut) = Stats,
        Description =
            makeDescription(ClassName, ShipPointsOut, Scan, string::format("%-17s", shaltariSplitToString(Signature)), Thrust, Hull,
                string::format("    %-13s", shaltariSplitToString(Armour)), PointDefense, GroupSizeOut, TonnageOut, Special, Weapons),
        ConstructorStats = conStats(ShipPointsOut, GroupSizeOut, TonnageOut).

class predicates
    makeDescription : (string ClassName, integer ShipPoints, real Scan, string Sig, real Thrust, integer Hull, string Armour, integer PointDefense,
        group GroupSize, tonnage, shipSpecial*, weaponSystem*) -> string.
clauses
    makeDescription(ClassName, ShipPointsOut, Scan, Signature, Thrust, Hull, Armour, PointDefense, GroupSizeOut, TonnageOut, Special, WeaponSystems) =
            Description :-
        StringSpecialList = [ SpecialStringLine || SpecialStringLine = specialListToString_nd(Special) ],
        DescriptionList =
            [ StringRow ||
                StringRow = string::format("%-100s Ship Points %d", ClassName, ShipPointsOut)
                or
                StringRow =
                    string::format("%-15s %-15s %-15s %-15s %-10s %-10s %-10s %-10s %s", "Scan", "Sig", "Thrust", "Hull", "Armour", "PD", "Group",
                        "Tonnage", "Special")
                or
                if [FirstSpecial | RestSpecial] = StringSpecialList then
                    succeed
                else
                    FirstSpecial = "",
                    RestSpecial = []
                end if,
                (StringRow =
                        string::format("%-10s %s %-15s %-15s %s %-10s %-14s %-14s %s", toInches(Scan), Signature, toInches(Thrust), toString(Hull),
                            Armour, toString(PointDefense), toString(GroupSizeOut), tonnageToString(TonnageOut), FirstSpecial)
                    or StringSpecial in RestSpecial
                    and %+
                        StringRow = string::format("%150s", StringSpecial))
            ],
        if [] = WeaponSystems then
            WeaponDescriptionList = []
        else
            WeaponDescriptionList =
                [ StringRow ||
                    StringRow = ""
                    or
                    StringRow = string::format("%-30s %-10s %-10s %-10s %-10s %s", "Type", "Lock", "Attack", "Damage", "Arc", "Special")
                    or
                    weaponSystem(WepName, WepLock, WepAttack, WepDamage, WepArc, WepSpecial) in WeaponSystems, %+
                        StringWeaponSpecialList =
                            [ SpecialStringLine || SpecialStringLine = weaponSpecialListToString_nd(list::removeDuplicates(WepSpecial)) ],
                        if [FirstSpecial | RestSpecial] = StringWeaponSpecialList then
                            succeed
                        else
                            FirstSpecial = "",
                            RestSpecial = []
                        end if,
                        (StringRow = WepName
                            or StringRow =
                                string::format("%35s %-10s % %s %-15s %s", "", rollToString(WepLock), countToString(WepAttack),
                                    countToString(WepDamage), arcsToString(WepArc), FirstSpecial)
                            or StringSpecial in RestSpecial
                            and %+
                                StringRow = string::format("%100s", StringSpecial))
                ]
        end if,
        if launch(LaunchAssets) in Special then
            LaunchNameSet = setM_redBlack::new(),
            LaunchDescriptionList =
                [ StringRow ||
                    StringRow = ""
                    or
                    StringRow = string::format("%-50s %-15s %s", "Load", "Launch", "Special")
                    or
                    LaunchSystem in LaunchAssets, %+
                        if torpedo(TorpedoSystem, Launch, WepSpecial) = LaunchSystem then
                            torpedo_stats(LaunchName, _Thrust, _Lock, _Attack, _Damage, Special2) = TorpedoSystem,
                            LaunchSpecial = list::append(WepSpecial, Special2)
                        else
                            strikeCraft(StrikeCraftSystem, Launch, WepSpecial) = LaunchSystem,
                            LaunchName = getStrikeCraftName(StrikeCraftSystem),
                            Special2 = getStrikeCraftSpecial(StrikeCraftSystem),
                            LaunchSpecial = list::append(WepSpecial, Special2)
                        end if,
                        LaunchNameSet:insert(LaunchSystem),
                        StringWeaponSpecialList =
                            [ SpecialStringLine || SpecialStringLine = weaponSpecialListToString_nd(list::removeDuplicates(LaunchSpecial)) ],
                        if [FirstSpecial | RestSpecial] = StringWeaponSpecialList then
                            succeed
                        else
                            FirstSpecial = "",
                            RestSpecial = []
                        end if,
                        (StringRow = string::format("%-45s %-15d %s", LaunchName, Launch, FirstSpecial)
                            or StringSpecial in RestSpecial
                            and %+
                                StringRow = string::format("%100s", StringSpecial))
                    or
                    not(LaunchNameSet:isEmpty()),
                    StringRow = ""
                    or
                    LaunchSystem in LaunchNameSet, %+
                        if torpedo(TorpedoSystem, _Launch, WepSpecial) = LaunchSystem then
                            torpedo_stats(LaunchName, LaunchThrust, LaunchLock, LaunchAttack, LaunchDamage, Special2) = TorpedoSystem,
                            LaunchThrustStr = toInches(LaunchThrust),
                            LaunchSpecial = list::append(WepSpecial, Special2),
                            LaunchLockStr = rollToString(LaunchLock),
                            LaunchAttackStr = countToString(LaunchAttack),
                            LaunchDamageStr = countToString(LaunchDamage)
                        else
                            strikeCraft(StrikeCraftSystem, Launch, WepSpecial) = LaunchSystem,
                            if fighterBomber_stats(Left, Right) = StrikeCraftSystem then
                                SubSystem = Left
                                or
                                SubSystem = Right
                            else
                                SubSystem = StrikeCraftSystem
                            end if,
                            getStrikeCraftStats_dt(SubSystem, LaunchName, LaunchThrustStr, LaunchLockStr, LaunchAttackStr, LaunchDamageStr),
                            LaunchName = getStrikeCraftName(SubSystem),
                            Special2 = getStrikeCraftSpecial(SubSystem),
                            LaunchSpecial = list::append(WepSpecial, Special2)
                        end if,
                        StringWeaponSpecialList =
                            [ SpecialStringLine || SpecialStringLine = weaponSpecialListToString_nd(list::removeDuplicates(LaunchSpecial)) ],
                        if [FirstSpecial | RestSpecial] = StringWeaponSpecialList then
                            succeed
                        else
                            FirstSpecial = "",
                            RestSpecial = []
                        end if,
                        StringRow =
                            string::format("%-45s %-15s %-15s %-15s %-15s %s", LaunchName, LaunchThrustStr, LaunchLockStr, LaunchAttackStr,
                                LaunchDamageStr, FirstSpecial)
                ]
        else
            LaunchDescriptionList = []
        end if,
        Description = string::concatWithDelimiter(list::append(DescriptionList, WeaponDescriptionList, LaunchDescriptionList), "\n").

class predicates
    getStrikeCraftName : (strikeCraftSystem) -> string Name.
clauses
    getStrikeCraftName(fighter_stats(Name, _Thrust, _PointDefenseBonus, _Special)) = Name.
    getStrikeCraftName(bomber_stats(Name, _Thrust, _Lock, _Attack, _Damage, _Special)) = Name.
    getStrikeCraftName(fighterBomber_stats(_Left, _Right)) = "Fighters & Bombers".
    getStrikeCraftName(bulkLander_stats(Name, _Thrust)) = Name.
    getStrikeCraftName(dropships_stats(Name, _Thrust)) = Name.
    getStrikeCraftName(gate_stats(Name)) = Name.

class predicates
    getStrikeCraftStats_dt : (strikeCraftSystem, string Name [out], string Thrust [out], string Lock [out], string Attack [out], string Damage [out])
        determ.
clauses
    getStrikeCraftStats_dt(fighter_stats(Name, Thrust, PointDefenseBonus, _Special), Name, toInches(Thrust),
            string::format("PD+%d", PointDefenseBonus), "", "").
    getStrikeCraftStats_dt(bomber_stats(Name, Thrust, Lock, Attack, Damage, _Special), Name, toInches(Thrust), rollToString(Lock),
            countToString(Attack), countToString(Damage)).
    getStrikeCraftStats_dt(bulkLander_stats(Name, Thrust), Name, toInches(Thrust), "", "", "").
    getStrikeCraftStats_dt(dropships_stats(Name, Thrust), Name, toInches(Thrust), "", "", "").

class predicates
    getStrikeCraftSpecial : (strikeCraftSystem) -> weaponSpecial*.
clauses
    getStrikeCraftSpecial(fighter_stats(_Name, _Thrust, _PointDefenseBonus, Special)) = Special :-
        !.
    getStrikeCraftSpecial(bomber_stats(_Name, _Thrust, _Lock, _Attack, _Damage, Special)) = Special :-
        !.
    getStrikeCraftSpecial(fighterBomber_stats(Left, Right)) = list::append(List1, List2) :-
        !,
        List1 = getStrikeCraftSpecial(Left),
        List2 = getStrikeCraftSpecial(Right).
    getStrikeCraftSpecial(_) = [].

class predicates
    toInches : (real Val) -> string.
clauses
    toInches(Val) = string::format("%.1f\"", Val).

class predicates
    rollToString : (roll Value) -> string.
clauses
    rollToString(d6(Value, p)) = string::format("%d+", Value).
    rollToString(d6(Value, e)) = string::format("%d", Value).
    rollToString(star) = "*".

class predicates
    countToString : (count Value) -> string.
clauses
    countToString(i(Value)) = string::format("%-15d", Value).
    countToString(nd3plus(N, 0)) = string::format("%-11dD3", N) :-
        !.
    countToString(nd3plus(N, Val)) = string::format("%dD3+%-6d", N, Val).
    countToString(nd6plus(N, 0)) = string::format("%-11dD6", N) :-
        !.
    countToString(nd6plus(N, Val)) = string::format("%dD6+%-6d", N, Val).
    countToString(star) = string::format("%-15s", "*").

class predicates
    arcsToString : (arc*, string Helper = "") -> string.
clauses
    arcsToString([], Helper) = Helper.
    arcsToString([front(narrow) | Rest], Helper) = ReturnStr :-
        !,
        if "" = Helper then
            NextHelper = "F(n)"
        else
            NextHelper = string::format("F(n)/%s", Helper)
        end if,
        ReturnStr = arcsToString(Rest, NextHelper).
    arcsToString([front(_) | Rest], Helper) = ReturnStr :-
        if "" = Helper then
            NextHelper = "F"
        else
            NextHelper = string::format("F/%s", Helper)
        end if,
        ReturnStr = arcsToString(Rest, NextHelper).
    arcsToString([side(right) | Rest], Helper) = ReturnStr :-
        !,
        if "" = Helper then
            NextHelper = "S(r)"
        else
            NextHelper = string::format("%s/S(r)", Helper)
        end if,
        ReturnStr = arcsToString(Rest, NextHelper).
    arcsToString([side(left) | Rest], Helper) = ReturnStr :-
        !,
        if "" = Helper then
            NextHelper = "S(l)"
        else
            NextHelper = string::format("%s/S(l)", Helper)
        end if,
        ReturnStr = arcsToString(Rest, NextHelper).
    arcsToString([side(_) | Rest], Helper) = ReturnStr :-
        if "" = Helper then
            NextHelper = "S"
        else
            NextHelper = string::format("%s/S", Helper)
        end if,
        ReturnStr = arcsToString(Rest, NextHelper).
    arcsToString([rear | Rest], Helper) = ReturnStr :-
        if "" = Helper then
            NextHelper = "R"
        else
            NextHelper = string::format("%s/R", Helper)
        end if,
        ReturnStr = arcsToString(Rest, NextHelper).

class predicates
    tonnageToString : (tonnage) -> string.
clauses
    tonnageToString(light(2)) = "L(2)" :-
        !.
    tonnageToString(light(_)) = "L" :-
        !.
    tonnageToString(medium) = "M" :-
        !.
    tonnageToString(heavy) = "H" :-
        !.
    tonnageToString(superHeavy(2)) = "SH(2)" :-
        !.
    tonnageToString(superHeavy(_)) = "SH" :-
        !.

class predicates
    specialListToString_nd : (shipSpecial*, string Helper = "") -> string nondeterm.
clauses
    specialListToString_nd([], "") = _ :-
        !,
        fail.
    specialListToString_nd([], Helper) = Helper.
    specialListToString_nd([Head | Rest], Helper) = ReturnStr :-
        TestStr = if Helper <> "" then string::format("%s, %s", Helper, shipSpecialToString(Head)) else shipSpecialToString(Head) end if,
        if 40 < string::length(TestStr) then
            ReturnStr = TestStr
            or
            ReturnStr = specialListToString_nd(Rest, "")
        else
            ReturnStr = specialListToString_nd(Rest, TestStr)
        end if.

class predicates
    shipSpecialToString : (shipSpecial) -> string.
clauses
    shipSpecialToString(launch(LaunchAssets)) = ReturnString :-
        !,
        Count = countLaunch(launch(LaunchAssets)),
        ReturnString = if 0 < Count then string::format("launch(%d)", Count) else "launch" end if.
    shipSpecialToString(Special) = toString(Special).

class predicates
    weaponSpecialListToString_nd : (weaponSpecial*, string Helper = "") -> string nondeterm.
clauses
    weaponSpecialListToString_nd([], "") = _ :-
        !,
        fail.
    weaponSpecialListToString_nd([], Helper) = Helper.
    weaponSpecialListToString_nd([Head | Rest], Helper) = ReturnStr :-
        TestStr = if Helper <> "" then string::format("%s, %s", Helper, weaponSpecialToString(Head)) else weaponSpecialToString(Head) end if,
        if 40 < string::length(TestStr) then
            ReturnStr = TestStr
            or
            ReturnStr = weaponSpecialListToString_nd(Rest, "")
        else
            ReturnStr = weaponSpecialListToString_nd(Rest, TestStr)
        end if.

class predicates
    weaponSpecialToString : (weaponSpecial) -> string.
clauses
    weaponSpecialToString(closeAction(standard)) = "closeAction" :-
        !.
    weaponSpecialToString(calibre(RosterCats)) = string::format("calibre(%s)", rosterCatsToString(RosterCats)) :-
        !.
    weaponSpecialToString(Special) = toString(Special).

class predicates
    rosterCatsToString : (rosterCategory*, string Helper = "") -> string.
clauses
    rosterCatsToString([], Helper) = Helper.
    rosterCatsToString([cat_light | Rest], Helper) = ReturnStr :-
        if "" = Helper then
            NextHelper = "L"
        else
            NextHelper = string::format("L,%s", Helper)
        end if,
        ReturnStr = rosterCatsToString(Rest, NextHelper).
    rosterCatsToString([cat_medium | Rest], Helper) = ReturnStr :-
        if "" = Helper then
            NextHelper = "M"
        else
            NextHelper = string::format("M,%s", Helper)
        end if,
        ReturnStr = rosterCatsToString(Rest, NextHelper).
    rosterCatsToString([cat_heavy | Rest], Helper) = ReturnStr :-
        if "" = Helper then
            NextHelper = "H"
        else
            NextHelper = string::format("%s,H", Helper)
        end if,
        ReturnStr = rosterCatsToString(Rest, NextHelper).
    rosterCatsToString([cat_superHeavy | Rest], Helper) = ReturnStr :-
        if "" = Helper then
            NextHelper = "SH"
        else
            NextHelper = string::format("%s,SH", Helper)
        end if,
        ReturnStr = rosterCatsToString(Rest, NextHelper).

class predicates
    shaltariSplitToString : (shaltariSplit) -> string.
clauses
    shaltariSplitToString(sig(Real1, Real2)) = string::format("%s/%s", toInches(Real1), toInches(Real2)).
    shaltariSplitToString(arm(Roll1, Roll2)) = string::format("%s/%s", rollToString(Roll1), rollToString(Roll2)).

class predicates
    trimName : (string Name) -> string TrimmedName.
clauses
    trimName(Name) = Return :-
        string::hasPrefixIgnoreCase(Name, "phr", Return),
        !.
    trimName(Name) = Return :-
        string::hasPrefixIgnoreCase(Name, "scourge", Return),
        !.
    trimName(Name) = Return :-
        string::hasPrefixIgnoreCase(Name, "shaltari", Return),
        !.
    trimName(Name) = Return :-
        string::hasPrefixIgnoreCase(Name, "ucm", Return),
        !.
    trimName(Name) = Return :-
        string::hasPrefixIgnoreCase(Name, "resistance", Return),
        !.
    trimName(Name) = Name.

clauses
    matchRosterCatTonnage_dt(cat_light, light(_)).
    matchRosterCatTonnage_dt(cat_medium, medium).
    matchRosterCatTonnage_dt(cat_heavy, heavy).
    matchRosterCatTonnage_dt(cat_superHeavy, superHeavy(_)).

clauses
    fbsPresenter(FBS) = presenter::noExpand(trimName(ClassName), toAny(FBS)) :-
        fbs(_, ClassName, _, _, _Desc) = FBS.

clauses
    fbsSorter(Left, Right) = Result :-
        getFBSTonnage(Left, LTonnage),
        getFBSTonnage(Right, RTonnage),
        LTonnage <> RTonnage,
        if light(X) = LTonnage then
            Result = if light(Y) = RTonnage then compare(X, Y) else less end if
        elseif medium = LTonnage then
            Result = if light(_Y) = RTonnage then greater else less end if
        elseif heavy = LTonnage then
            Result = if light(_Y) = RTonnage or medium = RTonnage then greater else less end if
        else
            superHeavy(X) = LTonnage,
            Result = if superHeavy(Y) = RTonnage then compare(X, Y) else greater end if
        end if,
        !.
    fbsSorter(Left, Right) = Result :-
        getFBSPoints(Left, LPoints),
        getFBSPoints(Right, RPoints),
        LPoints <> RPoints,
        Result = compare(LPoints, RPoints),
        !.
    fbsSorter(Left, Right) = Result :-
        getFBSName(Left, LName),
        getFBSName(Right, RName),
        Result = compare(LName, RName).

clauses
    getFBSLaunchCount(FBS, LaunchCount:value) :-
        fbs(conStats(_Points, g(_Min, _Max), _Tonnage), _Name, SpecialList, _Con, _Desc) = FBS,
        LaunchCount = varM_integer::new(0),
        if launch(LaunchAssets) in SpecialList then
            LaunchCount:add(countLaunch(launch(LaunchAssets)))
        end if.

class predicates
    countLaunch : (shipSpecial) -> integer.
clauses
    countLaunch(launch(LaunchAssets)) = LaunchCount:value :-
        !,
        LaunchCount = varM_integer::new(0),
        foreach LaunchSystem in LaunchAssets do
            if torpedo(_, TorpLaunch, _) = LaunchSystem then
                LaunchCount:add(TorpLaunch)
            end if,
            if strikeCraft(StrikeCraftSystem, StrikeLaunch, _) = LaunchSystem then
                if dropships_stats(_, _) = StrikeCraftSystem then
                elseif bulkLander_stats(_, _) = StrikeCraftSystem then
                elseif gate_stats(_) = StrikeCraftSystem then
                else
                    LaunchCount:add(StrikeLaunch)
                end if
            end if
        end foreach.
    countLaunch(_) = 0.

clauses
    getFBSName(fbs(conStats(_Points, g(_Min, _Max), _Tonnage), Name, _SpecialList, _Con, _Desc), Name).

clauses
    getFBSDesc(fbs(conStats(_Points, g(_Min, _Max), _Tonnage), _Name, _SpecialList, _Con, Desc), Desc).

clauses
    getFBSPoints(fbs(conStats(Points, g(_Min, _Max), _Tonnage), _Name, _SpecialList, _Con, _Desc), Points).

clauses
    getFBSTonnage(fbs(conStats(_Points, g(_Min, _Max), Tonnage), _Name, _SpecialList, _Con, _Desc), Tonnage).

clauses
    getFBSDropBulkCount(FBS, DropCount:value, BulkCount:value) :-
        fbs(conStats(_Points, g(_Min, _Max), _Tonnage), _Name, SpecialList, _Con, _Desc) = FBS,
        DropCount = varM_integer::new(0),
        BulkCount = varM_integer::new(0),
        if launch(LaunchAssets) in SpecialList then
            countDropBulk(launch(LaunchAssets), Drops, Bulks),
            DropCount:add(Drops),
            BulkCount:add(Bulks),
            DropCount:add(countGate(launch(LaunchAssets)))
        end if.

class predicates
    countGate : (shipSpecial) -> integer.
clauses
    countGate(launch(LaunchAssets)) = LaunchCount:value :-
        !,
        LaunchCount = varM_integer::new(0),
        foreach LaunchSystem in LaunchAssets do
            if strikeCraft(StrikeCraftSystem, StrikeLaunch, _) = LaunchSystem then
                if dropships_stats(_, _) = StrikeCraftSystem then
                elseif bulkLander_stats(_, _) = StrikeCraftSystem then
                elseif gate_stats(_) = StrikeCraftSystem then
                    LaunchCount:add(StrikeLaunch)
                end if
            end if
        end foreach.
    countGate(_) = 0.

class predicates
    countDropBulk : (shipSpecial, integer [out], integer [out]).
clauses
    countDropBulk(launch(LaunchAssets), DropCount:value, BulkCount:value) :-
        !,
        DropCount = varM_integer::new(0),
        BulkCount = varM_integer::new(0),
        foreach LaunchSystem in LaunchAssets do
            if strikeCraft(StrikeCraftSystem, StrikeLaunch, _) = LaunchSystem then
                if dropships_stats(_, _) = StrikeCraftSystem then
                    DropCount:add(StrikeLaunch)
                elseif bulkLander_stats(_, _) = StrikeCraftSystem then
                    BulkCount:add(StrikeLaunch)
                elseif gate_stats(_) = StrikeCraftSystem then
                end if
            end if
        end foreach.
    countDropBulk(_, 0, 0).

clauses
    getFBSIsRare(FBS, true) :-
        fbs(conStats(_Points, g(_Min, _Max), _Tonnage), _Name, SpecialList, _Con, _Desc) = FBS,
        list::isMember(rare, SpecialList),
        !.
    getFBSIsRare(_FBS, false).

clauses
    getFBSImageFile(fbs(conStats(_Points, g(_Min, _Max), _Tonnage), Name, _SpecialList, _Con, _Desc), ImageFile) :-
        ImageFile = string::format("../images/%s.png", Name).

end implement shipClass
