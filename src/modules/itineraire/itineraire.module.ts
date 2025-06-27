import { Module } from '@nestjs/common';
import { HttpModule } from '@nestjs/axios';
import { ItineraireController } from './itineraire.controller';
import { ItineraireService } from './itineraire.service';

@Module({
  imports: [HttpModule],
  controllers: [ItineraireController],
  providers: [ItineraireService],
})
export class ItineraireModule {}