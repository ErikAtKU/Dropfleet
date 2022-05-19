% Copyright

implement damageGraph inherits userControlSupport
    open core

constants
    unit : integer = gdiPlus_native::unitPixel.
    penWidth : real = 1.0.
    fontFamily : string = "Times New Roman".
    fontSize : real = 14.0.
    graphFontSize : real = 12.0.
    barWidth : integer = 7.

facts
    damageMaps : tuple{pen, string Name, integer TotalCost, mapM{integer Damage, integer Count}}* := [].
    maxDamage : integer := 0.
    total : integer := 0.

clauses
    new(Parent) :-
        new(),
        setContainer(Parent).

clauses
    new() :-
        userControlSupport::new(),
        generatedInitialize(),
        grayPen:dashStyle := gdiplus_native::dashStyleDash,
        setpaintresponder(onPaint).

class facts
    penList : pen* :=
        [
            pen::createColor(color::create(color::burlywood), penWidth, unit),
            pen::createColor(color::create(color::cornflowerblue), penWidth, unit),
            pen::createColor(color::create(color::crimson), penWidth, unit),
            pen::createColor(color::create(color::seagreen), penWidth, unit),
            pen::createColor(color::create(color::mediumpurple), penWidth, unit),
            pen::createColor(color::create(color::firebrick), penWidth, unit)
        ].
    blackPen : pen := pen::createColor(color::create(color::black), penWidth, unit).
    whitePen : pen := pen::createColor(color::create(color::white), penWidth, unit).
    grayPen : pen := pen::createColor(color::create(color::gray), penWidth, unit).

clauses
    makeDamageMap(ShipSims, DefendFBS, Trials) :-
        damageMaps := [],
        ShipSimList =
            [ tuple(MapFact, SO, WF, CAW, Launch, SingleLinkedArc, Max, FBS) ||
                tuple(SO, WF, CAW, Launch, SingleLinkedArc, Max, FBS) in ShipSims,
                MapFact = varM::new([])
            ],
        ThreadList = varM::new([]),
        foreach tuple(MapFact, _SO, WF, CAW, Launch, SingleLinkedArc, Max, FBS) in ShipSimList do
            Thread =
                thread::start(
                    { () :-
                        MapOut = weapon::simulate(fleetBuilder::group(FBS, Max), DefendFBS, WF, CAW, Launch, SingleLinkedArc, Trials),
                        Name = string::present(FBS),
                        if true = WF then
                            NameStr = string::format("%s WF", Name)
                        else
                            NameStr = Name
                        end if,
                        shipClass::getFBSPoints(FBS, ShipPoints),
                        TotalCost = ShipPoints * Max,
                        MapFact:value := [tuple(NameStr, TotalCost, MapOut)]
                    }),
            ThreadList:value := [Thread | ThreadList:value]
        end foreach,
        foreach Thread in ThreadList:value do
            Thread:wait()
        end foreach,
        DamageMapsVar = varM::new([]),
        foreach
            tuple(MapFact, _SO, _WF, _CAW, _Launch, _SingleLinkedArc, _Max, _FBS) in ShipSimList and [DamageMap | _] = MapFact:value
            and tuple(NameStr, TotalCost, MapOut) = DamageMap
        do
            CountMap = mapM_redBlack::new(),
            MaxDamage = varM_integer::new(0),
            foreach Key = MapOut:getKey_nd() and Count = MapOut:tryGet(Key) and Damage = std::fromTo(0, Key) do
                DamageVal = CountMap:get_default(Damage, 0),
                CountMap:set(Damage, DamageVal + Count),
                if MaxDamage:value < Damage then
                    MaxDamage:value := Damage
                end if
            end foreach,
            DamageMapsVar:value := [tuple(MaxDamage:value, tuple(NameStr, TotalCost, CountMap)) | DamageMapsVar:value]
        end foreach,
        SortedList = list::sort(DamageMapsVar:value, core::descending),
        damageMaps :=
            [ tuple(Pen, NameStr, TotalCost, CountMap) ||
                Head = list::zipHead_nd(penList, SortedList),
                tuple(Pen, tuple(_MaxDamage, tuple(NameStr, TotalCost, CountMap))) = Head
            ],
        setMaxs(),
        This:invalidate(),
        This:bringToTop().

predicates
    setMaxs : ().
