% Copyright

implement fleetBuilder
    open core, shipClass

class facts
    totalPoints : integer := 0.
    gameSize_var : gameSize := skirmish.
    listSet : mapM{integer Cost, mapM{groupTemplate*, setM{tuple{integer Count, shipClass::fleetBuilderStats}**}}} := erroneous.

clauses
    buildFleet_nd(Points, AvailableShips) :-
        gameSize_var := getGameSize_dt(Points),
        totalPoints := Points,
        listSet := mapM_redBlack::new(),
        foreach tuple(TotalCost, TotalList) = generateCostLists_nd(AvailableShips) do
            SetMap = listSet:get_default(TotalCost, mapM_redBlack::new()),
            _Subset = SetMap:get_default(TotalList, setM_redBlack::new())
        end foreach.
%        fleetSize(_, tuple(MinPoints, MaxPoints), shipClass::g(PMin, PMax), shipClass::g(LMin, LMax), shipClass::g(VMin, VMax),
%                shipClass::g(FMin, FMax), MaxGroups, _, _, _)
%            = gameSize_var,
%        PCount = std::fromTo(PMin, PMax), %+
%            PCount <= MaxGroups,
%            LCount = std::fromTo(LMin, LMax), %+
%                LCount + PCount <= MaxGroups,
%                VCount = std::fromTo(VMin, VMax), %+
%                    VCount + LCount + PCount <= MaxGroups,
%                    FCount = std::fromTo(FMin, FMax), %+
%                        FCount + VCount + LCount + PCount <= MaxGroups,
%                        tuple(TotalCost, BattlegroupTemplateList) = generateBattlegroups_nd(PCount, LCount, VCount, FCount, FBSList),
%                        specialOK_dt(BattlegroupTemplateList),
%                        SubMap = listSet:get_default(TotalCost, mapM_redBlack::new()),
%                        ReducedGroup = reduceBattlegroup(BattlegroupTemplateList),
%                        Subset = SubMap:get_default(ReducedGroup, setM_redBlack::new()),
%                        Subset:insert(list::sort(BattlegroupTemplateList)),
%                        totalCount := totalCount + 1,
%                        nothing(BattlegroupTemplateList),
    buildFleet_nd(_, _) :-
        nothing(listSet).

class predicates
    generateCostLists_nd : (tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}*, integer CurrentCost = 0,
        groupTemplate* CurrentGroups = []) -> tuple{integer Cost, groupTemplate*} nondeterm.
clauses
    generateCostLists_nd([], CurrentCost, CurrentGroups) = tuple(CurrentCost, list::sort(CurrentGroups)) :-
        checkConditions_dt(CurrentCost, CurrentGroups).
    generateCostLists_nd([Group | RemainingList], CurrentCost, CurrentGroups) = Return :-
        tuple(MinAmount, MaxAmount, FBS) = Group,
        fbs(conStats(Points, g(GroupMin, GroupMax), _Tonnage), _Name, _SpecialList, _Con) = FBS,
        MaxLaunch = getMaxLaunch(gameSize_var),
        MaxRares = getMaxRares(gameSize_var),
        getFBSLaunchCount(FBS, LaunchCount),
        getFBSIsRare(FBS, IsRare),
        if true = IsRare then
            Upper = math::min(MaxRares * GroupMax, MaxAmount)
        else
            Upper = MaxAmount
        end if,
        Lower = math::max(MinAmount, GroupMin),
        Count = std::fromTo(Lower, Upper), %+
            NewCost = Points * Count,
            TotalCost = NewCost + CurrentCost,
            TotalCost <= totalPoints,
            Count * LaunchCount <= MaxLaunch,
            NewGroup = group(FBS, Count),
            Return = generateCostLists_nd(RemainingList, TotalCost, [NewGroup | CurrentGroups]).
    generateCostLists_nd([Group | RemainingList], CurrentCost, CurrentGroups) = Return :-
        tuple(MinAmount, _MaxAmount, _FBS) = Group,
        MinAmount = 0,
        Return = generateCostLists_nd(RemainingList, CurrentCost, CurrentGroups).

class predicates
    checkConditions_dt : (integer CurrentCost, groupTemplate* CurrentGroups) determ.
