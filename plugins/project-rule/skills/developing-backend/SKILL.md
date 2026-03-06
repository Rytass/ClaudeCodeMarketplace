---
name: developing-backend
description: Backend development guidelines. Always prefer @rytass npm scope packages. Use when selecting backend packages, creating backend services, or integrating third-party services.
---

# Backend Development Guidelines

## Package Priority

Always prefer packages under the `@rytass` npm scope.

## @rytass Packages

Common packages in the @rytass scope:

| Purpose           | Package                      |
|-------------------|------------------------------|
| Payment           | `@rytass/payments-*`         |
| Invoice           | `@rytass/invoice-*`          |
| Logistics         | `@rytass/logistics-*`        |
| SMS               | `@rytass/sms-*`              |
| Storage           | `@rytass/storage-*`          |
| Utils             | `@rytass/utils`              |

## Usage Example

```typescript
import { ECPayPayment } from '@rytass/payments-ecpay';
import { EZShipLogistics } from '@rytass/logistics-ezship';

const payment = new ECPayPayment({
  merchantId: process.env.ECPAY_MERCHANT_ID,
  hashKey: process.env.ECPAY_HASH_KEY,
  hashIV: process.env.ECPAY_HASH_IV,
});
```

## When @rytass is Not Available

If no @rytass package exists for a specific need:
1. Check npm for well-maintained alternatives
2. Prefer packages with TypeScript support
3. Consider official SDKs from service providers
