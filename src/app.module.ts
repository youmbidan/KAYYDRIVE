import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ItineraireModule } from './modules/itineraire/itineraire.module';

@Module({
  imports: [ItineraireModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}