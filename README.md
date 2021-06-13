# CenticBids

CenticBids is an online bidding platform which allow users to bid for online auctions.

## Getting Started

This app uses Google's Firestore database. It consists of four collections. (auction, bids, notifications and user). Only the auction collection should be inserted through the Firebase console. Others are handled through the mobile.

### Adding a new auction

A new document with 7 fields should be created as follows;
| Field Name | Data Type |
|--|--|
| base_price | number |
| description| string|
| images| string array|
| latest_bid| number |
| remaining_time| timestamp|
| title| string|
| uid| string|

Latest bid and uid are inserted through the mobile. 


