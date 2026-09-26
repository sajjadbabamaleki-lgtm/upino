/// What a spend was for.
///
/// Optional on purpose: the figure on Home is right whether or not a spend is
/// sorted, so asking is never allowed to slow recording down (§18). What a
/// category buys is the answer to "where did the money go?", which is the
/// first thing anyone asks of a record of their spending.
///
/// Kept beside the ledger rather than in it, like a receipt: the engine is
/// pure arithmetic, and which shop a spend was in changes none of it.
library;

enum SpendCategory { food, transport, bills, shopping, health, fun, other }
