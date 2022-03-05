% Copyright

class fleetBuilder
    open core, shipClass

domains
    gameSize =
        fleetSize(
            string Name,
            tuple{integer, integer} TotalPoints,
            shipClass::group Pathfinder,
            shipClass::group Line,
            shipClass::group Vanguard,
            shipClass::group Flag,
            integer MaxGroups,
            integer MaxLaunch,
            integer MaxRares,
            real MaxGroupSize);
        extraSize(gameSize*).
    battlegroupType = battlegroupSize(tuple{rosterCategory, shipClass::group}*, integer Max).
    battlegroupTemplate = bg(battlegroupType, groupTemplate*).
    fleet = fleet(gameSize, battlegroupTemplate*).
    groupTemplate =
        group(shipClass::fleetBuilderStats, integer Count)
        [presenter(fleetBuilder::groupTemplatePresenter)].

constants
    skirmish : gameSize =
        fleetSize("Skirmish", tuple(500, 999), shipClass::g(0, 2), shipClass::g(1, 2), shipClass::g(0, 1), shipClass::g(0, 0), 4, 10, 1, 0.5).
    clash : gameSize =
        fleetSize("Clash", tuple(1000, 1999), shipClass::g(1, 2), shipClass::g(1, 3), shipClass::g(0, 2), shipClass::g(0, 1), 6, 15, 2, 0.33).
    battle : gameSize =
        fleetSize("Battle", tuple(2000, 3000), shipClass::g(1, 3), shipClass::g(1, 4), shipClass::g(0, 3), shipClass::g(0, 2), 7, 20, 3, 0.33).
    pathfinder : battlegroupType = battlegroupSize([tuple(cat_light, shipClass::g(1, 3)), tuple(cat_medium, shipClass::g(0, 1))], 3).
    line : battlegroupType = battlegroupSize([tuple(cat_light, shipClass::g(0, 2)), tuple(cat_medium, shipClass::g(1, 3))], 3).
    vanguard : battlegroupType =
        battlegroupSize([tuple(cat_light, shipClass::g(0, 1)), tuple(cat_medium, shipClass::g(0, 1)), tuple(cat_heavy, shipClass::g(1, 2))], 3).
    flag : battlegroupType = battlegroupSize([tuple(cat_light, shipClass::g(0, 1)), tuple(cat_superHeavy, shipClass::g(1, 2))], 3).

predicates
    buildFleetCostMap_dt : (integer LowerPoints, integer UpperPoints, tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}*) determ.

predicates
    getListSet : () -> mapM{integer Cost, mapM{groupTemplate*, setM{fleet}}}.

predicates
    groupTemplatePresenter : presenter::presenter{groupTemplate}.

predicates
    getUCMList : () -> fleetBuilderStats*.
    getScourgeList : () -> fleetBuilderStats*.
    getPHRList : () -> fleetBuilderStats*.
    getShaltariList : () -> fleetBuilderStats*.
    getResistanceList : () -> fleetBuilderStats*.

end class fleetBuilder
