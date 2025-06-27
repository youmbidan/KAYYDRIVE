import { Controller, Get, Query, BadRequestException } from '@nestjs/common';
import { ItineraireService } from './itineraire.service';

@Controller('itineraire')
export class ItineraireController {
  constructor(private readonly itineraireService: ItineraireService) {}

  @Get()
  async getItineraire(
    @Query('start') start: string,
    @Query('end') end: string,
    @Query('profile') profile?: string
  ) {
    try {
      const startCoords = this.parseCoordinates(start);
      const endCoords = this.parseCoordinates(end);

      return await this.itineraireService.calculateRoute(
        startCoords,
        endCoords,
        profile
      );
    } catch (error) {
      throw new BadRequestException(error.message);
    }
  }

  private parseCoordinates(coordsStr: string): [number, number] {
    if (!coordsStr) throw new Error('Missing coordinates parameter');

    const parts = coordsStr.split(',');
    if (parts.length !== 2) throw new Error('Invalid coordinates format. Use "longitude,latitude"');

    const lon = parseFloat(parts[0]);
    const lat = parseFloat(parts[1]);

    if (isNaN(lon) || isNaN(lat)) {
      throw new Error('Invalid coordinate values');
    }

    return [lon, lat];
  }
}