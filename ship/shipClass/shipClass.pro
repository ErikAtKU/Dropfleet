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
        Return = if ShieldsUp = true then Up else Down end if,
        !.
    armour(_) = d3(4, e).

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

clauses
    getWeaponSystem_nd() = WeaponSystem :-
        WeaponSystem in weaponSystemList.

clauses
    getShipSpecial_nd() = ShipSpecial :-
        ShipSpecial in shipSpecialList.

clauses
    getFleetBuilderStats(Stats) = conStats(ShipPointsOut, GroupSizeOut, TonnageOut) :-
        stats(ShipPointsOut, _Scan, _Signature, _Thrust, _Hull, _Armour, _PointDefense, GroupSizeOut, TonnageOut) = Stats.
    getFleetBuilderStats(Stats) = conStats(ShipPointsOut, GroupSizeOut, TonnageOut) :-
        shaltariStats(ShipPointsOut, _Scan, _Signature, _Thrust, _Hull, _Armour, _PointDefense, GroupSizeOut, TonnageOut) = Stats.

clauses
    matchRosterCatTonnage_dt(cat_light, light(_)).
    matchRosterCatTonnage_dt(cat_medium, medium).
    matchRosterCatTonnage_dt(cat_heavy, heavy).
    matchRosterCatTonnage_dt(cat_superHeavy, superHeavy(_)).

clauses
    fbsPresenter(FBS) = presenter::noExpand(ClassName, toAny(FBS)) :-
        fbs(_, ClassName, _, _) = FBS.

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
        fbs(conStats(_Points, g(_Min, _Max), _Tonnage), _Name, SpecialList, _Con) = FBS,
        LaunchCount = varM_integer::new(0),
        if launch(LaunchAssets) in SpecialList then
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
            end foreach
        end if.

clauses
    getFBSName(fbs(conStats(_Points, g(_Min, _Max), _Tonnage), Name, _SpecialList, _Con), Name).

clauses
    getFBSPoints(fbs(conStats(Points, g(_Min, _Max), _Tonnage), _Name, _SpecialList, _Con), Points).

clauses
    getFBSTonnage(fbs(conStats(_Points, g(_Min, _Max), Tonnage), _Name, _SpecialList, _Con), Tonnage).

clauses
    getFBSDropBulkCount(FBS, DropCount:value, BulkCount:value) :-
        fbs(conStats(_Points, g(_Min, _Max), _Tonnage), _Name, SpecialList, _Con) = FBS,
        DropCount = varM_integer::new(0),
        BulkCount = varM_integer::new(0),
        if launch(LaunchAssets) in SpecialList then
            foreach LaunchSystem in LaunchAssets do
                if strikeCraft(StrikeCraftSystem, StrikeLaunch, _) = LaunchSystem then
                    if dropships_stats(_, _) = StrikeCraftSystem then
                        DropCount:add(StrikeLaunch)
                    elseif bulkLander_stats(_, _) = StrikeCraftSystem then
                        BulkCount:add(StrikeLaunch)
                    elseif gate_stats(_) = StrikeCraftSystem then
                        DropCount:add(StrikeLaunch)
                    end if
                end if
            end foreach
        end if.

clauses
    getFBSIsRare(FBS, true) :-
        fbs(conStats(_Points, g(_Min, _Max), _Tonnage), _Name, SpecialList, _Con) = FBS,
        list::isMember(rare, SpecialList),
        !.
    getFBSIsRare(_FBS, false).

clauses
    getFBSImageFile(fbs(conStats(_Points, g(_Min, _Max), _Tonnage), Name, _SpecialList, _Con), ImageFile) :-
        ImageFile = string::format("../images/%s.png", Name).

end implement shipClass
