% Copyright

interface shipClass
    open core

domains
    shipStats =
        stats(integer ShipPoints, real Scan, real Signature, real Thrust, integer Hull, roll Armour, integer PointDefense, group GroupSize, tonnage);
        shaltariStats(
            integer ShipPoints,
            real Scan,
            shaltariSplit,
            real Thrust,
            integer Hull,
            shaltariSplit,
            integer PointDefense,
            group GroupSize,
            tonnage).
    tonnage =
        light(integer);
        medium;
        heavy;
        superHeavy(integer).
    group = g(integer, integer).
    roll =
        d3(integer, diemod);
        d6(integer, diemod);
        star.
    diemod = m; e; p.
    shaltariSplit =
        sig(real, real);
        arm(roll, roll).
    shipSpecial =
        advancedECMSuite;
        aegis(integer);
        atmospheric;
        detector;
        dreadnought;
        freeAdmiral(integer);
        regenerate(integer);
        fullCloak;
        launch(launchSystem*);
        monitor_stat;
        open_stat;
        outlier;
        rare;
        shieldBooster;
        stealth;
        vectored;
        voidgate(integer);
        voidSkip;
        agrippa_stat;
        ourania_stat;
        remus_stat;
        pegasus_stat;
        venice_stat.

domains
    weaponSystem = weaponSystem(string Name, roll Lock, count Attack, count Damage, arc* Arc, weaponSpecial* Special).
    weaponSpecial =
        airToAir;
        alt(integer);
        atmospheric;
        bombardment;
        bloom;
        burnthrough(integer);
        calibre(rosterCategory*);
        closeAction(caType Type = standard);
        corruptor;
        crippling;
        distortion;
        flash;
        emSabotage;
        escapeVelocity;
        fusillade(integer);
        haywire;
        impel(integer);
        ion(integer);
        mauler(integer);
        overcharged;
        particle;
        linked(integer);
        lowLevel;
        reEntry;
        siphonPower;
        squadron(integer).
    caType = standard; beam; swarmer.
    arc =
        front(limited Narrow = all);
        side(limited Side = all);
        rear.
    limited = right; left; narrow; all.
    count =
        i(integer);
        nd3plus(integer N, integer Plus);
        nd6plus(integer N, integer Plus);
        star.
    rosterCategory = cat_light; cat_medium; cat_heavy; cat_superHeavy.

domains
    launchSystem =
        torpedo(torpedoSystem, integer Launch, launchSpecial*);
        strikeCraft(strikeCraftSystem, integer Launch, launchSpecial*).
    torpedoSystem = torpedo_stats(string Name, real Thrust, roll Lock, count Attack, count Damage, weaponSpecial* Special = []).
    strikeCraftSystem =
        fighter_stats(string Name, real Thrust, integer PointDefenseBonus, weaponSpecial* Special = []);
        bomber_stats(string Name, real Thrust, roll Lock, count Attack, count Damage, weaponSpecial* Special = []);
        fighterBomber_stats(strikeCraftSystem, strikeCraftSystem);
        bulkLander_stats(string Name, real Thrust);
        dropships_stats(string Name, real Thrust);
        gate_stats(string Name).
    launchSpecial = limited(integer).

domains
    fleetBuilderStats =
        fbs(constructorStats, string ClassName, shipSpecial* Special, function{ship} Constructor)
        [presenter(shipClass::fbsPresenter)].
    constructorStats = conStats(integer ShipPoints, group GroupSize, tonnage Tonnage).

constants
    dropships : strikeCraftSystem = dropships_stats("Dropships", 12.0).
    bulkLander : strikeCraftSystem = bulkLander_stats("Bulk Lander", 12.0).
    gates : strikeCraftSystem = gate_stats("Gate").

constants
    phrFighter : strikeCraftSystem = fighter_stats("PHR Fighters", 20.0, 4, []).
    phrBomber : strikeCraftSystem = bomber_stats("PHR Bombers", 12.0, d6(2, p), i(2), i(1), []).
    phrFightersBombers : strikeCraftSystem = fighterBomber_stats(phrFighter, phrBomber).
    phrTorpedo : torpedoSystem = torpedo_stats("PHR Torpedoes", 9.0, d6(2, p), i(4), i(2), []).

constants
    shaltariFighter : strikeCraftSystem = fighter_stats("Shaltari Fighters", 24.0, 5, []).
    shaltariBomber : strikeCraftSystem = bomber_stats("Shaltari Bombers", 12.0, d6(3, p), i(2), i(1), []).
    shaltariFightersBombers : strikeCraftSystem = fighterBomber_stats(shaltariFighter, shaltariBomber).
    shaltariTorpedo : torpedoSystem = torpedo_stats("Shaltari Torpedoes", 0.0, d3(4, p), i(0), i(0), []).

constants
    ucmFighter : strikeCraftSystem = fighter_stats("UCM Fighters", 20.0, 3, []).
    ucmBomber : strikeCraftSystem = bomber_stats("UCM Bombers", 12.0, d6(3, p), i(2), i(1), []).
    ucmFightersBombers : strikeCraftSystem = fighterBomber_stats(ucmFighter, ucmBomber).
    ucmTorpedoes : torpedoSystem = torpedo_stats("UCM Torpedoes", 9.0, d6(2, p), i(4), i(2), []).
    ucmLightTorpedoes : torpedoSystem = torpedo_stats("UCM Light Torpedoes", 14.0, d6(2, p), i(4), i(1), []).
    ucmHeavyTorpedo : torpedoSystem = torpedo_stats("UCM Heavy Torpedoes", 9.0, d6(2, p), i(4), i(4), []).

predicates
    shipPoints : () -> integer.
    scan : () -> real.
    signature : (boolean ShieldsUp = false) -> real.
    thrust : () -> real.
    hull : () -> integer.
    armour : (boolean ShieldsUp = false) -> roll.
    pointDefense : (boolean ShieldsUp = false) -> integer.
    groupSize : () -> group.
    tonnage : () -> tonnage.
    name : () -> string.

predicates
    getWeaponSystem_nd : () -> weaponSystem nondeterm.

predicates
    getShipSpecial_nd : () -> shipSpecial nondeterm.

end interface shipClass
