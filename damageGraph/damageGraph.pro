% Copyright

implement damageGraph inherits userControlSupport
    open core

constants
    unit : integer = gdiPlus_native::unitPixel.
    penWidth : real = 1.0.
    fontFamily : string = "Times New Roman".
    fontSize : real = 14.0.

facts
    damageMaps : tuple{pen, tuple{string Name, mapM{integer Damage, integer Count}}}* := [].
    maxDamage : integer := 0.

clauses
    new(Parent) :-
        new(),
        setContainer(Parent).

clauses
    new() :-
        userControlSupport::new(),
        generatedInitialize(),
        setpaintresponder(onPaint).

class facts
    penList : pen* :=
        [
            pen::createColor(color::create(color::cornflowerblue), penWidth, unit),
            pen::createColor(color::create(color::burlywood), penWidth, unit),
            pen::createColor(color::create(color::crimson), penWidth, unit),
            pen::createColor(color::create(color::seagreen), penWidth, unit),
            pen::createColor(color::create(color::mediumpurple), penWidth, unit)
        ].
    blackPen : pen := pen::createColor(color::create(color::black), penWidth, unit).
    whitePen : pen := pen::createColor(color::create(color::white), penWidth, unit).

clauses
    makeDamageMap(ShipSimList, Trials) :-
        damageMaps := [],
        PenSimList =
            [ tuple(Pen, MapFact, SO, WF, CAW, SingleLinkedArc, Max, FBS) ||
                Head = list::zipHead_nd(penList, ShipSimList),
                tuple(Pen, tuple(SO, WF, CAW, SingleLinkedArc, Max, FBS)) = Head,
                MapFact = varM::new([])
            ],
        ThreadList = varM::new([]),
        foreach tuple(Pen, MapFact, SO, WF, CAW, SingleLinkedArc, Max, FBS) in PenSimList do
            Thread =
                thread::start(
                    { () :-
                        MapOut =
                            weapon::simulate(fleetBuilder::group(FBS, Max), ucmOsaka::getFleetBuilderStats(), false, CAW, WF, SingleLinkedArc, Trials),
                        Name = string::present(FBS),
                        if true = WF then
                            NameStr = string::format("%s WF", Name)
                        else
                            NameStr = Name
                        end if,
                        MapFact:value := [tuple(Pen, tuple(NameStr, MapOut))]
                    }),
            ThreadList:value := [Thread | ThreadList:value]
        end foreach,
        foreach Thread in ThreadList:value do
            Thread:wait()
        end foreach,
        foreach tuple(Pen, MapFact, SO, WF, CAW, SingleLinkedArc, Max, FBS) in PenSimList and [DamageMap | _] = MapFact:value do
            damageMaps := [DamageMap | damageMaps]
        end foreach,
        setMaxDamage(),
        This:invalidate(),
        This:bringToTop().

predicates
    setMaxDamage : ().
clauses
    setMaxDamage() :-
        maxDamage := 0,
        foreach tuple(_, tuple(_, DamageMap)) in damageMaps and Key = DamageMap:getKey_nd() and 0 < DamageMap:tryGet(Key) and maxDamage < Key do
            maxDamage := Key
        end foreach.

predicates
    onPaint : window::paintresponder.
clauses
    onPaint(_, _, Gdiobject) :-
        HDC = Gdiobject:getNativeGraphicContext(IsReleaseNeeded),
        % Draw in the window
        doDraw(graphics::createFromHDC(HDC)),
        Gdiobject:releaseNativeGraphicContext(HDC, IsReleaseNeeded).

predicates
    doDraw : (graphics Graphics).
clauses
    doDraw(Graphics) :-
        Graphics:smoothingMode := gdiplus_native::smoothingModeAntiAlias,
        convertPixelsWidths::convertDimensions(getWidth(), getHeight(), Width, Height),
        Graphics:fillRectangleI(whitePen:brush, 0, 0, Width, Height),
        makeGraph(Graphics),
        drawNames(Graphics).

predicates
    drawNames : (graphics Graphics).
clauses
    drawNames(Graphics) :-
        convertPixelsWidths::convertDimensions(getWidth(), getHeight(), Width, Height),
        FontFamily = fontFamily::createFromName(fontFamily),
        Font = font::createFromFontFamily(FontFamily, fontSize, 0, unit),
        StringFormat = stringFormat::create(0, 0),
        Y = varM_integer::new(0),
        foreach tuple(Pen, tuple(Name, DamageMap)) in damageMaps do
            MinVar = varM_integer::new(maxDamage),
            MaxVar = varM_integer::new(0),
            foreach Key = DamageMap:getKey_nd() and 0 < DamageMap:tryGet(Key) do
                if MaxVar:value < Key then
                    MaxVar:value := Key
                end if,
                if Key < MinVar:value then
                    MinVar:value := Key
                end if
            end foreach,
            if MaxVar:value < MinVar:value then
                MinVar:value := 0,
                MaxVar:value := 0
            end if,
            MinMaxStr = string::format("Min%3d-Max%3d", MinVar:value, MaxVar:value),
            Graphics:drawString(Name, -1, Font, gdiplus::rectF(12, Y:value, Width, Height), StringFormat, blackPen:brush),
            Graphics:drawString(MinMaxStr, -1, Font, gdiplus::rectF(12, Y:value + 15, Width, Height), StringFormat, blackPen:brush),
            Graphics:fillRectangleF(Pen:brush, 0, Y:value + 5, 10, 5),
            Y:add(40)
        end foreach.

predicates
    makeGraph : (graphics Graphics).
clauses
    makeGraph(Graphics) :-
        convertPixelsWidths::convertDimensions(getWidth(), getHeight(), Width, Height),
        Graphics:fillRectangleI(whitePen:brush, 120, 0, Width, Height),
        Graphics:fillRectangleI(blackPen:brush, 120, 0, 2, Height - 20),
        Graphics:fillRectangleI(blackPen:brush, 120, Height - 20, Width - 40, 2).

% This code is maintained automatically, do not update it manually.
predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("damageGraph"),
        setSize(412, 184).
% end of automatic code

end implement damageGraph
