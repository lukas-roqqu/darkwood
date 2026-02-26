import { Injectable, BadRequestException, InternalServerErrorException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import Stripe from 'stripe';
import { ProcessPaymentDto } from './dto/process-payment.dto';

@Injectable()
export class PaymentsService {
  private readonly stripe: Stripe;

  constructor(private readonly config: ConfigService) {
    this.stripe = new Stripe(this.config.getOrThrow<string>('STRIPE_SECRET_KEY'), {
      apiVersion: '2026-01-28.clover',
    });
  }

  async processPayment(dto: ProcessPaymentDto): Promise<{ id: string; status: string }> {
    let paymentMethodId: string;

    try {
      // Apple Pay and Google Pay tokens are both submitted as Stripe payment methods
      const paymentMethod = await this.stripe.paymentMethods.create({
        type: 'card',
        card: { token: dto.token },
      });
      paymentMethodId = paymentMethod.id;
    } catch (err) {
      throw new BadRequestException(`Invalid payment token: ${err.message}`);
    }

    try {
      const intent = await this.stripe.paymentIntents.create({
        amount: dto.amount,
        currency: 'gbp',
        payment_method: paymentMethodId,
        description: dto.description,
        confirm: true,
        automatic_payment_methods: {
          enabled: true,
          allow_redirects: 'never',
        },
      });

      if (intent.status !== 'succeeded') {
        throw new BadRequestException(`Payment not completed — status: ${intent.status}`);
      }

      return { id: intent.id, status: intent.status };
    } catch (err) {
      if (err instanceof BadRequestException) throw err;
      throw new InternalServerErrorException(`Payment failed: ${err.message}`);
    }
  }
}
