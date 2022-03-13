% Copyright

implement convertPixelsWidths
    open core

clauses
    convertDimensions(Width, Height, WOut, HOut) :-
        WOut = Width * 448 div 256,
        HOut = Height * 448 div 256.

end implement convertPixelsWidths