clauses
    checkConditions_dt(CurrentCost, _CurrentGroups) :-
        30 < totalPoints - CurrentCost,
        !,
        fail.
    checkConditions_dt(CurrentCost, _CurrentGroups) :-
        totalPoints - CurrentCost < 0,
        !,
        fail.
    checkConditions_dt(_CurrentCost, CurrentGroups) :-
        MaxLaunch = getMaxLaunch(gameSize_var),
        TotalLaunch =
            list::fold(CurrentGroups,
                { (Group, CurrentLaunch) = CurrentLaunch + Count * Launch :-
                    group(FBS, Count) = Group,
                    getFBSLaunchCount(FBS, Launch)
                },
                0),
        MaxLaunch < TotalLaunch,
        !,
        fail.
    checkConditions_dt(_CurrentCost, CurrentGroups) :-
        tuple(TotalDrop, TotalBulk) =
            list::fold(CurrentGroups,
                { (Group, tuple(CDrop, CBulk)) = tuple(CDrop + Count * Drop, CBulk + Count * Bulk) :-
                    group(FBS, Count) = Group,
                    getFBSDropBulkCount(FBS, Drop, Bulk)
                },
                tuple(0, 0)),
        TotalDrop = 0,
        TotalBulk = 0,
        !,
        fail.
    checkConditions_dt(_CurrentCost, _CurrentGroups).

/*
         fleetSize(Name, tuple(MinPoints, MaxPoints), shipClass::g(PMin, PMax), shipClass::g(LMin, LMax), shipClass::g(VMin, VMax), shipClass::g(FMin, FMax), MaxGroups, MaxLaunch, MaxRares, MaxGroupSize)
            = gameSize_var
*/
class predicates
    getPointRange : (gameSize) -> tuple{integer, integer}.
clauses
    getPointRange(GameSize) = Range :-
        fleetSize(_, Range, _, _, _, _, _, _, _, _) = GameSize,
        !.
    getPointRange(_) = tuple(0, 0).

class predicates
    getMaxLaunch : (gameSize) -> integer.
clauses
    getMaxLaunch(GameSize) = MaxLaunch :-
        fleetSize(_, _, _, _, _, _, _, MaxLaunch, _, _) = GameSize,
        !.
    getMaxLaunch(_) = 0.

class predicates
    getMaxRares : (gameSize) -> integer.
clauses
    getMaxRares(GameSize) = MaxRares :-
        fleetSize(_, _, _, _, _, _, _, _, MaxRares, _) = GameSize,
        !.
    getMaxRares(_) = 0.

class predicates
    generateBattlegroups_nd : (integer P, integer L, integer V, integer F, groupTemplate* AvailableList) -> battlegroupTemplate* nondeterm.
clauses
    generateBattlegroups_nd(0, 0, 0, 0, []) = [] :-
        !.
    generateBattlegroups_nd(P, L, V, F, AvailableList) = [Battlegroup | Battlegroups] :-
        P > 0,
        Battlegroup = generateBattlegroup_nd(AvailableList, pathfinder, RemainingList),
        Battlegroups = generateBattlegroups_nd(P - 1, L, V, F, RemainingList).
    generateBattlegroups_nd(_P, _L, _V, _F, _AvailableList) = _ :-
        !,
        fail.

class predicates
    generateBattlegroup_nd : (groupTemplate* AvailableList, battlegroupType Type, groupTemplate* RemainingList [out]) -> battlegroupTemplate nondeterm.
clauses
    generateBattlegroup_nd(AvailableList, Type, RemainingList) = bg(Type, [Groups]) :-
        Groups in AvailableList, %+
            RemainingList = list::remove(AvailableList, Groups).

