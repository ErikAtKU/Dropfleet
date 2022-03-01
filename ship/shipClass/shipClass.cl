class shipClass : shipClass

constructors
    new : (shipStats, shipSpecial*, weaponSystem*, string Name).

predicates
    getFleetBuilderStats : (shipStats) -> constructorStats.

predicates
    matchRosterCatTonnage_dt : (shipClass::rosterCategory, shipClass::tonnage) determ.

predicates
    fbsPresenter : presenter::presenter{fleetBuilderStats}.

predicates
    getFBSLaunchCount : (fleetBuilderStats, integer LaunchCount [out]).

predicates
    getFBSDropBulkCount : (fleetBuilderStats, integer DropCount [out], integer BulkCount [out]).

predicates
    getFBSIsRare : (fleetBuilderStats, boolean IsRare [out]).

end class shipClass
