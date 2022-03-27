% Copyright

class generateCostListDlg : generateCostListDlg
    open core

domains
    faction = ucm; scourge; phr; shaltari; resistance.

predicates
    display : (window Parent, faction, tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}* Fleet = []) -> generateCostListDlg Dialog.

constructors
    new : (window Parent, faction, tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}* Fleet).

predicates
    fillFactionMap : (faction, tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}* OwnedFleet)
        -> tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}* FullFleet.

end class generateCostListDlg