clauses
    setMaxs() :-
        maxDamage := 0,
        foreach tuple(_, _, _, DamageMap) in damageMaps and Key = DamageMap:getKey_nd() and 0 < DamageMap:tryGet(Key) and maxDamage < Key do
            maxDamage := Key
        end foreach,
        total := 0,
        if tuple(_, _, _, DamageMap) in damageMaps and Count = DamageMap:tryGet(0) then
            total := Count
        end if.

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
        foreach tuple(Pen, Name, TotalCost, DamageMap) in damageMaps do
            MaxVar = varM_integer::new(0),
            foreach Key = DamageMap:getKey_nd() and 0 < DamageMap:tryGet(Key) do
                if MaxVar:value < Key then
                    MaxVar:value := Key
                end if
            end foreach,
            MinMaxStr = string::format("%3dpts-Max%3d", TotalCost, MaxVar:value),
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
        GraphHeight = Height - 20,
        GraphWidth = Width - 120,
        Graphics:fillRectangleI(whitePen:brush, 120, 0, GraphWidth, Height),
        Graphics:fillRectangleI(blackPen:brush, 120, 0, 2, GraphHeight),
        Graphics:fillRectangleI(blackPen:brush, 120, GraphHeight, GraphWidth, 2),
        FontFamily = fontFamily::createFromName(fontFamily),
        Font = font::createFromFontFamily(FontFamily, graphFontSize, 0, unit),
        StringFormat = stringFormat::create(0, 0),
        foreach Amount = std::fromTo(0, 3) do
            Graphics:fillRectangleI(grayPen:brush, 120, Amount * GraphHeight div 4, GraphWidth, 1),
            Num = 100 - 25 * Amount,
            Graphics:drawString(string::format("%3d", Num), -1, Font, gdiplus::rectF(100, Amount * GraphHeight div 4, 40, 20), StringFormat,
                blackPen:brush)
        end foreach,
        Graphics:drawString("  0", -1, Font, gdiplus::rectF(100, GraphHeight - 10, 40, 20), StringFormat, blackPen:brush),
        SectionWidth = getSectionWidth(),
        hasDomain(predicate_dt{integer}, Ignore),
        if (1 + maxDamage) * SectionWidth < GraphWidth then
            Ignore = { (_I) :- succeed }
        else
            MaxSections = GraphWidth div SectionWidth,
            NumToRemove = 1 + maxDamage - MaxSections,
            if 1 = NumToRemove then
                Ignore = { (I) :- I mod maxDamage - 4 <> maxDamage - 1 },
                Mod = maxDamage - 4
            else
                Mod = maxDamage div NumToRemove,
                if 1 < Mod then
                    Ignore = { (I) :- I mod Mod <> Mod - 1 }
                elseif ModStep = std::fromTo(2, maxDamage) and maxDamage <= ModStep * MaxSections then
                    Ignore =
                        { (I) :-
                            I mod ModStep = 0
                            orelse I = maxDamage
                        }
                else
                    Ignore = { (I) :- I mod maxDamage = 0 }
                end if
            end if
        end if,
        Offset = varM_integer::new(2),
        foreach tuple(Pen, _Name, _TotalCost, DamageMap) in damageMaps do
            WidthCounter = varM_integer::new(Offset:value),
            foreach Damage = DamageMap:getKey_nd() and Ignore(Damage) and Count = DamageMap:tryGet(Damage) and 0 < Count do
                BarHeight = math::max(GraphHeight * Count div total, 2),
                BarX = 120 + WidthCounter:value,
                Graphics:fillRectangleI(Pen:brush, BarX, GraphHeight - BarHeight, barWidth, BarHeight),
                WidthCounter:add(SectionWidth)
            end foreach,
            Offset:add(barWidth)
        end foreach,
        WidthCounter = varM_integer::new(2),
        foreach Damage = std::fromTo(0, maxDamage) and Ignore(Damage) do
            BarX = 120 + WidthCounter:value,
            Graphics:drawString(string::format("%d", Damage), -1, Font, gdiplus::rectF(BarX, GraphHeight + 5, 40, 20), StringFormat, blackPen:brush),
            WidthCounter:add(SectionWidth)
        end foreach.

predicates
    getSectionWidth : () -> integer.
clauses
    getSectionWidth() = Val :-
        Val = math::max(2 + barWidth * list::length(damageMaps), 12).

% This code is maintained automatically, do not update it manually.
predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("damageGraph"),
        setSize(412, 184).
% end of automatic code

end implement damageGraph
