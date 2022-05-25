% Copyright

class simpleCostBuilder : simpleCostBuilder
    open core

predicates
    display : (window Parent, generateCostListDlg::faction, tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}* Fleet = [])
        -> simpleCostBuilder Dialog.

constructors
    new : (window Parent, tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}* Fleet).

end class simpleCostBuilder
