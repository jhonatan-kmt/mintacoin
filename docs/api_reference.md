## REST API

Minimalist API to run your crypto.

### Base URL

Currently, Mintacoin offers a Sandbox URL. Useful for testing and getting started with the API, the transactions are sent to the testnet of the supported blockchains.

```
https://sandbox.api.mintacoin.co
```

### Success response

A success response has the following format:

```javascript
{
  "data": {
      ...
  },
  "status": 200 | 201
}
```

##### Response parameters

| Parameter | Type    | Description                                                  |
| --------- | ------- | ------------------------------------------------------------ |
| `data`    | Object  | Contains the data returned by the endpoint you're accessing. |
| `status`  | Integer | HTTP response status code.                                   |


### Accounts

Group of endpoints to manage the account resource.

An account is the main resource in Mintacoin, because it gives you the keys that allow managing other resources in the API, and it is identified by the `address` field.

#### **Create account**
    
Creates an account on Mintacoin and on the given blockchain.

This endpoint returns the necessary to manage an account in Mintacoin: **address** (Mintacoin public key), **signature** (Mintacoin secret key), and **seed words** (to recover the signature).

##### Example requests

HTTP request:

```http
POST /accounts
```

Curl request:

```bash
curl -X POST \
     -H 'Content-Type: application/json' \
     -d '{"blockchain": "stellar"}' \
     "https://sandbox.api.mintacoin.co/accounts"
```

##### Body params

```json
{
  "blockchain": "stellar"
}
```

| Param        | Type   | Description                                                         |
| ------------ | ------ | ------------------------------------------------------------------- |
| `blockchain` | String | The blockchain in which the account's first wallet will be created. |

> Blockchains supported: `stellar`.

##### Response

```json
{
  "data": {
     "address": "D6J2KKOOXSTOXO36REKBPL3QH4FL2PCFKBK6W3TIOVMHR7DDVLTQ",
     "seed_words": "movie enrich merit census grid twice praise return glass wagon yard faint",
     "signature": "DCZIKJFUC6O5R2PVDDPB2C3XFGJL2ZCRKV66WNCPB4UDCP64HQLQ"
  },
  "status": 201
}
```

##### Response data parameters

| Parameter    | Type   | Description                                                                                                 |
| ------------ | ------ | ----------------------------------------------------------------------------------------------------------- |
| `address`    | String | Public key of your Mintacoin account.                                                                       |
| `signature`  | String | Secret key of your Mintacoin account. keep it safe and don't share it.                                      |
| `seed_words` | String | 12 words that you can use to recover your `signature` if you lost it, keep them safe, and don't share them. |

---

#### **Recover signature**
    
Recovers the `signature` with the `address` and the `seed_words` of an account.

##### Example requests

HTTP request:

```http
POST /accounts/:address/recover
```

Curl request:

```bash
curl -X POST \
     -H 'Content-Type: application/json' \
     -d '{"seed_words": "movie enrich merit census grid twice praise return glass wagon yard faint"}' \
     "https://sandbox.api.mintacoin.co/accounts/D6J2KKOOXSTOXO36REKBPL3QH4FL2PCFKBK6W3TIOVMHR7DDVLTQ/recover"
```

##### Body params

```json
{
  "seed_words": "movie enrich merit census grid twice praise return glass wagon yard faint"
}
```

| Param        | Type   | Description           |
| ------------ | ------ | --------------------- |
| `seed_words` | String | Account's seed words. |

##### Response

```json
{
  "data": {
     "signature": "DCZIKJFUC6O5R2PVDDPB2C3XFGJL2ZCRKV66WNCPB4UDCP64HQLQ"
  },
  "status": 200
}
```

##### Response data parameters

| Parameter   | Type   | Description                           |
| ----------- | ------ | ------------------------------------- |
| `signature` | String | Secret key of your Mintacoin account. |

---

#### **Create asset trustline**
    
Create an asset trustline to allow the account to hold an asset. 

The resulting response is the information of the asset requested to own.

##### Example requests

HTTP request:

```http
POST /accounts/:address/assets/:asset_id/trust
```

Curl request:

```bash
curl -X POST \
     -H 'Content-Type: application/json' \
     -d '{"signature": "PSUQJNRDUZL7KLGB4O5FMN6M7XH3LTOWWU3IPGVKTWU7IBNHAQNQ"}' \
     "https://sandbox.api.mintacoin.co/accounts/YYVLNUJFEW54QZIHWZTIBLAD52M5TSXOJAZP7FYJXC7TM7MQQDLQ/assets/317e8c9c-48ad-4513-8936-32646edbed9b/trust"
```
##### Body params

