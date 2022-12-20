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
    myUCMShips : tuple{string ClassName, integer MaxNum}* := [].
    myScourgeShips : tuple{string ClassName, integer MaxNum}* := [].
    myPHRShips : tuple{string ClassName, integer MaxNum}* := [].
    myShaltariShips : tuple{string ClassName, integer MaxNum}* := [].
    myResistanceShips : tuple{string ClassName, integer MaxNum}* := [].

end implement fleet