/*
    generateBattlegroups_nd(PointsRemaining, P, L, V, F, FBSList) = tuple(Cost + ReturnCost, [list::sort(Grouplist) | ReturnGroup]) :-
        !,
        battlegroupSize(TonnageList, Groups) = pathfinder,
        tuple(Cost, Grouplist) = generateForTonnageList(Groups, TonnageList, FBSList),
        tuple(ReturnCost, ReturnGroup) = generateBattlegroups_nd(PointsRemaining - Cost, P - 1, L, V, F, FBSList).
    generateBattlegroups_nd(PointsRemaining, 0, L, V, F, FBSList) = tuple(Cost + ReturnCost, [list::sort(Grouplist) | ReturnGroup]) :-
        L > 0,
        !,
        battlegroupSize(TonnageList, Groups) = line,
        tuple(Cost, Grouplist) = generateForTonnageList(Groups, TonnageList, FBSList),
        tuple(ReturnCost, ReturnGroup) = generateBattlegroups_nd(PointsRemaining - Cost, 0, L - 1, V, F, FBSList).
    generateBattlegroups_nd(PointsRemaining, 0, 0, V, F, FBSList) = tuple(Cost + ReturnCost, [list::sort(Grouplist) | ReturnGroup]) :-
        V > 0,
        !,
        battlegroupSize(TonnageList, Groups) = vanguard,
        tuple(Cost, Grouplist) = generateForTonnageList(Groups, TonnageList, FBSList),
        tuple(ReturnCost, ReturnGroup) = generateBattlegroups_nd(PointsRemaining - Cost, 0, 0, V - 1, F, FBSList).
    generateBattlegroups_nd(PointsRemaining, 0, 0, 0, F, FBSList) = tuple(Cost + ReturnCost, [list::sort(Grouplist) | ReturnGroup]) :-
        F > 0,
        !,
        battlegroupSize(TonnageList, Groups) = flag,
        tuple(Cost, Grouplist) = generateForTonnageList(Groups, TonnageList, FBSList),
        tuple(ReturnCost, ReturnGroup) = generateBattlegroups_nd(PointsRemaining - Cost, 0, 0, 0, F - 1, FBSList).
*/
/*
class predicates
    reduceBattlegroup : (tuple{integer Count, shipClass::fleetBuilderStats}**) -> tuple{integer Count, shipClass::fleetBuilderStats}*.
clauses
    reduceBattlegroup(ListList) = list::sort(ReturnList) :-
        Map = mapM_redBlack::new(),
        foreach Battlegroup in ListList do
            foreach Group in Battlegroup and tuple(Count, FBS) = Group do
                GroupCount = Map:get_default(FBS, 0),
                Map:set(FBS, GroupCount + Count)
            end foreach
        end foreach,
        ReturnList = [ tuple(FinalCount, FBS) || tuple(FBS, FinalCount) = Map:getAll_nd() ].
*/
/*
class facts
    dropOk : boolean := false.

class predicates
    specialOK_dt : (tuple{integer Count, shipClass::fleetBuilderStats}**) determ.
clauses
    specialOK_dt(BattlegroupList) :-
        LaunchCount = varM_integer::new(0),
        DropCount = varM_integer::new(0),
        BulkCount = varM_integer::new(0),
        dropOK := false,
        RareMap = mapM_redBlack::new(),
        fleetSize(_Name, _Tuple, _Pathfinder, _Line, _Vanguard, _Flag, _MaxGroups, MaxLaunch, MaxRares, _GroupSize) = gameSize_var,
        Battlegroup in BattlegroupList, %+
            Group in Battlegroup, %+
                tuple(Count, FBS) = Group,
                fbs(_constructorStats, ClassName, SpecialList, _Constructor) = FBS,
                if list::isMember(rare, SpecialList) then
                    CurrentRares = RareMap:get_default(ClassName, 0),
                    TotalRares = CurrentRares + 1,
                    if TotalRares > MaxRares then
                        !,
                        fail
                    end if,
                    RareMap:set(ClassName, TotalRares)
                end if,
                if launch(LaunchAssets) in SpecialList then
                    LaunchSystem in LaunchAssets, %+
                        if torpedo(_, Launch, _) = LaunchSystem then
                            LaunchCount:add(Launch * Count)
                        elseif strikeCraft(StrikeCraftSystem, Launch, _) = LaunchSystem then
                            if dropships_stats(_, _) = StrikeCraftSystem then
                                DropCount:add(Launch * Count)
                            elseif bulkLander_stats(_, _) = StrikeCraftSystem then
                                BulkCount:add(Launch * Count)
                            else
                                LaunchCount:add(Launch * Count)
                            end if
                        end if,
                        if LaunchCount:value > MaxLaunch then
                            !,
                            fail
                        end if,
                        TroopVal = 3 * BulkCount:value + 2 * DropCount:value,
                        if 4 < TroopVal and TroopVal < 12 then
                            dropOk := true
                        else
                            dropOk := false
                        end if
                end if,
        fail.
    specialOK_dt(_) :-
        dropOk = true.

class predicates
    generateForTonnageList : (integer GroupsLeft, tuple{shipClass::rosterCategory, shipClass::group}*, shipClass::fleetBuilderStats*)
        -> tuple{integer PointCost, tuple{integer Count, shipClass::fleetBuilderStats}*} nondeterm.
clauses
    generateForTonnageList(0, _TonnageType, _FBSList) = tuple(0, []) :-
        !.
    generateForTonnageList(_GroupsLeft, [], _FBSList) = tuple(0, []) :-
        !.
    generateForTonnageList(GroupsLeft, [TonnageType | Rest], FBSList) = tuple(FullPoints, list::append(Groups, ReturnList)) :-
        tuple(Category, shipClass::g(Min, Max)) = TonnageType,
        Upper = math::min(GroupsLeft, Max),
        AppropriateList =
            list::filter(FBSList,
                { (Elem) :-
                    fbs(conStats(_ShipPoints, _GroupSize, ClassTonnage), _ClassName, _Special, _Con) = Elem,
                    matchRosterCatTonnage_dt(Category, ClassTonnage)
                }),
        Count = std::fromTo(Min, Upper), %+
            tuple(PointCost, Groups) = buildNGroups_nd(Count, AppropriateList),
            tuple(ReturnCost, ReturnList) = generateForTonnageList(GroupsLeft - 1, Rest, FBSList),
            FullPoints = PointCost + ReturnCost,
            fleetSize(_Name, _Tuple, _Pathfinder, _Line, _Vanguard, _Flag, _MaxGroups, _MaxLaunch, _MaxRares, GroupSize) = gameSize_var,
            FullPoints / GroupSize < totalPoints.

class predicates
    buildNGroups_nd : (integer Count, shipClass::fleetBuilderStats*) -> tuple{integer Points, tuple{integer Count, shipClass::fleetBuilderStats}*}
        nondeterm.
clauses
    buildNGroups_nd(0, _) = tuple(0, []) :-
        !.
    buildNGroups_nd(Count, FBSList) = tuple(PointCost + ReturnCost, [Group | ReturnList]) :-
        ShipClass in FBSList, %+
            fbs(conStats(_Points, g(Min, Max), _Tonnage), _ClassName, _Special, _Con) = ShipClass,
            Num = std::fromTo(Min, Max), %+
                Group = tuple(Num, ShipClass),
                PointCost = groupPointCost(Group),
                tuple(ReturnCost, ReturnList) = buildNGroups_nd(Count - 1, FBSList).

class predicates
    groupPointCost : (tuple{integer Count, shipClass::fleetBuilderStats}) -> integer PointCost.
clauses
    groupPointCost(tuple(Num, ShipClass)) = Points :-
        fbs(ConStats, _, _, _) = ShipClass,
        conStats(ShipPoints, _, _) = ConStats,
        Points = Num * ShipPoints.
*/
class predicates
    getGameSize_dt : (integer) -> gameSize determ.