```json
{
  "signature": "PSUQJNRDUZL7KLGB4O5FMN6M7XH3LTOWWU3IPGVKTWU7IBNHAQNQ"
}
```

| Param       | Type   | Description                           |
| ----------- | ------ | ------------------------------------- |
| `signature` | String | Secret key of your Mintacoin account. |

##### Response

```json
{
  "data": {
    "code": "MTK",
    "id": "317e8c9c-48ad-4513-8936-32646edbed9b",
    "supply": "123.542"
  },
  "status": 201
}
```
##### Response data parameters

| Parameter | Type   | Description                             |
| --------- | ------ | --------------------------------------- |
| `id`      | String | The asset’s identifying id.             |
| `code`    | String | The asset’s identifying code.           |
| `supply`  | String | The amount of the asset in the network. |

---

#### **Get assets held by an account**
    
Retrieve the assets information held by a Mintacoin account.

##### Example requests

HTTP request:

```http
GET /accounts/:address/assets
```

Curl request:

```bash
curl -X GET \
     -H 'Content-Type: application/json' \
     "https://sandbox.api.mintacoin.co/accounts/YYVLNUJFEW54QZIHWZTIBLAD52M5TSXOJAZP7FYJXC7TM7MQQDLQ/assets"
```
##### Response

```json
{
  "data": [
    {
      "asset": "MTK",
      "asset_id": "438d075c-2b66-4841-bf92-2c9f346e16fa",
      "balance": "0.0",
      "blockchain": "stellar",
      "minter": false
    },
    {
      "asset": "NYY",
      "asset_id": "be6bd87e-6956-4f2d-b316-f14ece2ca677",
      "balance": "123.455",
      "blockchain": "stellar",
      "minter": true
    }
  ],
  "status": 200
}
```
##### Response data parameters

| Parameter    | Type    | Description                                                                                                   |
| ------------ | ------- | ------------------------------------------------------------------------------------------------------------- |
| `asset`      | String  | The asset’s identifying code.                                                                                 |
| `asset_id`   | String  | The asset’s identifying id.                                                                                   |
| `balance`    | String  | The current balance of the asset on the user's account.                                                       |
| `blockchain` | String  | The name of the blockchain to which the asset belongs.                                                        |
| `minter`     | Boolean | `true` if the user account is the issuer of the asset. <br> `false` if the user account only holds the asset. |

---

### Assets

Group of endpoints to manage the asset resource. 

It is the asset representation of an active within a blockchain network, which could contain a commercial and economic value; This asset can be exchange by any other, and it can represent anything like:

> 📍 **Assets examples**
>
> CUP - Coffee Cup
>
> MTK - Mintacoin Token
>
> USDC - Dollar

Mintacoin will help you in the creation and management of your assets.

#### **Create asset**
    
Creates an asset on the given blockchain.

##### Example requests

HTTP request:

```http
POST /assets
```

Curl request:

```bash
curl -X POST \
     -H 'Content-Type: application/json' \
     -d '{"blockchain": "stellar", "address": "YYVLNUJFEW54QZIHWZTIBLAD52M5TSXOJAZP7FYJXC7TM7MQQDLQ", "signature": "PSUQJNRDUZL7KLGB4O5FMN6M7XH3LTOWWU3IPGVKTWU7IBNHAQNQ", "asset_code": "MTK", "supply": 123.542}' \
     "https://sandbox.api.mintacoin.co/assets"
```

##### Body params

```json
{
  "blockchain": "stellar", 
  "address": "YYVLNUJFEW54QZIHWZTIBLAD52M5TSXOJAZP7FYJXC7TM7MQQDLQ", 
  "signature": "PSUQJNRDUZL7KLGB4O5FMN6M7XH3LTOWWU3IPGVKTWU7IBNHAQNQ",
  "asset_code": "MTK", 
  "supply": 123.542
}
```

| Param                   | Type   | Description                                                                                        |
| ----------------------- | ------ | -------------------------------------------------------------------------------------------------- |
| `blockchain` (optional) | String | The blockchain in which the asset will be created. Default value: `stellar`                        |
| `address`               | String | The public key of your Mintacoin account. This account will be the owner of the asset.             |
| `signature`             | String | Secret key of your Mintacoin account.                                                              |
| `asset_code`            | String | The asset's identifying code. This code must be alphanumeric and between 1 and 10 characters long. |
| `supply`                | Number | The initial amount of the asset. This supply must be greater than zero.                            |

