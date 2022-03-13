class shipClass : shipClass

constructors
    new : (shipStats, shipSpecial*, weaponSystem*, string Name).

predicates
    getFleetBuilderStats : (string ClassName, shipStats, shipSpecial*, core::function{ship} Constructor) -> fleetBuilderStats.

predicates
    matchRosterCatTonnage_dt : (shipClass::rosterCategory, shipClass::tonnage) determ.

predicates
    fbsPresenter : presenter::presenter{fleetBuilderStats}.
    fbsSorter : core::comparator{fleetBuilderStats}.

predicates
    getFBSName : (fleetBuilderStats, string Name [out]).

predicates
    getFBSPoints : (fleetBuilderStats, integer Points [out]).

predicates
    getFBSTonnage : (fleetBuilderStats, tonnage [out]).

predicates
    getFBSLaunchCount : (fleetBuilderStats, integer LaunchCount [out]).

predicates
    getFBSDropBulkCount : (fleetBuilderStats, integer DropCount [out], integer BulkCount [out]).

predicates
    getFBSIsRare : (fleetBuilderStats, boolean IsRare [out]).

predicates
    getFBSImageFile : (fleetBuilderStats, string ImageFile [out]).

end class shipClass