clauses
    getGameSize_dt(Points) = skirmish :-
        tuple(Lower, _Upper) = getPointRange(skirmish),
        Points < Lower,
        !.
    getGameSize_dt(Points) = FleetSize :-
        FleetSize in [skirmish, clash, battle], %+
            tuple(Lower, Upper) = getPointRange(FleetSize),
            Lower <= Points,
            Points <= Upper,
        !.
    getGameSize_dt(Points) = MinFleetSizeVar:value :-
        tuple(_Lower, Upper) = getPointRange(battle),
        Upper < Points,
        MinFleetSizeVar = varM::new(extraSize([])),
        MinFleetPointsVar = varM::new(tuple(3 * Points, 3 * Points)),
        foreach FleetSize = getGameSize_nd(Points) do
            MaxFleetPoints = getMaxSize(FleetSize),
            if MaxFleetPoints < MinFleetPointsVar:value then
                MinFleetSizeVar:value := FleetSize,
                MinFleetPointsVar:value := MaxFleetPoints
            end if
        end foreach,
        !.

class predicates
    getGameSize_nd : (integer) -> gameSize nondeterm.
clauses
    getGameSize_nd(0) = extraSize([]).
    getGameSize_nd(Points) = FleetSize :-
        FleetSize in [skirmish, clash, battle], %+
            fleetSize(_Name, tuple(Lower, Upper), _Pathfinder, _Line, _Vanguard, _Flag, _MaxGroups, _MaxLaunch, _MaxRares, _GroupSize) = FleetSize,
            Lower <= Points,
            Points <= Upper.
    getGameSize_nd(Points) = Return :-
        FleetSize in [skirmish, clash, battle], %+
            fleetSize(_Name, tuple(_Lower, Upper), _Pathfinder, _Line, _Vanguard, _Flag, _MaxGroups, _MaxLaunch, _MaxRares, _GroupSize) = FleetSize,
            Points > Upper,
            SubFleetSize = getGameSize_nd(Points - Upper),
            if extraSize(SubList) = SubFleetSize then
                Return = extraSize([FleetSize | SubList])
            else
                Return = extraSize([FleetSize, SubFleetSize])
            end if.

class predicates
    getMaxSize : (gameSize) -> tuple{integer Groups, integer MaxPoints}.
clauses
    getMaxSize(fleetSize(_Name, tuple(_Lower, Upper), _Pathfinder, _Line, _Vanguard, _Flag, _MaxGroups, _MaxLaunch, _MaxRares, _GroupSize)) =
        tuple(1, Upper).
    getMaxSize(extraSize([])) = tuple(0, 0).
    getMaxSize(extraSize([Head | Tail])) = tuple(Groups1 + Groups2, Points1 + Points2) :-
        tuple(Groups1, Points1) = getMaxSize(Head),
        tuple(Groups2, Points2) = getMaxSize(extraSize(Tail)).

end implement fleetBuilder