> Blockchains supported: `stellar`.

##### Response

```json
{
  "data": {
    "code": "MTK",
    "id": "317e8c9c-48ad-4513-8936-32646edbed9b",
    "supply": "123.542"
  },
  "status": 201
}
```
##### Response data parameters

| Parameter | Type   | Description                             |
| --------- | ------ | --------------------------------------- |
| `id`      | String | The asset’s identifying id.             |
| `code`    | String | The asset’s identifying code.           |
| `supply`  | String | The amount of the asset in the network. |

---

#### **Get asset**
    
Retrieve the asset information by its asset id.

##### Example requests

HTTP request:

```http
GET /assets/:id
```

Curl request:

```bash
curl -X GET \
     -H 'Content-Type: application/json' \
     "https://sandbox.api.mintacoin.co/assets/317e8c9c-48ad-4513-8936-32646edbed9b"
```

##### Response

```json
{
  "data": {
    "code": "MTK",
    "id": "317e8c9c-48ad-4513-8936-32646edbed9b",
    "supply": "123.542"
  },
  "status": 200
}
```
##### Response data parameters

| Parameter | Type   | Description                             |
| --------- | ------ | --------------------------------------- |
| `id`      | String | The asset’s identifying id.             |
| `code`    | String | The asset’s identifying code.           |
| `supply`  | String | The amount of the asset in the network. |

---

#### **Get asset issuer**
    
Retrieve the `address` from the asset's issuer.

##### Example requests

HTTP request:

```http
GET /assets/:id/issuer
```

Curl request:

```bash
curl -X GET \
     -H 'Content-Type: application/json' \
     "https://sandbox.api.mintacoin.co/assets/317e8c9c-48ad-4513-8936-32646edbed9b/issuer"
```

##### Response

```json
{
  "data": {
    "address": "YYVLNUJFEW54QZIHWZTIBLAD52M5TSXOJAZP7FYJXC7TM7MQQDLQ"
  },
  "status": 200
}
```
##### Response data parameters

| Parameter | Type   | Description                         |
| --------- | ------ | ----------------------------------- |
| `address` | String | The public key of the asset issuer. |

---

#### **Get addresses associated with asset**
    
Retrieve the `addresses` associated with an asset. 

The resulting accounts are the holders of the requested asset.

##### Example requests

HTTP request:

```http
GET /assets/:id/accounts
```

Curl request:

```bash
curl -X GET \
     -H 'Content-Type: application/json' \
     "https://sandbox.api.mintacoin.co/assets/317e8c9c-48ad-4513-8936-32646edbed9b/accounts"
```

##### Response

```json
{
  "data": {
    "addresses": [
      "6GZTYIJSBPLTKOH3IXTPJNOR6FUQ3ANOF7G6EF3C2ADKQHTNJASA",
      "YYVLNUJFEW54QZIHWZTIBLAD52M5TSXOJAZP7FYJXC7TM7MQQDLQ"
    ]
  },
  "status": 200
}
```
##### Response data parameters

| Parameter   | Type  | Description                                  |
| ----------- | ----- | -------------------------------------------- |
| `addresses` | Array | List of addresses associated with the asset. |

---
    
### Error response

An error response has the following format:

```json
{
 "code": "blockchain_not_found",
 "detail": "The introduced blockchain doesn't exist",
 "status": 400
}
```

##### Response parameters

| Parameter | Type    | Description                                                |
| --------- | ------- | ---------------------------------------------------------- |
| `code`    | String  | Result code of the response that communicates the failure. |
| `detail`  | String  | Description of the error response.                         |
| `status`  | Integer | Status code of the response.                               |

##### Standard error responses

| Code                    | Detail                                                                            | Status |
| ----------------------- | --------------------------------------------------------------------------------- | ------ |
| `asset_not_found`       | The requested asset doesn't exist.                                                | 400    |
| `blockchain_not_found`  | The introduced blockchain doesn't exist.                                          | 400    |
| `decoding_error`        | Address, signature or seed words are invalid.                                     | 400    |
| `encryption_error`      | Error during encryption.                                                          | 400    |
| `invalid_address`       | The address is invalid.                                                           | 400    |
| `invalid_seed_words`    | The seed words are invalid.                                                       | 400    |
| `invalid_address`       | The address is invalid.                                                           | 400    |
| `invalid_supply_format` | The introduced supply format is invalid. This must be a number greater than zero. | 400    |
| `wallet_not_found`      | The introduced address doesn't exist or doesn't have an associated blockchain.    | 400    |
