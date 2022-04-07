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
        StringSpecialList = [ SpecialStringLine || SpecialStringLine = specialListToString_nd(Special) ],
        DescriptionList =
            [ StringRow ||
                StringRow = string::format("%-30s     Ship Points %d", ClassName, ShipPointsOut)
                or
                StringRow =
                    string::format("%-30s %-10s %-10s %-10s %-10s %-10s %-10s %-10s %-10s %s", "Name", "Scan", "Sig", "Thrust", "Hull", "Armour",
                        "PD", "Group", "Tonnage", "Special")
                or
                if [FirstSpecial | RestSpecial] = StringSpecialList then
                    succeed
                else
                    FirstSpecial = "",
                    RestSpecial = []
                end if,
                (StringRow =
                        string::format("%-30s %-10s %-10s %-15s %-10s %-15s %-10s %-15s %-10s %s", trimName(ClassName), toInches(Scan),
                            toInches(Signature), toInches(Thrust), toString(Hull), rollToString(Armour), toString(PointDefense),
                            toString(GroupSizeOut), tonnageToString(TonnageOut), FirstSpecial)
                    or StringSpecial in RestSpecial
                    and %+
                        StringRow = string::format("%180s", StringSpecial))
            ],
        Description = string::concatWithDelimiter(DescriptionList, "\n"),
        ConstructorStats = conStats(ShipPointsOut, GroupSizeOut, TonnageOut).
    getFleetBuilderStats(ClassName, Stats, Special, Weapons, Constructor) = fbs(ConstructorStats, ClassName, Special, Constructor, Description) :-
        shaltariStats(ShipPointsOut, Scan, Signature, Thrust, Hull, Armour, PointDefense, GroupSizeOut, TonnageOut) = Stats,
        StringSpecialList = [ SpecialStringLine || SpecialStringLine = specialListToString_nd(Special) ],
        DescriptionList =
            [ StringRow ||
                StringRow = string::format("%-30s     Ship Points %d", ClassName, ShipPointsOut)
                or
                StringRow =
                    string::format("%-30s %-10s %-10s %-10s %-10s %-10s %-10s %-10s %-10s %s", "Name", "Scan", "Sig", "Thrust", "Hull", "Armour",
                        "PD", "Group", "Tonnage", "Special")
                or
                if [FirstSpecial | RestSpecial] = StringSpecialList then
                    succeed
                else
                    FirstSpecial = "",
                    RestSpecial = []
                end if,
                (StringRow =
                        string::format("%-30s %-10s %-10s %-15s %-10s %-15s %-10s %-15s %-10s %s", trimName(ClassName), toInches(Scan),
                            shaltariSplitToString(Signature), toInches(Thrust), toString(Hull), shaltariSplitToString(Armour),
                            toString(PointDefense), toString(GroupSizeOut), tonnageToString(TonnageOut), FirstSpecial)
                    or StringSpecial in RestSpecial
                    and %+
                        StringRow = string::format("%180s", StringSpecial))
            ],
        Description = string::concatWithDelimiter(DescriptionList, "\n"),
        ConstructorStats = conStats(ShipPointsOut, GroupSizeOut, TonnageOut).

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
        if 20 < string::length(TestStr) then
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
