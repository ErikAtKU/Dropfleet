% Copyright

implement fleet
    open core

class facts
    myUCMShips : tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}* :=
        [
            tuple(0, 2, ucmNewOrleans::getFleetBuilderStats()),
            tuple(0, 6, ucmLysander::getFleetBuilderStats()),
            tuple(0, 1, ucmMadrid::getFleetBuilderStats()),
            tuple(0, 0, ucmOsaka::getFleetBuilderStats()),
            tuple(0, 1, ucmLima::getFleetBuilderStats()),
            tuple(0, 1, ucmSanFransisco::getFleetBuilderStats()),
            tuple(0, 2, ucmSeattle::getFleetBuilderStats()),
            tuple(0, 1, ucmStPetersburg::getFleetBuilderStats()),
            tuple(0, 0, ucmWashington::getFleetBuilderStats()),
            tuple(0, 0, ucmTaipei::getFleetBuilderStats()),
            tuple(0, 0, ucmKyiv::getFleetBuilderStats())
        ].
    myShaltariShips : tuple{integer MinNum, integer MaxNum, shipClass::fleetBuilderStats}* :=
        [
            tuple(1, 1, shaltariEmerald::getFleetBuilderStats()),
            tuple(0, 0, shaltariAmber::getFleetBuilderStats()),
            tuple(0, 0, shaltariGranite::getFleetBuilderStats()),
            tuple(0, 0, shaltariObsidian::getFleetBuilderStats()),
            tuple(0, 0, shaltariJet::getFleetBuilderStats()),
            tuple(0, 2, shaltariAquamarine::getFleetBuilderStats()),
            tuple(0, 0, shaltariTurquoise::getFleetBuilderStats()),
            tuple(0, 0, shaltariBasalt::getFleetBuilderStats()),
            tuple(0, 0, shaltariOnyx::getFleetBuilderStats()),
            tuple(0, 0, shaltariAzurite::getFleetBuilderStats()),
            tuple(3, 3, shaltariVoidgate::getFleetBuilderStats()),
            tuple(0, 4, shaltariTopaz::getFleetBuilderStats()),
            tuple(0, 4, shaltariJade::getFleetBuilderStats()),
            tuple(0, 4, shaltariAmethyst::getFleetBuilderStats()),
            tuple(0, 1, shaltariOpal::getFleetBuilderStats())
        ].

end implement fleet
