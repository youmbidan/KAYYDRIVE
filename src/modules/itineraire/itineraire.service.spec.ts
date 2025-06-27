import { Test, TestingModule } from '@nestjs/testing';
import { ItineraireService } from './itineraire.service';

describe('ItineraireService', () => {
  let service: ItineraireService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [ItineraireService],
    }).compile();

    service = module.get<ItineraireService>(ItineraireService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
