import { IsString, IsNotEmpty, IsNumber, IsPositive, IsIn } from 'class-validator';

export class ProcessPaymentDto {
  @IsString()
  @IsNotEmpty()
  token: string; // Raw payment token from Apple/Google Pay

  @IsString()
  @IsIn(['apple_pay', 'google_pay'])
  provider: 'apple_pay' | 'google_pay';

  @IsNumber()
  @IsPositive()
  amount: number; // In pence (GBP), e.g. 1275 = £12.75

  @IsString()
  @IsNotEmpty()
  description: string; // e.g. "Under Milk Wood · 250g · Beans"
}
