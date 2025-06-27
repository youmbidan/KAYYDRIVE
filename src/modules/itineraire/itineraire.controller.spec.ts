import { Test, TestingModule } from '@nestjs/testing';
import { ItineraireController } from './itineraire.controller';

describe('ItineraireController', () => {
  let controller: ItineraireController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [ItineraireController],
    }).compile();

    controller = module.get<ItineraireController>(ItineraireController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
