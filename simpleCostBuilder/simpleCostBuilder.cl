% Copyright

class simpleCostBuilder : simpleCostBuilder
    open core

predicates
    display : (window Parent, generateCostListDlg::faction, fleet::fleetCount* FleetCount = []) -> simpleCostBuilder Dialog.

constructors
    new : (window Parent, tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}* Fleet, generateCostListDlg::faction).

end class simpleCostBuilder
