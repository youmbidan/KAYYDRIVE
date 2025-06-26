import { Injectable } from '@nestjs/common';
import { HttpService } from '@nestjs/axios';
import { firstValueFrom } from 'rxjs';

@Injectable()
export class ItineraireService {
  private readonly OSRM_BASE_URL = 'http://router.project-osrm.org/route/v1';

  constructor(private readonly httpService: HttpService) {}

  async calculateRoute(
    start: [number, number],
    end: [number, number],
    profile: string = 'driving'
  ) {
    const [startLon, startLat] = start;
    const [endLon, endLat] = end;

    const url = `${this.OSRM_BASE_URL}/${profile}/${startLon},${startLat};${endLon},${endLat}`;
    const params = {
      steps: true,
      overview: 'full',
      geometries: 'geojson',
      alternatives: false
    };

    try {
      const response = await firstValueFrom(
        this.httpService.get(url, { params })
      );
      return this.formatRouteResponse(response.data);
    } catch (error) {
      throw new Error(`OSRM request failed: ${error.message}`);
    }
  }

  private formatRouteResponse(data: any) {
    if (!data.routes || data.routes.length === 0) {
      throw new Error('No route found');
    }

    const route = data.routes[0];
    return {
      distance: route.distance, // en mètres
      duration: route.duration, // en secondes
      geometry: route.geometry,
      instructions: route.legs[0].steps.map(step => ({
        distance: step.distance,
        duration: step.duration,
        instruction: step.maneuver.instruction,
        name: step.name
      }))
    };
  }
}