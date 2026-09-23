/// Labels that live in the plan but are read on screen.
///
/// A commitment's label is stored with the plan, written once when it was
/// added. The four Upino offers have known ids, so they are translated here
/// by id rather than by what happened to be stored — which means changing
/// language relabels them without touching the saved plan. A commitment the
/// user named themselves keeps the name they typed.
library;

import 'app_localizations.dart';

String labelForClaim(AppLocalizations l, String id, String stored) =>
    switch (id) {
      'rent' => l.claimRent,
      'card-minimum' => l.claimCardMinimum,
      'essentials' => l.claimEssentials,
      'buffer' => l.claimBuffer,
      _ => stored,
    };
