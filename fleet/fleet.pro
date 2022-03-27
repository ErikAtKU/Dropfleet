% Copyright

implement fleet
    open core

clauses
    resetCount() :-
        myUCMShips := [],
        myScourgeShips := [],
        myPHRShips := [],
        myShaltariShips := [],
        myResistanceShips := [].

clauses
    tryConsult() :-
        Dir = directory::getCurrentDirectory(),
        File = string::format("%s/shipList.pl", Dir),
        try
            file::consult(File, myShips)
        catch _ do
            fail
        end try.

clauses
    trySave() :-
        Dir = directory::getCurrentDirectory(),
        File = string::format("%s/shipList.pl", Dir),
        try
            file::save(File, myShips)
        catch _ do
            fail
        end try.

class facts - myShips
    myUCMShips : tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}* := [].
    myScourgeShips : tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}* := [].
    myPHRShips : tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}* := [].
    myShaltariShips : tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}* := [].
    myResistanceShips : tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}* := [].
    myLowerPoints : integer := 480.
    myUpperPoints : integer := 500.

end implement fleet
